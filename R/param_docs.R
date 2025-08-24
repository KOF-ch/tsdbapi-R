#' Common parameters
#'
#' @param ts_keys \strong{character} vector of time series identifiers.
#' @param dataset \strong{character} name of the dataset. A dataset is a group of time series with a common theme. Every time series can only be a member of a one dataset.
#' @param valid_on \strong{character} representation of a date in the form of 'YYYY-MM-DD'. valid_on selects the
#' version of a time series that is valid at the specified date.
#' @param valid_from character representation of a date in the form of 'YYYY-MM-DD'. valid_from starts a new version
#' @param valid_to end of history
#' @param ignore_missing \strong{boolean} whether missing or forbidden time series should be ignored when requesting time series data.
#' @param access_type \strong{boolean} how to access time series data. Must be one of 'oauth' (the default), 'public' or 'preview'. With 'oauth' (authentication/authorization), you must prove your identity by logging
#' in to your account and you will only have the data access that is granted to that account. With 'public', you only have access to public time series data and with 'preview', you only access to a subset of the time series
#' data for which previews (latest 2 years of data) are allowed. In addition, with 'preview', only a preview of the data with the latest 2 years of data missing will be returned.
#' @param access_level \strong{character} describing the access level of the time series or dataset.
#' @param impersonate \strong{character} impersonate a different user than your own for the request. The users public and preview can be.
#' @param set_name \strong{character} name of a dataset.
#' @param regex \strong{boolean} indicating if ts_keys should be interpreted as a regular expression pattern. Defaults to FALSE.
#' @param locale \strong{character} indicating the language of the meta information to be store. We recommend to use ISO country codes to represent languages. Defaults to NULL. When local is set to NULL, metadata are stored without localization. Note that, when localizing meta information by assigning a language, multiple meta information objects can be stored for a single time series.
#' @param respect_release \strong{boolean} indicating if  should the release embargo of a time series be respected. Defaults to FALSE. This option makes sense when the function is used in an API. In that sense, users do not have direct access to this function and therefore cannot simply switch parameters.
#' @param chunksize set a limit of the number of time series requested in the function.
#' @param owner \strong{character} username of the owner of the time series collection.
#' @param collection \strong{character} name of the time series collection
#' @param user character name of the database user. Defaults to the user of the R session.
#'             this is often the user for the database, too so you do not have to specify
#'             your username explicitly if that is the case.
#' @param description description
#' @param access_set name of the access set. An access set is a group of time series for which the access type (read, read_before_release, write) can be defined for individual users. Every time series can be a member of multiple access sets.
#' @param ts_list list of time series with the keys as names
#' @param access_sets character vector of access set names
#' @param pre_release_access \strong{character} the access level of the time series before the time of the release. This parameter exists for compatibility reasons.
#' @param access \strong{character} the access level of the time series. This parameter exists for compatibility reasons.
#' @param release_id \strong{character} ID of the release
#' @param release_date \strong{character} time of the release. This parameter exists for compatibility reasons.
#' @param overwrite \strong{boolean} if true, the existing metadata is replaced completely. If false (default), new fields are added and existing fields are updated.
#' @name param_defs
NULL
