#' Check the number of time series downloads remaining.
#'
#' @return table with quota information
#' @export
user_quota <- function() {

  url <- paste0(base_url(), "info/quota")
  res <- req_base(url) %>% httr2::req_perform()
  jsonlite::fromJSON(httr2::resp_body_string(res))
}

#' Read information on the time series access sets for which the authenticated user has access type read, read_before_release or write.
#'
#' @return table with a row for every access set
#' @export
user_access_sets <- function() {
  
  url <- paste0(base_url(), "info/access-sets")
  res <- req_base(url) %>% httr2::req_perform()
  jsonlite::fromJSON(httr2::resp_body_string(res))
}
