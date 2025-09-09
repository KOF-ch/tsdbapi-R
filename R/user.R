
list_users <- function() {
  url <- paste0(base_url(), "users")
  res <- req_base(url) %>% httr2::req_perform()
  jsonlite::fromJSON(httr2::resp_body_string(res))  
}

list_user_access_sets <- function(username) {
  url <- paste0(base_url(), "users/", username, "/access-sets")
  res <- req_base(url) %>% httr2::req_perform()
  jsonlite::fromJSON(httr2::resp_body_string(res))  
}

add_user_access_sets <- function(
    username,
    access_sets,
    access_type) {
  
  url <- paste0(base_url(), "users/", username, "/access-sets")
  
  data <- list(access_sets=access_sets, operation=unbox("add"), access_type=unbox(access_type))
  
  res <- req_base(url) %>%
    httr2::req_method("PATCH") %>%
    httr2::req_body_json(data, auto_unbox = F) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

remove_user_access_sets <- function(username, access_sets) {
  
  url <- paste0(base_url(), "users/", username, "/access-sets")
  
  data <- list(access_sets=access_sets, operation=unbox("remove"))
  
  res <- req_base(url) %>%
    httr2::req_method("PATCH") %>%
    httr2::req_body_json(data, auto_unbox = F) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

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
