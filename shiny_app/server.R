library(shiny)
library(survival)

function(input, output, session) {
  dados <- reactive({
    req(input$dataset)
    read.csv(input$dataset$datapath)
  })
  output$resumo <- renderTable({
    head(dados())
  })
  output$sobrevivencia <- renderPlot({
    d <- dados()
    if (all(c("time", "event", "treatment") %in% names(d))) {
      fit <- survfit(Surv(time, event) ~ treatment, data = d)
      plot(fit, col=2:3, main="Kaplan-Meier Curve")
    } else {
      plot(1, type="n", axes=FALSE, ann=FALSE)
      text(1,1,"Faltam colunas obrigatórias")
    }
  })
  output$eficacia <- renderPrint({
    d <- dados()
    if (all(c("outcome", "treatment") %in% names(d))) {
      print(t.test(d$outcome ~ d$treatment))
    } else {
      cat("Faltam colunas para análise de eficácia.")
    }
  })
}
