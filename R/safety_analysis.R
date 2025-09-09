#' Análise de Segurança: Sumário de Eventos Adversos
#'
#' Gera tabela de incidência de evento adverso por grupo de tratamento.
#'
#' @param ae_data Data frame com colunas: paciente, grupo de tratamento, termo do EA
#' @param patient_col Nome da coluna do paciente
#' @param group_col Nome da coluna de tratamento
#' @param term_col Nome da coluna do termo do evento adverso
#' @return Tabela de frequência cruzada (data.frame)
#' @examples
#' df <- data.frame(paciente=1:20, grupo=rep(c("A","B"),10), termo=sample(c("Nausea","Dor"),20,TRUE))
#' tbl <- ea_summary(df, "paciente", "grupo", "termo")
#' print(tbl)
#' @export
ea_summary <- function(ae_data, patient_col, group_col, term_col) {
  tb <- with(ae_data, table(ae_data[[group_col]], ae_data[[term_col]]))
  incidence <- as.data.frame.matrix(tb)
  colnames(incidence) <- paste0("EA_", colnames(incidence))
  incidence
}
