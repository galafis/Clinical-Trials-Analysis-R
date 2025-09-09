# =============================================================================
# Clinical Trials Analysis R - Data Processing Module
# =============================================================================
# Professional data processing functions for clinical trial data
# Author: Gabriel Demetrios Lafis
# License: MIT
# =============================================================================

# Load required libraries
library(dplyr)
library(tidyr)
library(readr)
library(readxl)
library(stringr)
library(lubridate)
library(janitor)
library(haven)

# Load configuration
source("config.R")

#' Load Clinical Data
#' 
#' @param file_path Path to the clinical data file
#' @param file_type Type of file ("csv", "xlsx", "sas", "spss")
#' @return data.frame Clinical data
#' @export
load_clinical_data <- function(file_path, file_type = "csv") {
  
  # Validate file existence
  if (!file.exists(file_path)) {
    stop(paste("File not found:", file_path))
  }
  
  # Load based on file type
  data <- switch(file_type,
    "csv" = read_csv(file_path, show_col_types = FALSE),
    "xlsx" = read_excel(file_path),
    "sas" = read_sas(file_path),
    "spss" = read_spss(file_path),
    stop("Unsupported file type. Use 'csv', 'xlsx', 'sas', or 'spss'")
  )
  
  # Clean column names
  data <- clean_names(data)
  
  # Log data loading
  message(paste("Loaded", nrow(data), "rows and", ncol(data), "columns from", file_path))
  
  return(data)
}

#' Clean and Standardize Clinical Data
#' 
#' @param data Raw clinical data
#' @return data.frame Cleaned clinical data
#' @export
clean_clinical_data <- function(data) {
  
  # Standardize patient IDs
  if ("patient_id" %in% names(data)) {
    data <- data %>%
      mutate(patient_id = str_to_upper(str_trim(patient_id)))
  }
  
  # Standardize dates
  date_cols <- names(data)[str_detect(names(data), "date|time")]
  for (col in date_cols) {
    data[[col]] <- as.Date(data[[col]], format = CLINICAL_CONFIG$date_format)
  }
  
  # Standardize treatment groups
  if ("treatment_group" %in% names(data)) {
    data <- data %>%
      mutate(treatment_group = str_to_title(str_trim(treatment_group)))
  }
  
  # Convert character variables to factors where appropriate
  char_cols <- names(data)[sapply(data, is.character)]
  for (col in char_cols) {
    unique_vals <- length(unique(data[[col]][!is.na(data[[col]])]))
    if (unique_vals <= 20) {  # Convert to factor if <= 20 unique values
      data[[col]] <- as.factor(data[[col]])
    }
  }
  
  message("Clinical data cleaned successfully")
  return(data)
}

#' Validate Clinical Data
#' 
#' @param data Clinical data to validate
#' @return list Validation results
#' @export
validate_clinical_data <- function(data) {
  
  validation_results <- list()
  
  # Check for required columns
  required_cols <- c("patient_id", "treatment_group")
  missing_cols <- setdiff(required_cols, names(data))
  validation_results$missing_required_columns <- missing_cols
  
  # Check patient ID format
  if ("patient_id" %in% names(data)) {
    invalid_ids <- data$patient_id[!str_detect(data$patient_id, 
                                               CLINICAL_CONFIG$patient_id_pattern)]
    validation_results$invalid_patient_ids <- invalid_ids[!is.na(invalid_ids)]
  }
  
  # Check for duplicated patient IDs
  if ("patient_id" %in% names(data)) {
    duplicate_ids <- data$patient_id[duplicated(data$patient_id)]
    validation_results$duplicate_patient_ids <- duplicate_ids
  }
  
  # Check data completeness
  missing_data <- sapply(data, function(x) sum(is.na(x)))
  validation_results$missing_data_summary <- missing_data[missing_data > 0]
  
  # Check numeric ranges
  numeric_cols <- names(data)[sapply(data, is.numeric)]
  validation_results$numeric_ranges <- sapply(numeric_cols, function(col) {
    list(min = min(data[[col]], na.rm = TRUE),
         max = max(data[[col]], na.rm = TRUE),
         mean = mean(data[[col]], na.rm = TRUE))
  })
  
  return(validation_results)
}

