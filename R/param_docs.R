#' Common parameters
#'
#' @param ts_keys \strong{character} vector of time series identifiers.
#' @param valid_on \strong{Date} select the time series vintage with the vintage date equal to or before this date.
#' @param valid_from \strong{Date} start date of the vintage range
#' @param valid_to \strong{Date} end date of the vintage range
#' @param ts_list \strong{list} list of time series of class ts, zoo or xts with names as keys
#' @param access_sets \strong{character} vector of access set names
#' @param access \strong{character} the access level of the time series. This parameter is obsolete once the Time Series DB API v1 is discontinued.
#' @param pre_release_access \strong{character} the access level of the time series before the time of release. This parameter is obsolete once the Time Series DB API v1 is discontinued.

#' @param release_topic \strong{character} topic of the release. E.g. 'kofbaro'.
#' @param release_year \strong{character} year of the release
#' @param release_period \strong{character} period of the release. For monthly releases a number from 1 to 12. For quarterly releases a number from 1 to 4. For half-yearly releases a number from 1 to 2. For yearly releases always 1. 
#' @param release_date \strong{POSIXct} time of the release. This parameter is obsolete once the Time Series DB API v1 is discontinued.

#' @param package_annual_quota annual quota of data service subscription
#' @param current_year_quota quota of the current year. Is set to package_annual_quota at the start of the year.

#' @param dataset \strong{character} name of the dataset. A dataset is a group of time series with a common theme. Every time series can only be a member of a one dataset.

#' @param ignore_missing \strong{boolean} whether to ignore missing or forbidden time series when requesting time series data.

#' @param access_type Must be one of 'oauth' (the default), 'public' or 'preview'. The access types 'public' and 'preview' bypass authentication. Use the access type 'public' to read public time series and the access type 'preview' to read time series previews. Use 'oauth' for authenticated access.

#' @param access_level \strong{character} describing the access level of the time series or dataset.
#' @param regex \strong{boolean} indicating if ts_keys should be interpreted as a regular expression pattern. Defaults to FALSE.
#' @param locale \strong{character} indicating the language of the meta information to be store. We recommend to use ISO country codes to represent languages. Defaults to NULL. When local is set to NULL, metadata are stored without localization. Note that, when localizing meta information by assigning a language, multiple meta information objects can be stored for a single time series.
#' @param chunksize set a limit of the number of time series requested in the function.
#' @param owner \strong{character} Username of the owner of the time series collection.
#' @param collection \strong{character} Name of the time series collection
#' @param username \strong{character} Username of the time series database user.
#' @param description description
#' @param access_set name of the access set. An access set is a group of time series for which a permission (read, read_no_quota, read_before_release, write) can be granted to individual users. Every time series can be a member of multiple access sets.
#' @param access_sets names of the access sets. An access set is a group of time series for which the access type (read, read_before_release, write) can be defined for individual users. Every time series can be a member of multiple access sets.
#' @param permission the permission granted to a user for the time series in a given access set. Must be one of read, read_no_quota, read_before_release or write.
#' @param overwrite \strong{boolean} if true, the existing metadata is replaced completely. If false (default), new fields are added and existing fields are updated.
#' @name param_defs
NULL
