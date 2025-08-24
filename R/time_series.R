
base_url_ts <- function() {
  paste0(base_url(), "ts/")
}

#' Read time series from the time series database. By default, the function returns the most recent vintage of a time series.
#'
#' @inheritParams param_defs
#' @family time series functions
#' @return List of time series. Regular time series have the class ts and irregular time series the class xts.
#' @export
read_ts <- function(
    ts_keys,
    valid_on = Sys.Date(),
    ignore_missing = F,
    respect_release = F,
    access_type = "oauth") {

  url <- base_url_ts()
  
  res <- req_base(url) %>%
    httr2::req_url_query(
      df="Y-m-d",
      mime="json",
      keys=paste0(ts_keys, collapse = ","),
      valid_on=as.character(valid_on),
      respect_release=to_bool_query_param(respect_release),
      ignore_missing=to_bool_query_param(ignore_missing),
      access_type=access_type) %>%
    httr2::req_perform()
  
  data <- jsonlite::fromJSON(httr2::resp_body_string(res), simplifyDataFrame = F)
  names(data) <- map_chr(data, "ts_key")
  lapply(data, json_to_ts)
}

#' Read the history of time series (multiple vintages). The time span is given by the valid_from and valid_to parameter. By default, the entire history is read.
#'
#' @inheritParams param_defs
#' @family time series functions
#' @return  List of time series. The name of each time series includes the vintage date, i.e. the date at which the particular version of the series became valid.
#' @export
read_ts_history <- function(
    ts_keys,
    valid_from = as.Date("1900-01-01"),
    valid_to = Sys.Date(),
    ignore_missing = F,
    respect_release = F,
    access_type = "oauth") {
  
  url <- paste0(base_url_ts(), "history")
  
  res <- req_base(url) %>%
    httr2::req_url_query(
      df="Y-m-d",
      mime="json",
      keys=paste0(ts_keys, collapse = ","),
      start=as.character(start),
      end=as.character(end),
      respect_release=to_bool_query_param(respect_release),
      ignore_missing=to_bool_query_param(ignore_missing),
      access_type=access_type) %>%
    httr2::req_perform()

  data <- jsonlite::fromJSON(httr2::resp_body_string(res), simplifyDataFrame = F)
  names(data) <- map_chr(data, ~paste0(.x$ts_key, "_", .x$validity))
  lapply(data, json_to_ts)
}

#' Read the metadata of time series. The locale is a required parameter.
#'
#' @inheritParams param_defs
#' @family time series functions
#' @return List of time series metadata. Each list element contains the metadata of a particular time series as a list.
#' @export
read_ts_metadata <- function(
    ts_keys,
    locale = c("en","de","fr","it","unlocalized"),
    ignore_missing = F,
    access_type = "oauth") {
  
  locale <- match.arg(locale)
  
  url <- paste0(base_url_ts(), "metadata")
  
  res <- req_base(url) %>%
    httr2::req_url_query(
      locale=locale, 
      keys=paste0(ts_keys, collapse = ","),
      ignore_missing=to_bool_query_param(ignore_missing),
      access_type=access_type) %>%
    httr2::req_perform()
  
  fromJSON(httr2::resp_body_string(res))
}

