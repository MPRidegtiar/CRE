#' @title
#' Interpret Select Rules
#'
#' @description
#' Replace the column numbers in the Select Rules vector with their real names
#'
#' @param select_rules_dis a vector of select causal rules
#' @param X_names the real names of the covariates
#'
#' @return a vector of select causal rules that are interpretable
#'
#' @export
#'
#' @examples
#' dataset_cont <- generate_cre_dataset(n = 1000, rho = 0, n_rules = 2,
#'                                      effect_size = 2, binary = FALSE)
#'
#' # Initialize parameters
#' y <- abs(dataset_cont[["y"]])
#' z <- dataset_cont[["z"]]
#' X <- as.data.frame(dataset_cont[["X"]])
#' X_names <- names(as.data.frame(X))
#' ratio_dis <- 0.25
#' ite_method_dis <- "bcf"
#' include_ps_dis <- NA
#' ntrees_rf <- 100
#' ntrees_gbm <- 50
#' min_nodes <- 20
#' max_nodes <- 5
#' t <- 0.025
#' q <- 0.8
#' rules_method <- NA
#' include_offset <- FALSE
#' offset_name <- NA
#' binary <- FALSE
#'
#' # Split data
#' X <- as.matrix(X)
#' y <- as.matrix(y)
#' z <- as.matrix(z)
#' subgroups <- split_data(y, z, X, ratio_dis)
#' discovery <- subgroups[[1]]
#' inference <- subgroups[[2]]
#'
#' # Generate y, z, and X for discovery and inference data
#' y_dis <- discovery[,1]
#' z_dis <- discovery[,2]
#' X_dis <- discovery[,3:ncol(discovery)]
#'
#' # Estimate ITE on Discovery Subsample
#' ite_list_dis <- estimate_ite(y_dis, z_dis, X_dis, ite_method_dis, include_ps_dis,
#'                              binary, X_names, include_offset, offset_name)
#' ite_dis <- ite_list_dis[["ite"]]
#' ite_std_dis <- ite_list_dis[["ite_std"]]
#'
#' # Generate rules list
#' initial_rules_dis <- generate_rules(X_dis, ite_std_dis, ntrees_rf, ntrees_gbm,
#'                                     min_nodes, max_nodes)
#'
#' # Generate rules matrix
#' rules_all_dis <- generate_rules_matrix(X_dis, initial_rules_dis, t)
#' rules_matrix_dis <- rules_all_dis[["rules_matrix"]]
#' rules_matrix_std_dis <- rules_all_dis[["rules_matrix_std"]]
#' rules_list_dis <- rules_all_dis[["rules_list"]]
#'
#' # Select important rules
#' select_rules_dis <- as.character(select_causal_rules(rules_matrix_std_dis, rules_list_dis,
#'                                                      ite_std_dis, binary, q, rules_method))
#' select_rules_matrix_dis <- rules_matrix_dis[,which(rules_list_dis %in% select_rules_dis)]
#' select_rules_matrix_std_dis <- rules_matrix_std_dis[,which(rules_list_dis %in% select_rules_dis)]
#' if (length(select_rules_dis) == 0) stop("No significant rules were discovered. Ending Analysis.")
#'
#' # Estimate CATE
#' rules_matrix_inf <- matrix(0, nrow = dim(X_inf)[1], ncol = length(select_rules_dis))
#' for (i in 1:length(select_rules_dis)) {
#'   rules_matrix_inf[eval(parse(text = select_rules_dis[i]), list(X = X_inf)), i] <- 1
#' }
#' select_rules_interpretable <- interpret_select_rules(select_rules_dis, X_names)
#'
interpret_select_rules <- function(select_rules_dis, X_names) {
  replacements <- X_names
  names(replacements) <- paste("X[,", 1:length(X_names), "]", sep = "")
  n_rules <- length(select_rules_dis)
  select_rules_interpretable <- vector(length = n_rules)
  for (j in 1:n_rules) {
    select_rules_interpretable[j] <- stringr::str_replace_all(select_rules_dis[j],
                                                              stringr::fixed(replacements))
  }
  return(select_rules_interpretable)
}
