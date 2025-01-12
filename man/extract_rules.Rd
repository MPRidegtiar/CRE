% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract_rules.R
\name{extract_rules}
\alias{extract_rules}
\title{Extract Rules}
\usage{
extract_rules(treelist, X, ntrees, ite_std, take_1, type_decay)
}
\arguments{
\item{treelist}{a list of decision trees}

\item{X}{the features matrix}

\item{ntrees}{the number of decision trees}

\item{ite_std}{the standardized ITE}

\item{take_1}{whether or not to call the take1 helper function}

\item{type_decay}{the type of decay to apply when pruning the rules}
}
\value{
a vector of causal rules
}
\description{
Method for extracting causal rules from the Random Forest or Gradient Boosting algorithms
}
