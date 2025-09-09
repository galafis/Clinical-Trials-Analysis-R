library(testthat)
source("../R/statistical_analysis.R")

test_that("compare_groups retorna resultados coerentes para grupos normais", {
  set.seed(123)
  d <- data.frame(treatment=rep(c("A","B"), each=30), outcome=c(rnorm(30,50,5), rnorm(30,53,5)))
  res <- compare_groups(d, "treatment", "outcome")
  expect_true("diagnostico_normalidade" %in% names(res))
  expect_true("teste" %in% names(res))
  expect_true(res$teste %in% c("t.test","wilcox.test"))
  expect_s3_class(res$resultado, if(res$teste == "t.test") "htest" else "htest")
})

# Teste para erro ao usar mais de dois grupos
test_that("compare_groups lança erro com >2 grupos", {
  d <- data.frame(treatment=rep(c("A","B","C"), each=5), outcome=rnorm(15))
  expect_error(compare_groups(d, "treatment", "outcome"))
})
