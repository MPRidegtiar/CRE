#' @title
#' Estimate the Individual Treatment Effect using Augmented Inverse Propensity Weighting
#'
#' @description
#' Estimates the Individual Treatment Effect using Augmented Inverse Propensity Weighting given a
#' response vector, a treatment vector, a features matrix, an estimation model for the propensity score
#' and and estimation model for the outcome regressions
#'
#' @param y the observed response vector
#' @param z the treatment vector
#' @param X the features matrix
#' @param method_ps the estimation model for the propensity score
#' @param method_or the estimation model for the outcome regressions
#'
#' @return
#' a list of ITE estimates and standard deviations for the ITE estimates
#'
#' @export
#'
#' @examples
#' dataset <- generate_cre_dataset(n = 1000, rho = 0, n_rules = 2, p = 10, 
#'                                 effect_size = 2, binary = FALSE)
#'
#' # Initialize parameters
#' y <- dataset[["y"]]
#' z <- dataset[["z"]]
#' X <- as.data.frame(dataset[["X"]])
#' method_ps = "SL.xgboost"
#' method_or = "SL.xgboost"
#' 
#' ite_list <- estimate_ite_aipw(y, z, X, method_ps, method_or)
#'


estimate_ite_aipw <- function(y, z, X, method_ps = "SL.xgboost", method_or = "SL.xgboost") {
  phat <- estimate_ps(z, X, method_ps)

  sl_y <- SuperLearner(Y = y, 
                       X = data.frame(X=X, Z=z), 
                       family = gaussian(), 
                       SL.library = method_or, 
                       cvControl = list(V=0))
  
  pred_0 <- predict(sl_y, data.frame(X=X, Z=rep(0, nrow(X))), onlySL = T)
  pred_1 <- predict(sl_y, data.frame(X=X, Z=rep(1, nrow(X))), onlySL = T)

  apo_1 <- pred_1$pred + z*(y - pred_1$pred)/(phat)
  apo_0 <- pred_0$pred + (1 - z)*(y - pred_0$pred)/(1 - phat)
  
  ite <- apo_1 - apo_0

  return(ite) 
}