#' Write time series into the time series database. 
#'
#' @inheritParams param_defs
#' @family time series functions
#' @export
write_ts <- function(
  ts_list,
  valid_from = Sys.Date(),
  access_sets = character(),
  access = NULL,
  pre_release_access = NULL,
  release_id = NULL,
  release_date = NULL) {
  
  url <- base_url_ts()

  data <- list(
    valid_from=unbox(valid_from),
    release_date=unbox(release_date),
    release_id=unbox(release_id),
    access_sets=access_sets,
    access=unbox(access),
    pre_release_access=unbox(pre_release_access))
  
  data$ts_data <- unname(imap(ts_list, ~{
    freq <- if(is.ts(.x)) frequency(.x) else NULL
    list(ts_key=unbox(.y), frequency=unbox(freq), time=zoo::as.Date(.x), value=as.vector(.x))
  }))
  
  res <- req_base(url) %>%
    httr2::req_method("PUT") %>% 
    httr2::req_body_json(data, auto_unbox = F, null = "null", na = "null") %>% 
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Change the unique identifiers (keys) of time series.
#'
#' @family time series functions
#' @inheritParams param_defs
#' @param ts_keys Existing time series keys
#' @param ts_keys_new New time series keys
#' @export
rename_ts <- function(
    ts_keys,
    ts_keys_new,
    ignore_missing = F) {
  
  url <- paste0(base_url_ts(), "key")
  
  data <- list(
    keys=ts_keys,
    keys_new=ts_keys_new,
    ignore_missing=unbox(to_bool_query_param(ignore_missing)))
  
  res <- req_base(url) %>%
    httr2::req_method("PATCH") %>% 
    httr2::req_body_json(data, auto_unbox = F) %>% 
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Read the time at which time series vintages were written
#'
#' @inheritParams param_defs
#' @family time series functions
#' @return table with update time for every time series key
#' @export
read_ts_update_time <- function(
    ts_keys,
    valid_on = Sys.Date(),
    ignore_missing = F) {
  
  url <- paste0(base_url_ts(), "update-time")
  
  res <- req_base(url) %>%
    httr2::req_url_query(
      keys=paste0(ts_keys, collapse = ","),
      valid_on=as.character(valid_on),
      ignore_missing=to_bool_query_param(ignore_missing)) %>%
    httr2::req_perform()
  
  fromJSON(httr2::resp_body_string(res))
}

#' Read the release ID and the corresponding release date of time series vintages
#'
#' @inheritParams param_defs
#' @family time series functions
#' @return table with release id and release date for every time series key
#' @export
read_ts_release <- function(
    ts_keys,
    valid_on = Sys.Date(),
    ignore_missing = F) {
  
  url <- paste0(base_url_ts(), "release")
  
  res <- req_base(url) %>%
    httr2::req_url_query(
      keys=paste0(ts_keys, collapse = ","),
      valid_on=as.character(valid_on),
      ignore_missing=to_bool_query_param(ignore_missing)) %>%
    httr2::req_perform()
  
  fromJSON(httr2::resp_body_string(res))
}

#' Assign time series vintages to a release (given by the release ID).
#'
#' @inheritParams param_defs
#' @family time series functions 
#' @export
write_ts_release <- function(
  ts_keys,
  release_id,
  valid_on = Sys.Date()) {
  
  url <- paste0(base_url_ts(), "release")
  
  data <- list(
    keys=ts_keys,
    release_id=unbox(release_id),
    valid_on=unbox(as.character(valid_on)))
  
  res <- req_base(url) %>%
    httr2::req_method("PATCH") %>% 
    httr2::req_body_json(data, auto_unbox = F) %>% 
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Write the metadata of time series. The locale is a required parameter.
#'
#' @inheritParams param_defs
#' @family time series functions
#' @param metadata_list List of time series metadata. Each list element contains the metadata of a time series (as a list) and
#' has the key of the time series as its name.
#' @export
write_ts_metadata <- function(
    metadata_list,
    locale = c("en","de","fr","it","unlocalized"),
    valid_from = NULL,
    overwrite = F) {
    
  locale <- match.arg(locale)
  
  url <- paste0(base_url_ts(), "metadata")
  
  data <- list(
    overwrite = to_bool_query_param(overwrite),
    valid_from = valid_from,
    locale = locale,
    metadata = unname(imap(metadata_list, ~{
      list(ts_key=unbox(.y), metadata=.x)
    }))
  )
  
  res <- req_base(url) %>%
    httr2::req_method("PATCH") %>% 
    httr2::req_body_json(data) %>% 
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}

#' Assign time series to a dataset. Every time series can assigned to only one dataset. 
#'
#' @inheritParams param_defs
#' @family time series functions
#' @export
assign_ts_to_dataset <- function(
    ts_keys,
    dataset) {
  
  url <- paste0(base_url_ts(), "dataset")
  
  data <- list(keys=ts_keys, dataset=unbox(dataset))
  
  res <- req_base(url) %>%
    httr2::req_method("PATCH") %>% 
    httr2::req_body_json(data, auto_unbox = F) %>% 
    httr2::req_perform()
  
  cat(httr2::resp_body_json(res)$message)
}


  
