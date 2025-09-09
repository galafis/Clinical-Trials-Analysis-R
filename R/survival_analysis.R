#' Análise de Sobrevivência (Kaplan-Meier) para Ensaios Clínicos
#'
#' Realiza a curva de sobrevivência de Kaplan-Meier e plota os resultados.
#'
#' @param data Data frame com colunas de tempo, evento e grupo
#' @param time Nome da coluna de tempo
#' @param event Nome da coluna de status evento (0=censurado, 1=evento)
#' @param group Nome da coluna de grupo/tratamento
#' @return Objeto 'survfit'
#' @examples
#' df <- data.frame(time=abs(rnorm(30,12,5)), event=rbinom(30,1,0.6), group=rep(c('A','B'), 15))
#' km <- run_km(df, "time", "event", "group")
#' @export
run_km <- function(data, time, event, group) {
  library(survival)
  surv_obj <- Surv(data[[time]], data[[event]])
  fit <- survfit(surv_obj ~ data[[group]])
  plot(fit, col=2:3, main="Kaplan-Meier Curve", xlab="Tempo", ylab="Probabilidade de Sobrevivência")
  return(fit)
}
