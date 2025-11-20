
user_base_url <- function(username) {
  paste0(base_url(), "users/", username, "/")
}

#' Show information on TSDB users
#'
#' @returns table with row for every user
#' @family user management functions
#' @export
list_users <- function() {
  url <- paste0(base_url(), "users")
  res <- req_base(url) %>% httr2::req_perform()
  jsonlite::fromJSON(httr2::resp_body_string(res))  
}

#' Title
#'
#' @param role 
#' @export
create_user <- function(username, role) {
  
  url <- user_base_url(username)
  data <- list(role=role)
  
  res <- req_base(url) %>%
    httr2::req_method("PUT") %>%
    httr2::req_body_json(data) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' List the access sets and associated permissions of a particular user.
#'
#' @inheritParams param_defs 
#' @returns table with a row for every user access set
#' @family user management functions
#' @export
list_user_access_sets <- function(username = "self") {
  url <- paste0(user_base_url(username), "access-sets")
  res <- req_base(url) %>% httr2::req_perform()
  jsonlite::fromJSON(httr2::resp_body_string(res))  
}

#' Add access sets with the given permission for a user.
#'
#' @inheritParams param_defs
#' @family user management functions
#' @export
add_user_access_sets <- function(
    username = "self",
    access_sets,
    permission) {
  
  url <- paste0(user_base_url(username), "access-sets")
  
  data <- list(access_sets=access_sets, operation=jsonlite::unbox("add"), permission=jsonlite::unbox(permission))
  
  res <- req_base(url) %>%
    httr2::req_method("PATCH") %>%
    httr2::req_body_json(data, auto_unbox = F) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message, "\n")
}

#' Remove access sets for a user.
#'
#' @inheritParams param_defs
#' @family user management functions
#' @export
remove_user_access_sets <- function(
    username = "self",
    access_sets) {
  
  url <- paste0(user_base_url(username), "access-sets")
  
  data <- list(access_sets=access_sets, operation=jsonlite::unbox("remove"))
  
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
read_user_quota <- function(username = "self") {

  url <- paste0(user_base_url(username), "quota")
  res <- req_base(url) %>% httr2::req_perform()
  jsonlite::fromJSON(httr2::resp_body_string(res))
}

#' Create the quota for a new data service subscription
#'
#' @inheritParams param_defs
#' @family user management functions
#' @param package_annual_quota 
#' @param subscription_start_time 
#' @export
create_user_quota <- function(username, package_annual_quota, subscription_start_time) {
  
  url <- paste0(user_base_url(username), "quota")
  data <- list(subscription_start_time=subscription_start_time, package_annual_quota=package_annual_quota)
  
  res <- req_base(url) %>%
    httr2::req_method("PUT") %>%
    httr2::req_body_json(data) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Write the quota for a data service subscriber
#'
#' @inheritParams param_defs
#' @family user management functions
#' @param package_annual_quota
#' @export
write_user_quota <- function(username, current_annual_quota = NULL, package_annual_quota = NULL) {
  
  url <- paste0(user_base_url(username), "quota")
  data <- list(current_annual_quota=current_annual_quota, package_annual_quota=package_annual_quota)
  
  res <- req_base(url) %>%
    httr2::req_method("PATCH") %>%
    httr2::req_body_json(data) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Delete the existing quota of a data service subscriber
#'
#' @inheritParams param_defs
#' @family user management functions
#' @export
delete_user_quota <- function(username) {
  
  url <- paste0(user_base_url(username), "quota")

  res <- req_base(url) %>%
    httr2::req_method("DELETE") %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}
