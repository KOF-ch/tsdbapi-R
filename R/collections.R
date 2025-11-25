
collection_base_url <- function(collection, owner) {
  paste0(base_url(), "collections/", owner, "/", collection, "/")
}

#' Read information on existing time series collections.
#'
#' @family time series collection functions
#' @return table with a row for every existing collection
#' @export
list_collections <- function(owner = "self") {
  
  url <- paste0(base_url(), "collections/", if(is.null(owner)) "" else owner)
  res <- req_base(url) |> httr2::req_perform()
  jsonlite::fromJSON(httr2::resp_body_string(res))
}

#' Create a time series collection.
#'
#' @family time series collection functions
#' @param collection name of the collection to create
#' @param description description of the collection
#' @param owner username of the owner of the collection. By default, the username of the authenticating user is taken.
#' @export
create_collection <- function(collection, description, owner = "self") {
  
  url <- collection_base_url(collection, owner)
  
  data <- list(description = description)
  
  res <- req_base(url) |>
    httr2::req_method("PUT") |> 
    httr2::req_body_json(data) |>
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Delete an existing time series collection.
#'
#' @inheritParams param_defs
#' @family time series collection functions
#' @export
delete_collection <- function(collection, owner = "self") {
  
  url <- collection_base_url(collection, owner)
  
  res <- req_base(url) |>
    httr2::req_method("DELETE") |> 
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
    owner = "self",
    valid_on = Sys.Date(),
    ignore_missing = F) {
  
  url <- paste0(collection_base_url(collection, owner), "ts")
  
  res <- req_base(url) |>
    httr2::req_url_query(
      df="Y-m-d",
      mime="json",
      valid_on=as.character(valid_on),
      ignore_missing=to_bool_query_param(ignore_missing)) |>
    httr2::req_perform()
  
  data <- jsonlite::fromJSON(httr2::resp_body_string(res), simplifyDataFrame = F)
  names(data) <- purrr::map_chr(data, "ts_key")
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
    owner = "self",
    ignore_missing = F) {
  
  locale <- match.arg(locale)
  
  url <- paste0(collection_base_url(collection, owner), "ts/metadata")
  
  res <- req_base(url) |>
    httr2::req_url_query(
      locale=locale,
      ignore_missing=to_bool_query_param(ignore_missing)) |>
    httr2::req_perform()
  
  jsonlite::fromJSON(httr2::resp_body_string(res))
}

#' Read the history of all time series of a time series collection (multiple vintages). The time span is given by the start and end parameter. By default, the entire history is read.
#'
#' @inheritParams param_defs
#' @family time series collection functions
#' @return  List of time series. The name of each time series includes the vintage date, i.e. the date at which the particular version of the series became valid.
#' @export
read_collection_ts_history <- function(
    collection,
    valid_from = as.Date("1900-01-01"),
    valid_to = Sys.Date(),
    owner = "self",
    ignore_missing = F) {
  
  url <- paste0(collection_base_url(collection, owner), "ts/history")
  
  res <- req_base(url) |>
    httr2::req_url_query(
      df="Y-m-d",
      valid_from = as.character(valid_from),
      valid_to = as.character(valid_to),
      ignore_missing=to_bool_query_param(ignore_missing)) |>
    httr2::req_perform()
  
  data <- jsonlite::fromJSON(httr2::resp_body_string(res), simplifyDataFrame = F)
  names(data) <- purrr::map_chr(data, ~paste0(.x$ts_key, "_", .x$validity))
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
    owner = "self") {
  
  url <- paste0(collection_base_url(collection, owner), "keys")
  
  res <- req_base(url) |>
    httr2::req_url_query(mime="csv") |>
    httr2::req_perform()
  
  jsonlite::fromJSON(httr2::resp_body_string(res))
}

#' Adds existing time series (given by their keys) to a time series collection.
#'
#' @inheritParams param_defs
#' @family time series collection functions
#' @export
add_ts_to_collection <- function(
    collection,
    owner = "self",
    ts_keys,
    ignore_missing = F) {
  
  url <- collection_base_url(collection, owner)
  
  data <- list(keys=ts_keys, operation=jsonlite::unbox("add"), ignore_missing=jsonlite::unbox(ignore_missing))
  
  res <- req_base(url) |>
    httr2::req_method("PATCH") |> 
    httr2::req_body_json(data, auto_unbox = F) |>
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
    owner = "self",
    ts_keys) {
  
  url <- collection_base_url(collection, owner)
  
  data <- list(keys=ts_keys, operation=jsonlite::unbox("remove"))
  
  res <- req_base(url) |>
    httr2::req_method("PATCH") |> 
    httr2::req_body_json(data, auto_unbox = F) |>
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Read the time at which time series vintages were written
#'
#' @inheritParams param_defs
#' @family time series functions
#' @return table with update time for every time series key
#' @export
read_collection_ts_update_time <- function(
    collection,
    owner = "self",
    valid_on = Sys.Date(),
    ignore_missing = F) {
  
  url <- paste0(collection_base_url(collection, owner), "ts/update-time")
  
  res <- req_base(url) |>
    httr2::req_url_query(
      valid_on=as.character(valid_on),
      ignore_missing=to_bool_query_param(ignore_missing)) |>
    httr2::req_perform()
  
  jsonlite::fromJSON(httr2::resp_body_string(res))
}

#' Read the release history of time series
#'
#' @inheritParams param_defs
#' @family time series functions
#' @return table with release topic, year, period and time for every time series key and release
#' @export
read_collection_ts_release <- function(
    collection,
    owner = "self",
    valid_on = Sys.Date(),
    ignore_missing = F) {
  
  url <- paste0(collection_base_url(collection, owner), "ts/release")
  
  res <- req_base(url) |>
    httr2::req_url_query(
      valid_on=as.character(valid_on),
      ignore_missing=to_bool_query_param(ignore_missing)) |>
    httr2::req_perform()
  
  jsonlite::fromJSON(httr2::resp_body_string(res))
}

#' Read the release history of time series
#'
#' @inheritParams param_defs
#' @family time series functions
#' @return table with release topic, year, period and time for every time series key and release
#' @export
read_collection_ts_release_history <- function(
    collection,
    owner = "self",
    valid_from = as.Date("1900-01-01"),
    valid_to = Sys.Date(),
    ignore_missing = F) {
  
  url <- paste0(collection_base_url(collection, owner), "ts/release/history")
  
  res <- req_base(url) |>
    httr2::req_url_query(
      valid_from=as.character(valid_from),
      valid_to=as.character(valid_to),
      ignore_missing=to_bool_query_param(ignore_missing)) |>
    httr2::req_perform()
  
  jsonlite::fromJSON(httr2::resp_body_string(res))
}

#' Read the future releases of time series
#'
#' @inheritParams param_defs
#' @family time series functions
#' @return table with release topic, year, period and time for every time series key and future release
#' @export
read_collection_ts_release_future <- function(
    collection,
    owner = "self",
    ignore_missing = F) {
  
  url <- paste0(collection_base_url(collection, owner), "ts/release/future")
  
  res <- req_base(url) |>
    httr2::req_url_query(
      ignore_missing=to_bool_query_param(ignore_missing)) |>
    httr2::req_perform()
  
  jsonlite::fromJSON(httr2::resp_body_string(res))
}
