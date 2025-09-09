# =============================================================================
# Clinical Trials Analysis R - Configuration File
# =============================================================================
# Professional clinical trials analysis system configuration
# Author: Gabriel Demetrios Lafis
# License: MIT
# =============================================================================

# Clinical Study Configuration Parameters
CLINICAL_CONFIG <- list(
  # Statistical Parameters
  alpha_level = 0.05,              # Type I error rate
  power = 0.80,                    # Statistical power (1 - Type II error)
  effect_size = 0.5,               # Expected effect size (Cohen's d)
  dropout_rate = 0.15,             # Expected dropout rate (15%)
  interim_analyses = 2,            # Number of planned interim analyses
  
  # Report Generation Settings
  report_format = "html",          # Output format: html, pdf, docx
  figure_width = 10,               # Default figure width (inches)
  figure_height = 8,               # Default figure height (inches)
  figure_dpi = 300,                # Figure resolution for publications
  table_format = "kable",          # Table formatting: kable, gt, DT
  
  # Safety Analysis Configuration
  ae_coding_dictionary = "MedDRA",  # Adverse event coding dictionary
  severity_levels = c("Mild", "Moderate", "Severe", "Life-threatening"),
  sae_reporting_timeframe = 24,     # SAE reporting timeframe (hours)
  
  # Efficacy Analysis Configuration
  primary_endpoint_type = "continuous",  # continuous, binary, time-to-event
  analysis_population = "ITT",           # Intent-to-treat population
  missing_data_method = "LOCF",          # Last observation carried forward
  multiplicity_adjustment = "Bonferroni", # Multiple comparison adjustment
  
  # Survival Analysis Settings
  survival_time_unit = "months",          # Time unit for survival analysis
  confidence_level = 0.95,               # Confidence interval level
  km_plot_style = "ggplot2",             # Kaplan-Meier plot style
  
  # Dashboard Configuration
  shiny_theme = "flatly",                # Bootswatch theme
  max_upload_size = 30,                  # Maximum file upload size (MB)
  plot_height = 600,                     # Default plot height (pixels)
  
  # Data Validation Rules
  patient_id_pattern = "^[A-Z]{2,3}[0-9]{3,4}$", # Patient ID format
  date_format = "%Y-%m-%d",                       # Standard date format
  numeric_precision = 3,                          # Decimal places for results
  
  # Regulatory Compliance
  gcp_compliance = TRUE,                          # Good Clinical Practice
  cfr21_part11 = TRUE,                          # FDA 21 CFR Part 11
  data_integrity_checks = TRUE,                  # ALCOA+ principles
  audit_trail = TRUE,                            # Maintain audit trail
  
  # Performance Settings
  parallel_processing = TRUE,                     # Enable parallel processing
  n_cores = NULL,                                # Auto-detect cores (NULL)
  memory_limit = "8GB",                         # Memory limit for large datasets
  cache_results = TRUE                           # Cache intermediate results
)

# Validation function for configuration
validate_config <- function(config = CLINICAL_CONFIG) {
  # Check required parameters
  required_params <- c("alpha_level", "power", "analysis_population")
  missing_params <- setdiff(required_params, names(config))
  
  if (length(missing_params) > 0) {
    stop("Missing required configuration parameters: ", 
         paste(missing_params, collapse = ", "))
  }
  
  # Validate alpha level
  if (config$alpha_level <= 0 || config$alpha_level >= 1) {
    stop("Alpha level must be between 0 and 1")
  }
  
  # Validate power
  if (config$power <= 0 || config$power >= 1) {
    stop("Power must be between 0 and 1")
  }
  
  # Validate analysis population
  valid_populations <- c("ITT", "PP", "mITT", "Safety")
  if (!config$analysis_population %in% valid_populations) {
    stop("Analysis population must be one of: ", 
         paste(valid_populations, collapse = ", "))
  }
  
  return(TRUE)
}

# Load and validate configuration on source
if (!exists("SKIP_CONFIG_VALIDATION")) {
  validate_config(CLINICAL_CONFIG)
  message("Clinical Trials Analysis configuration loaded successfully")
  message("Analysis Population: ", CLINICAL_CONFIG$analysis_population)
  message("Alpha Level: ", CLINICAL_CONFIG$alpha_level)
  message("Power: ", CLINICAL_CONFIG$power)
}

# Export configuration for use in other scripts
.GlobalEnv$CLINICAL_CONFIG <- CLINICAL_CONFIG
