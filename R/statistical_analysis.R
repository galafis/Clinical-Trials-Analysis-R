#' Comparação estatística entre grupos clínicos (t-test, Wilcoxon)
#'
#' Esta função aplica automaticamente o teste t de Student (paramétrico) ou o teste de Wilcoxon (não-paramétrico)
#' conforme os pressupostos de normalidade e número de grupos.
#'
#' @param data Data frame contendo os dados
#' @param group Nome (string) da coluna de grupo/tratamento
#' @param var Nome (string) da variável resposta
#' @param paired Booleano: TRUE se amostras pareadas (default: FALSE)
#' @return Lista: resultado do teste, nome do teste utilizado e diagnótico de normalidade
#' @examples
#' d <- data.frame(treatment=rep(c("A","B"),each=15), outcome=rnorm(30))
#' res <- compare_groups(d, "treatment", "outcome")
#' print(res)
#' @export
compare_groups <- function(data, group, var, paired = FALSE) {
  g <- data[[group]]
  y <- data[[var]]
  if (length(unique(na.omit(g))) != 2) stop("Apenas dois grupos suportados!")
  g1 <- y[g == unique(g)[1]]
  g2 <- y[g == unique(g)[2]]
  normal1 <- if(length(g1) > 3) shapiro.test(g1)$p.value > 0.05 else TRUE
  normal2 <- if(length(g2) > 3) shapiro.test(g2)$p.value > 0.05 else TRUE
  test_name <- if(normal1 && normal2) "t.test" else "wilcox.test"
  if(test_name == "t.test") {
    res <- t.test(y ~ g, paired = paired)
  } else {
    res <- wilcox.test(y ~ g, paired = paired)
  }
  list(diagnostico_normalidade = c(unique(g)[1]=normal1, unique(g)[2]=normal2),
       teste = test_name, resultado = res)
}
