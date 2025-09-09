#' Gráfico de Forest Plot para Metanálise ou Efeitos Tratamento
#'
#' Gera um forest plot profissional a partir de efeito estimado e intervalos de confiança.
#'
#' @param df Data frame contendo colunas: study, estimate, ci_low, ci_up
#' @return Objeto ggplot (plot pronto para publicação)
#' @examples
#' df <- data.frame(study=LETTERS[1:5], estimate=runif(5,0.7,1.5), ci_low=runif(5,0.5,0.9), ci_up=runif(5,1.2,1.7))
#' p <- plot_forest(df)
#' print(p)
#' @export
plot_forest <- function(df) {
  library(ggplot2)
  ggplot(df, aes(x=estimate, y=study)) +
    geom_point(size=2.5) +
    geom_errorbarh(aes(xmin=ci_low, xmax=ci_up), height=0.2) +
    geom_vline(xintercept=1, linetype='dashed', color='red') +
    labs(title="Forest Plot - Treatment Effect",
         x="Odds Ratio / Hazard Ratio (IC 95%)",
         y="Estudo") +
    theme_minimal() +
    theme(plot.title=element_text(hjust=0.5, size=14, face="bold"),
          axis.text=element_text(size=12),
          axis.title=element_text(size=12, face="bold"))
}
