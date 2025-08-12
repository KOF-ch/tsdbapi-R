
#' Read information on existing time series access sets.
#' 
#' @family time series access set functions
#' @return table with a row for every existing access set
#' @export
read_access_sets <- function() {
  
  url <- paste0(base_url(), "access-sets")
  res <- req_base(url) %>% httr2::req_perform()
  fromJSON(httr2::resp_body_string(res))
}

#' Read the keys of the time series in a time series access set.
#'
#' @inheritParams param_defs
#' @family time series access set functions
#' @return character vector of time series keys
#' @export
read_access_set_keys <- function(access_set) {
  
  url <- paste0(base_url(), "access-sets/", access_set, "/keys")
  res <- req_base(url) %>% httr2::req_perform()
  fromJSON(httr2::resp_body_string(res))
}

#' Create a time series access set
#'
#' @inheritParams param_defs
#' @family time series access set functions
#' @export
create_access_set <- function(access_set, description) {
  
  url <- paste0(base_url(), "access-sets/", access_set)
  
  data <- list(description=description)
  
  res <- req_base(url) %>%
    httr2::req_method("PUT") %>% 
    httr2::req_body_json(data) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Delete an existing time series access set
#'
#' @inheritParams param_defs
#' @family time series access set functions
#' @export
delete_access_set <- function(access_set) {
  
  url <- paste0(base_url(), "access-sets/", access_set)
  
  res <- req_base(url) %>%
    httr2::req_method("DELETE") %>% 
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Adds existing time series (given by their keys) to a time series access set.
#'
#' @inheritParams param_defs
#' @family time series access set functions
#' @export
add_ts_to_access_set <- function(access_set, ts_keys, ignore_missing = F) {
  
  url <- paste0(base_url(), "access-sets/", access_set)
  
  data <- list(
    keys=ts_keys,
    operation=unbox("add"),
    ignore_missing=unbox(to_bool_query_param(ignore_missing)))
  
  res <- req_base(url) %>%
    httr2::req_method("PATCH") %>% 
    httr2::req_body_json(data, auto_unbox = F) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Removes time series from a time series access set.
#'
#' @inheritParams param_defs
#' @family time series access set functions
#' @export
remove_ts_from_access_set <- function(access_set, ts_keys) {
  
  url <- paste0(base_url(), "access-sets/", access_set)
  
  data <- list(
    keys=ts_keys,
    operation=unbox("remove"))
  
  res <- req_base(url) %>%
    httr2::req_method("PATCH") %>% 
    httr2::req_body_json(data, auto_unbox = F) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

