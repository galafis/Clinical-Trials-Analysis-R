#' Geração de Relatório CSR por R Markdown
#'
#' Renderiza automaticamente um template Rmd configurável para relatório clínico completo.
#'
#' @param params Lista de parâmetros para o relatório (ex: data, study_title, protocolo, etc)
#' @param output_file Nome do arquivo de saída (default = "CSR_Report.html")
#' @return Caminho do relatório gerado
#' @examples
#' # render_csr(list(data=iris, study_title="Demo", protocol="PROTO-001"))
#' @export
render_csr <- function(params, output_file = "CSR_Report.html") {
  rmarkdown::render(
    input = "rmarkdown/csr_template.Rmd",
    params = params,
    output_file = output_file
  )
}
