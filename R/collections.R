
#' Read information on existing time series collections.
#'
#' @family time series collection functions
#' @return table with a row for every existing collection
#' @export
read_collections <- function() {
  
  url <- paste0(base_url(), "collections")
  res <- req_base(url) %>% httr2::req_perform()
  fromJSON(httr2::resp_body_string(res))
}

#' Create a time series collection.
#'
#' @family time series collection functions
#' @param collection name of the collection to create
#' @param description description of the collection
#' @param owner username of the owner of the collection. By default, the username of the authenticating user is taken.
#' @export
create_collection <- function(collection, description, owner = NULL) {
  
  url <- paste0(base_url(), "collections/", collection)
  
  data <- list(description = description)
  
  res <- req_base(url) %>%
    httr2::req_method("PUT") %>% 
    httr2::req_url_query(owner = owner) %>%
    httr2::req_body_json(data) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Delete an existing time series collection.
#'
#' @inheritParams param_defs
#' @family time series collection functions
#' @export
delete_collection <- function(collection, owner = NULL) {
  
  url <- paste0(base_url(), "collections/", collection)
  
  res <- req_base(url) %>%
    httr2::req_method("DELETE") %>% 
    httr2::req_url_query(owner = owner) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Read all time series of a time series collection
#'
#' @inheritParams param_defs
#' @family time series collection functions
#' @export
read_collection_ts <- function(
    collection,
    valid_on = Sys.Date(),
    owner = NULL,
    ignore_missing = F,
    respect_release = F,
    access_type = "oauth") {
  
  url <- paste0(base_url(), "collections/", collection, "/ts")
  
  res <- req_base(url) %>%
    httr2::req_url_query(
      df="Y-m-d",
      mime="json",
      valid_on=as.character(valid_on),
      ignore_missing=to_bool_query_param(ignore_missing),
      access_type=access_type) %>%
    httr2::req_perform()
  
  data <- jsonlite::fromJSON(httr2::resp_body_string(res), simplifyDataFrame = F)
  names(data) <- map_chr(data, "ts_key")
  lapply(data, json_to_ts)
}

#' Read the metadata of all time series of a time series collection.
#'
#' @inheritParams param_defs
#' @family time series collection functions
#' @return List of time series metadata. Each list element contains the metadata of a particular time series as a list.
#' @export
read_collection_ts_metadata <- function(
    collection,
    locale=c("de","en","fr","it","unlocalized"),
    owner = NULL,
    ignore_missing = F,
    access_type = "oauth") {
  
  locale <- match.arg(locale)
  
  url <- paste0(base_url(), "collections/", collection ,"/ts/metadata")
  
  res <- req_base(url) %>%
    httr2::req_url_query(
      locale=locale,
      owner=owner,
      ignore_missing=to_bool_query_param(ignore_missing),
      access_type=access_type) %>%
    httr2::req_perform()
  
  fromJSON(httr2::resp_body_string(res))
}

#' Read the history of all time series of a time series collection (multiple vintages). The time span is given by the start and end parameter. By default, the entire history is read.
#'
#' @inheritParams param_defs
#' @family time series collection functions
#' @return  List of time series. The name of each time series includes the vintage date, i.e. the date at which the particular version of the series became valid.
#' @export
read_collection_ts_history <- function(
    collection,
    history_start_date = as.Date("1900-01-01"),
    end = Sys.Date(),
    owner = NULL,
    ignore_missing = F,
    respect_release = F,
    access_type = "oauth") {
  
  url <- paste0(base_url(), "collections/", collection ,"/ts/history")
  
  res <- req_base(url) %>%
    httr2::req_url_query(
      df="Y-m-d",
      start = as.character(start),
      end = as.character(end),
      owner=owner,
      ignore_missing=to_bool_query_param(ignore_missing),
      access_type=access_type) %>%
    httr2::req_perform()
  
  data <- jsonlite::fromJSON(httr2::resp_body_string(res), simplifyDataFrame = F)
  names(data) <- map_chr(data, ~paste0(.x$ts_key, "_", .x$validity))
  lapply(data, json_to_ts)
}

#' Read the keys of the time series in a time series collection.
#'
#' @inheritParams param_defs
#' @family time series collection functions
#' @return character vector of time series keys
#' @export
read_collection_keys <- function(
    collection,
    owner = NULL) {
  
  url <- paste0(base_url(), "collections/", collection, "/keys")
  
  res <- req_base(url) %>%
    httr2::req_url_query(mime="csv", owner=owner) %>%
    httr2::req_perform()
  
  fromJSON(httr2::resp_body_string(res))
}

#' Adds existing time series (given by their keys) to a time series collection.
#'
#' @inheritParams param_defs
#' @family time series collection functions
#' @export
add_ts_to_collection <- function(
    collection,
    ts_keys,
    owner = NULL,
    ignore_missing = F) {
  
  url <- paste0(base_url(), "collections/", collection)
  
  data <- list(keys=ts_keys, operation=unbox("add"), ignore_missing=unbox(ignore_missing))
  
  res <- req_base(url) %>%
    httr2::req_method("PATCH") %>% 
    httr2::req_url_query(owner=owner) %>%
    httr2::req_body_json(data, auto_unbox = F) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Adds time series (given by their keys) from a time series collection.
#'
#' @inheritParams param_defs
#' @family time series collection functions
#' @export
remove_ts_from_collection <- function(
    collection,
    ts_keys,
    owner = NULL) {
  
  url <- paste0(base_url(), "collections/", collection)
  
  data <- list(keys=ts_keys, operation=unbox("remove"))
  
  res <- req_base(url) %>%
    httr2::req_method("PATCH") %>% 
    httr2::req_url_query(owner=owner) %>%
    httr2::req_body_json(data, auto_unbox = F) %>%
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}
