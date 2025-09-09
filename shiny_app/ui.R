library(shiny)
fluidPage(
  titlePanel("Clinical Trials Analysis Dashboard"),
  fileInput("dataset", "Envie seu arquivo CSV de dados clínicos:"),
  actionButton("analisar", "Analisar"),
  tabsetPanel(
    tabPanel("Resumo", tableOutput("resumo")),
    tabPanel("Sobrevivência", plotOutput("sobrevivencia")),
    tabPanel("Eficácia", verbatimTextOutput("eficacia"))
  )
)
