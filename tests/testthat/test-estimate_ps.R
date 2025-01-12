test_that("Propensity Score Estimated Correctly", {
  # Generate sample data
  set.seed(2021)
  dataset_cont <- generate_cre_dataset(n = 1000, rho = 0, n_rules = 2,
                                       effect_size = 0.5, binary = FALSE)
  z <- dataset_cont[["z"]]
  X <- dataset_cont[["X"]]

  # Incorrect data inputs
  expect_error(estimate_ps(z = "test", X))
  expect_error(estimate_ps(z, X = NA))

  # Correct outputs
  est_ps <- estimate_ps(z, X)
  expect_true(length(est_ps) == length(z))
  expect_true(class(est_ps) == "numeric")
})
