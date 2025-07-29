# Clinical Trials Analysis R

![R](https://img.shields.io/badge/R-276DC3?style=flat&logo=r&logoColor=white)
![RStudio](https://img.shields.io/badge/RStudio-75AADB?style=flat&logo=rstudio&logoColor=white)
![ggplot2](https://img.shields.io/badge/ggplot2-276DC3?style=flat&logo=r&logoColor=white)
![dplyr](https://img.shields.io/badge/dplyr-276DC3?style=flat&logo=r&logoColor=white)
![Shiny](https://img.shields.io/badge/Shiny-276DC3?style=flat&logo=r&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

Sistema profissional de análise de ensaios clínicos desenvolvido em R, oferecendo modelagem estatística avançada, análise de sobrevivência, visualizações interativas e relatórios automatizados para pesquisa clínica e farmacêutica.

## 🎯 Visão Geral

Plataforma completa para análise de dados de ensaios clínicos que implementa metodologias estatísticas rigorosas, análises de eficácia e segurança, visualizações regulamentares e relatórios em conformidade com diretrizes ICH e FDA para suporte à tomada de decisões em pesquisa clínica.

### ✨ Características Principais

- **📊 Análise Estatística Avançada**: Testes paramétricos e não-paramétricos
- **⏱️ Análise de Sobrevivência**: Kaplan-Meier, Cox Regression, Log-rank
- **🔬 Análise de Eficácia**: Endpoints primários e secundários
- **⚠️ Análise de Segurança**: Eventos adversos e análise de toxicidade
- **📈 Visualizações Regulamentares**: Gráficos em conformidade com FDA/EMA
- **📋 Relatórios Automatizados**: Relatórios CSR e estatísticos
- **🎛️ Dashboard Interativo**: Interface Shiny para exploração de dados

## 🛠️ Stack Tecnológico

### Core R Packages
- **R 4.3+**: Linguagem estatística principal
- **dplyr**: Manipulação de dados
- **ggplot2**: Visualizações estatísticas
- **tidyr**: Organização de dados

### Clinical Analysis
- **survival**: Análise de sobrevivência
- **survminer**: Visualizações de sobrevivência
- **meta**: Meta-análises
- **pwr**: Cálculos de poder estatístico

### Reporting & Visualization
- **shiny**: Dashboards interativos
- **plotly**: Gráficos interativos
- **DT**: Tabelas interativas
- **rmarkdown**: Relatórios dinâmicos
- **knitr**: Geração de relatórios

### Statistical Testing
- **car**: Análises de regressão avançadas
- **emmeans**: Médias marginais estimadas
- **lme4**: Modelos lineares mistos
- **nlme**: Modelos não-lineares mistos

## 📁 Estrutura do Projeto

```
Clinical-Trials-Analysis-R/
├── R/                              # Scripts R principais
│   ├── data_processing.R           # Processamento de dados
│   ├── statistical_analysis.R     # Análises estatísticas
│   ├── survival_analysis.R        # Análise de sobrevivência
│   ├── safety_analysis.R          # Análise de segurança
│   ├── efficacy_analysis.R        # Análise de eficácia
│   ├── visualization.R            # Visualizações
│   └── reporting.R                 # Geração de relatórios
├── data/                           # Dados de entrada
│   ├── raw/                        # Dados brutos
│   ├── processed/                  # Dados processados
│   └── external/                   # Dados externos
├── outputs/                        # Resultados gerados
│   ├── figures/                    # Gráficos e visualizações
│   ├── tables/                     # Tabelas estatísticas
│   ├── reports/                    # Relatórios finais
│   └── datasets/                   # Datasets derivados
├── shiny_app/                      # Aplicação Shiny
│   ├── ui.R                        # Interface do usuário
│   ├── server.R                    # Lógica do servidor
│   └── global.R                    # Configurações globais
├── rmarkdown/                      # Templates de relatórios
│   ├── csr_template.Rmd            # Template CSR
│   ├── statistical_report.Rmd     # Relatório estatístico
│   └── safety_report.Rmd          # Relatório de segurança
├── tests/                          # Testes automatizados
├── docs/                           # Documentação
├── main.R                          # Script principal
├── config.R                        # Configurações
└── README.md                       # Documentação
```

## 🚀 Quick Start

### Pré-requisitos

- R 4.3 ou superior
- RStudio (recomendado)
- Rtools (Windows) ou ferramentas de desenvolvimento (Mac/Linux)

### Instalação

1. **Clone o repositório:**
```bash
git clone https://github.com/galafis/Clinical-Trials-Analysis-R.git
cd Clinical-Trials-Analysis-R
```

2. **Instale as dependências:**
```r
# Instalar pacotes necessários
install.packages(c(
  "dplyr", "ggplot2", "tidyr", "survival", "survminer",
  "shiny", "plotly", "DT", "rmarkdown", "knitr",
  "car", "emmeans", "lme4", "meta", "pwr"
))
```

3. **Execute a análise:**
```r
# Carregar e executar análise principal
source("main.R")
```

4. **Inicie o dashboard:**
```r
# Executar aplicação Shiny
shiny::runApp("shiny_app/")
```

## 📊 Funcionalidades Detalhadas

### 🔬 Análise de Eficácia

```r
# Análise de endpoint primário
analyze_primary_endpoint <- function(data, treatment_var, endpoint_var) {
  # Teste t para diferença entre grupos
  t_test_result <- t.test(
    data[[endpoint_var]][data[[treatment_var]] == "Treatment"],
    data[[endpoint_var]][data[[treatment_var]] == "Control"]
  )
  
  # Análise de covariância (ANCOVA)
  ancova_model <- lm(
    as.formula(paste(endpoint_var, "~", treatment_var, "+ baseline_value + age + gender")),
    data = data
  )
  
  # Cálculo do tamanho do efeito
  effect_size <- cohen.d(
    data[[endpoint_var]][data[[treatment_var]] == "Treatment"],
    data[[endpoint_var]][data[[treatment_var]] == "Control"]
  )
  
  return(list(
    t_test = t_test_result,
    ancova = summary(ancova_model),
    effect_size = effect_size
  ))
}
```

### ⏱️ Análise de Sobrevivência

```r
# Análise de Kaplan-Meier
perform_survival_analysis <- function(data, time_var, event_var, group_var) {
  # Criar objeto de sobrevivência
  surv_object <- Surv(data[[time_var]], data[[event_var]])
  
  # Ajustar modelo de Kaplan-Meier
  km_fit <- survfit(surv_object ~ data[[group_var]])
  
  # Teste log-rank
  logrank_test <- survdiff(surv_object ~ data[[group_var]])
  
  # Modelo de Cox
  cox_model <- coxph(surv_object ~ data[[group_var]] + age + gender, data = data)
  
  # Visualização
  km_plot <- ggsurvplot(
    km_fit,
    data = data,
    pval = TRUE,
    conf.int = TRUE,
    risk.table = TRUE,
    risk.table.col = "strata",
    ggtheme = theme_minimal()
  )
  
  return(list(
    km_fit = km_fit,
    logrank_test = logrank_test,
    cox_model = cox_model,
    plot = km_plot
  ))
}
```

### ⚠️ Análise de Segurança

```r
# Análise de eventos adversos
analyze_safety <- function(ae_data, exposure_data) {
  # Taxa de incidência de eventos adversos
  ae_incidence <- ae_data %>%
    group_by(treatment_group, ae_term) %>%
    summarise(
      n_events = n(),
      n_patients = n_distinct(patient_id),
      .groups = "drop"
    ) %>%
    left_join(
      exposure_data %>% 
        group_by(treatment_group) %>% 
        summarise(total_patients = n_distinct(patient_id)),
      by = "treatment_group"
    ) %>%
    mutate(
      incidence_rate = n_patients / total_patients * 100,
      events_per_patient = n_events / n_patients
    )
  
  # Análise de severidade
  severity_analysis <- ae_data %>%
    group_by(treatment_group, severity) %>%
    summarise(
      count = n(),
      percentage = n() / nrow(ae_data) * 100,
      .groups = "drop"
    )
  
  # Teste de Fisher para diferenças entre grupos
  fisher_tests <- ae_data %>%
    group_by(ae_term) %>%
    do(
      fisher_test = fisher.test(
        table(.$treatment_group, .$occurred)
      )
    )
  
  return(list(
    incidence = ae_incidence,
    severity = severity_analysis,
    fisher_tests = fisher_tests
  ))
}
```

### 📈 Visualizações Regulamentares

```r
# Gráfico de floresta para meta-análise
create_forest_plot <- function(meta_data) {
  forest_plot <- ggplot(meta_data, aes(x = estimate, y = study)) +
    geom_point(size = 3) +
    geom_errorbarh(aes(xmin = ci_lower, xmax = ci_upper), height = 0.2) +
    geom_vline(xintercept = 1, linetype = "dashed", color = "red") +
    scale_x_log10() +
    labs(
      title = "Forest Plot - Treatment Effect",
      x = "Hazard Ratio (95% CI)",
      y = "Study"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
      axis.text = element_text(size = 12),
      axis.title = element_text(size = 12, face = "bold")
    )
  
  return(forest_plot)
}

# Gráfico de cascata para resposta tumoral
create_waterfall_plot <- function(response_data) {
  waterfall_plot <- ggplot(response_data, aes(x = reorder(patient_id, change_from_baseline))) +
    geom_col(aes(y = change_from_baseline, fill = response_category)) +
    geom_hline(yintercept = c(-30, 20), linetype = "dashed", color = "black") +
    scale_fill_manual(
      values = c("Complete Response" = "darkgreen",
                 "Partial Response" = "lightgreen",
                 "Stable Disease" = "yellow",
                 "Progressive Disease" = "red")
    ) +
    labs(
      title = "Waterfall Plot - Best Overall Response",
      x = "Patients",
      y = "Change from Baseline (%)",
      fill = "Response Category"
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank()
    )
  
  return(waterfall_plot)
}
```

## 🎛️ Dashboard Interativo

### Interface Shiny

```r
# ui.R
ui <- fluidPage(
  titlePanel("Clinical Trials Analysis Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload Clinical Data",
                accept = c(".csv", ".xlsx")),
      
      selectInput("endpoint", "Primary Endpoint:",
                  choices = NULL),
      
      selectInput("treatment", "Treatment Variable:",
                  choices = NULL),
      
      checkboxGroupInput("covariates", "Covariates:",
                         choices = NULL),
      
      actionButton("analyze", "Run Analysis", class = "btn-primary")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Summary", 
                 h3("Study Summary"),
                 DT::dataTableOutput("summary_table")),
        
        tabPanel("Efficacy",
                 h3("Efficacy Analysis"),
                 plotlyOutput("efficacy_plot"),
                 verbatimTextOutput("efficacy_stats")),
        
        tabPanel("Safety",
                 h3("Safety Analysis"),
                 plotlyOutput("ae_plot"),
                 DT::dataTableOutput("ae_table")),
        
        tabPanel("Survival",
                 h3("Survival Analysis"),
                 plotOutput("km_plot"),
                 verbatimTextOutput("cox_summary"))
      )
    )
  )
)
```

## 📋 Relatórios Automatizados

### Template CSR (Clinical Study Report)

```r
# Gerar relatório CSR
generate_csr_report <- function(study_data, output_file) {
  rmarkdown::render(
    "rmarkdown/csr_template.Rmd",
    params = list(
      data = study_data,
      study_title = "Phase III Randomized Clinical Trial",
      protocol_number = "PROTO-2024-001"
    ),
    output_file = output_file
  )
}
```

## 🧪 Validação e Testes

### Testes Estatísticos

```r
# Teste de normalidade
test_normality <- function(data, variables) {
  normality_tests <- map(variables, ~{
    shapiro.test(data[[.x]])
  })
  names(normality_tests) <- variables
  return(normality_tests)
}

# Validação de dados
validate_clinical_data <- function(data) {
  validations <- list(
    missing_values = map_dbl(data, ~sum(is.na(.x))),
    data_types = map_chr(data, class),
    outliers = map(select_if(data, is.numeric), ~{
      Q1 <- quantile(.x, 0.25, na.rm = TRUE)
      Q3 <- quantile(.x, 0.75, na.rm = TRUE)
      IQR <- Q3 - Q1
      outliers <- which(.x < (Q1 - 1.5 * IQR) | .x > (Q3 + 1.5 * IQR))
      return(length(outliers))
    })
  )
  
  return(validations)
}
```

## 📊 Casos de Uso

### 1. Ensaios Clínicos Fase III
- Análise de eficácia de novos medicamentos
- Comparação com tratamento padrão
- Análise de não-inferioridade

### 2. Estudos de Segurança
- Monitoramento de eventos adversos
- Análise de dose-resposta
- Avaliação de toxicidade

### 3. Meta-análises
- Combinação de resultados de múltiplos estudos
- Análise de heterogeneidade
- Avaliação de viés de publicação

### 4. Análises Regulamentares
- Submissões para FDA/EMA
- Relatórios de segurança periódicos
- Análises post-marketing

## 🔧 Configuração

### Arquivo de Configuração

```r
# config.R
CLINICAL_CONFIG <- list(
  alpha_level = 0.05,
  power = 0.80,
  effect_size = 0.5,
  dropout_rate = 0.15,
  interim_analyses = 2,
  
  # Configurações de relatório
  report_format = "html",
  figure_width = 10,
  figure_height = 8,
  
  # Configurações de segurança
  ae_coding_dictionary = "MedDRA",
  severity_levels = c("Mild", "Moderate", "Severe", "Life-threatening"),
  
  # Configurações de eficácia
  primary_endpoint_type = "continuous",
  analysis_population = "ITT",  # Intent-to-treat
  missing_data_method = "LOCF"  # Last observation carried forward
)
```

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👨‍💻 Autor

**Gabriel Demetrios Lafis**

- GitHub: [@galafis](https://github.com/galafis)
- Email: gabrieldemetrios@gmail.com

---

⭐ Se este projeto foi útil, considere deixar uma estrela!