#' Create Analysis-Ready Dataset
#' 
#' @param data Clean clinical data
#' @param analysis_population Population for analysis ("ITT", "PP", "Safety")
#' @return data.frame Analysis-ready dataset
#' @export
create_analysis_dataset <- function(data, analysis_population = "ITT") {
  
  # Filter based on analysis population
  if (analysis_population == "ITT") {
    # Intent-to-treat: all randomized patients
    analysis_data <- data %>%
      filter(!is.na(treatment_group))
  } else if (analysis_population == "PP") {
    # Per-protocol: patients who completed treatment per protocol
    analysis_data <- data %>%
      filter(!is.na(treatment_group), 
             protocol_deviation == FALSE | is.na(protocol_deviation))
  } else if (analysis_population == "Safety") {
    # Safety: all patients who received at least one dose
    analysis_data <- data %>%
      filter(!is.na(treatment_group), 
             received_treatment == TRUE | is.na(received_treatment))
  } else {
    stop("Invalid analysis_population. Use 'ITT', 'PP', or 'Safety'")
  }
  
  # Create derived variables
  analysis_data <- analysis_data %>%
    mutate(
      # Age groups
      age_group = case_when(
        age < 18 ~ "<18",
        age >= 18 & age < 65 ~ "18-64",
        age >= 65 ~ ">=65",
        TRUE ~ "Unknown"
      ),
      
      # BMI categories
      bmi_category = case_when(
        bmi < 18.5 ~ "Underweight",
        bmi >= 18.5 & bmi < 25 ~ "Normal",
        bmi >= 25 & bmi < 30 ~ "Overweight",
        bmi >= 30 ~ "Obese",
        TRUE ~ "Unknown"
      )
    )
  
  # Add analysis flags
  analysis_data <- analysis_data %>%
    mutate(
      analysis_population = analysis_population,
      analysis_date = Sys.Date()
    )
  
  message(paste("Created", analysis_population, "analysis dataset with", 
                nrow(analysis_data), "patients"))
  
  return(analysis_data)
}

#' Export Processed Data
#' 
#' @param data Processed data
#' @param output_path Output file path
#' @param format Output format ("csv", "xlsx", "rds")
#' @return NULL
#' @export
export_processed_data <- function(data, output_path, format = "csv") {
  
  # Create output directory if it doesn't exist
  output_dir <- dirname(output_path)
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Export based on format
  switch(format,
    "csv" = write_csv(data, output_path),
    "xlsx" = writexl::write_xlsx(data, output_path),
    "rds" = saveRDS(data, output_path),
    stop("Unsupported format. Use 'csv', 'xlsx', or 'rds'")
  )
  
  message(paste("Data exported to:", output_path))
}

#' Generate Data Processing Summary
#' 
#' @param original_data Original raw data
#' @param processed_data Processed data
#' @return data.frame Processing summary
#' @export
generate_processing_summary <- function(original_data, processed_data) {
  
  summary <- data.frame(
    metric = c("Original rows", "Processed rows", "Rows removed", 
               "Original columns", "Processed columns", "Columns added"),
    value = c(nrow(original_data), nrow(processed_data), 
              nrow(original_data) - nrow(processed_data),
              ncol(original_data), ncol(processed_data),
              ncol(processed_data) - ncol(original_data))
  )
  
  return(summary)
}

# Example usage and testing
if (FALSE) {
  # Load and process clinical data
  raw_data <- load_clinical_data("data/raw/sample_clinical.csv")
  clean_data <- clean_clinical_data(raw_data)
  validation <- validate_clinical_data(clean_data)
  analysis_data <- create_analysis_dataset(clean_data, "ITT")
  
  # Export processed data
  export_processed_data(analysis_data, "data/processed/itt_analysis.csv")
  
  # Generate summary
  summary <- generate_processing_summary(raw_data, analysis_data)
  print(summary)
}

message("Data processing module loaded successfully")
