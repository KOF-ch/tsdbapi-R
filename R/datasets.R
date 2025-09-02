
#' Read information on existing time series datasets.
#' 
#' @family time series dataset functions
#' @return table with a row for every existing dataset
#' @export
list_datasets <- function() {
  
  url <- paste0(base_url(), "datasets")
  res <- req_base(url) %>% httr2::req_perform()
  jsonlite::fromJSON(httr2::resp_body_string(res))
}

#' Read all time series of a time series dataset
#'
#' @inheritParams param_defs
#' @family time series dataset functions
#' @return List of time series. Regular time series have the class ts and irregular time series the class xts.
#' @export
read_dataset_ts <- function(
    dataset,
    valid_on = Sys.Date(),
    ignore_missing = F) {
  
  url <- paste0(base_url(), "datasets/", dataset, "/ts")
  
  res <- req_base(url) %>%
    httr2::req_url_query(
      df = "Y-m-d",
      mime = "json",
      valid_on = as.character(valid_on),
      ignore_missing = to_bool_query_param(ignore_missing)) %>%
    httr2::req_perform(verbosity = 3)
  
  data <- jsonlite::fromJSON(httr2::resp_body_string(res), simplifyDataFrame = F)
  names(data) <- map_chr(data, "ts_key")
  lapply(data, json_to_ts)
}

#' Create a time series dataset
#'
#' @inheritParams param_defs
#' @family time series dataset functions
#' @export
create_dataset <- function(
    dataset,
    description) {
  url <- paste0(base_url(), "datasets/", dataset_name)
  
  data <- list(description=description)
  
  res <- req_base(url) %>%
    httr2::req_method("PUT") %>% 
    httr2::req_body_json(data) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Delete an existing time series dataset
#'
#' @inheritParams param_defs
#' @family time series dataset functions
#' @export
delete_dataset <- function(dataset) {
  url <- paste0(base_url(), "datasets/", dataset_name)
  
  res <- req_base(url) %>%
    httr2::req_method("DELETE") %>% 
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Read the metadata of all time series of a time series dataset.
#'
#' @inheritParams param_defs
#' @family time series dataset functions
#' @return List of time series metadata. Each list element contains the metadata of a particular time series as a list.
#' @export
read_dataset_ts_metadata <- function(
    dataset,
    locale = c("de","en","fr","it","unlocalized"),
    ignore_missing = F) {
  
  locale <- match.arg(locale)
  
  url <- paste0(base_url(), "datasets/", dataset ,"/ts/metadata")
  
  res <- req_base(url) %>%
    httr2::req_url_query(locale = locale, ignore_missing = to_bool_query_param(ignore_missing)) %>%
    httr2::req_perform()
  
  jsonlite::fromJSON(httr2::resp_body_string(res))
}

#' Read the history of all time series of a time series dataset (multiple vintages). The time span is given by the start and end parameter. By default, the entire history is read.
#'
#' @inheritParams param_defs
#' @family time series dataset functions
#' @return  List of time series. The name of each time series includes the vintage date, i.e. the date at which the particular version of the series became valid.
#' @export
read_dataset_ts_history <- function(
    dataset,
    valid_from = as.Date("1900-01-01"),
    valid_to = Sys.Date(),
    ignore_missing = F) {
  
  url <- paste0(base_url(), "datasets/", dataset ,"/ts/history")
  
  res <- req_base(url) %>%
    httr2::req_url_query(
      df = "Y-m-d",
      mime = "json",
      start = as.character(start),
      end = as.character(end),
      ignore_missing = to_bool_query_param(ignore_missing)) %>%
    httr2::req_perform()
  
  data <- jsonlite::fromJSON(httr2::resp_body_string(res), simplifyDataFrame = F)
  names(data) <- map_chr(data, ~paste0(.x$ts_key, "_", .x$validity))
  lapply(data, json_to_ts)
}

#' Read the keys of the time series in a time series dataset.
#'
#' @inheritParams param_defs
#' @family time series datset functions
#' @return character vector of time series keys
#' @export
read_dataset_keys <- function(dataset) {
  
  url <- paste0(base_url(), "datasets/", dataset, "/keys")
  
  res <- req_base(url) %>% 
    httr2::req_url_query(mime="csv") %>%
    httr2::req_perform()
  
  jsonlite::fromJSON(httr2::resp_body_string(res))
}
