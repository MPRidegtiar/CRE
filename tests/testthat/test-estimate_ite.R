test_that("ITE Estimated Correctly", {
  # Generate sample data
  set.seed(2021)
  dataset_cont <- generate_cre_dataset(n = 1000, rho = 0, n_rules = 2,
                                       effect_size = 0.5, binary = TRUE)
  y <- dataset_cont[["y"]]
  z <- dataset_cont[["z"]]
  X <- dataset_cont[["X"]]
  X_names <- names(as.data.frame(X))
  ite_method <- "bart"
  include_ps <- TRUE
  binary <- TRUE
  include_offset <- FALSE
  offset_name <- NA

  # Incorrect data inputs
  expect_error(estimate_ite(y = "test", z, X, ite_method, include_ps, binary,
                            X_names, include_offset, offset_name))
  expect_error(estimate_ite(y, z = "test", X, ite_method, include_ps, binary,
                            X_names, include_offset, offset_name))
  expect_error(estimate_ite(y, z, X = NA, ite_method, include_ps, binary,
                            X_names, include_offset, offset_name))

  # Incorrect ite_method input
  expect_error(estimate_ite(y, z, X, ite_method = NA, include_ps, binary,
                            X_names, include_offset, offset_name))

  # Incorrect include_ps input
  expect_error(estimate_ite(y, z, X, ite_method, include_ps = "test", binary,
                            X_names, include_offset, offset_name))

  # Incorrect binary input
  expect_error(estimate_ite(y, z, X, ite_method, include_ps, binary = "test",
                            X_names, include_offset, offset_name))

  # Correct outputs
  ite_result <- estimate_ite(y, z, X, ite_method, include_ps, binary,
                             X_names, include_offset, offset_name)
  expect_true(length(ite_result) == 3)
  expect_true(class(ite_result[[1]]) == "numeric")
  expect_true(class(ite_result[[2]]) == "numeric")
  expect_true(class(ite_result[[3]]) == "numeric")
  expect_true(length(ite_result[[1]]) == length(y))
  expect_true(length(ite_result[[2]]) == length(y))
  expect_true(length(ite_result[[3]]) == length(y))
  expect_true(length(unique(ite_result[[1]])) %in% c(1, 2, 3))
})
