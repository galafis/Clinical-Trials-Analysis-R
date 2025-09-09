#' Análise de Eficácia (Modelo ANCOVA para endpoint contínuo)
#'
#' Ajusta um modelo ANCOVA para avaliar efeito do tratamento ajustado pelo valor basal.
#'
#' @param data Data frame com os dados clínicos
#' @param endpoint Nome da coluna do endpoint (ex: resposta clínica)
#' @param treatment Nome da coluna de tratamento/grupo
#' @param baseline Nome da coluna da medida basal
#' @return Resumo do modelo linear (output de summary)
#' @examples
#' df <- data.frame(endpoint=rnorm(30,50,12), treatment=rep(c("A","B"),15), baseline=rnorm(30,48,9))
#' ancova_efficacy(df, "endpoint", "treatment", "baseline")
#' @export
ancova_efficacy <- function(data, endpoint, treatment, baseline) {
  formula <- as.formula(paste(endpoint, "~", treatment, "+", baseline))
  model <- lm(formula, data = data)
  summary(model)
}
