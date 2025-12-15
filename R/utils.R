
.onLoad <- function(libname, pkgname) {
  options(
    tsdbapi.oauth_client_id = Sys.getenv("TSDBAPI_OAUTH_CLIENT_ID", unset = "tsdb-api"),
    tsdbapi.oauth_client_token_url = Sys.getenv("TSDBAPI_OAUTH_CLIENT_TOKEN_URL", unset = "https://keycloak.kof.ethz.ch/realms/main/protocol/openid-connect/token"),
    tsdbapi.oauth_client_secret = Sys.getenv("TSDBAPI_OAUTH_CLIENT_SECRET", unset = "6rZ4TmOPbKKa1oWqbPOH4RxFbMCHCEr0g9ybz91jJ5Mt7GIktdrWx5F4KykoukxV"),
    tsdbapi.oauth_auth_url = Sys.getenv("TSDBAPI_OAUTH_AUTH_URL", unset = "https://keycloak.kof.ethz.ch/realms/main/protocol/openid-connect/auth"),
    tsdbapi.oauth_auth_device_url = Sys.getenv("TSDBAPI_OAUTH_AUTH_DEVICE_URL", unset = "https://keycloak.kof.ethz.ch/realms/main/protocol/openid-connect/auth/device"),
    tsdbapi.oauth_redirect_url = Sys.getenv("TSDBAPI_OAUTH_REDIRECT_URL", unset = "http://localhost:1011"),
    tsdbapi.oauth_flow = Sys.getenv("TSDBAPI_OAUTH_FLOW", unset = if(httr2:::is_hosted_session()) "device" else "code"),
    tsdbapi.oauth_offline_token = Sys.getenv("TSDBAPI_OAUTH_OFFLINE_TOKEN", unset = ""),
    tsdbapi.url_staging = Sys.getenv("TSDBAPI_URL_STAGING", unset = "https://tsdb-api.stage.kof.ethz.ch/v2/"),
    tsdbapi.url_production = Sys.getenv("TSDBAPI_URL_PRODUCTION", unset = "https://tsdb-api.kof.ethz.ch/v2/"),
    tsdbapi.url_test = Sys.getenv("TSDBAPI_URL_TEST", unset = "http://localhost:3001/v2/"),
    tsdbapi.environment = Sys.getenv("TSDBAPI_ENVIRONMENT", unset = "production"),
    tsdbapi.access_type = Sys.getenv("TSDBAPI_ACCESS_TYPE", unset = "oauth"),
    tsdbapi.read_before_release = Sys.getenv("TSDBAPI_READ_BEFORE_RELEASE", unset = T)
  )
}


#' Set package configuration options.
#'
#' @param oauth_client_id oauth client id
#' @param oauth_client_token_url oauth client token url
#' @param oauth_client_secret obfuscated oauth client secret. Obfuscate secret with httr2::obfuscate.
#' @param oauth_auth_url oauth authentication URL
#' @param oauth_redirect_url oauth redirect URL
#' @param oauth_offline_token oauth offline token. A offline token is a refresh token that does not expire at the end of a session.
#' @param url_staging URL of staging API
#' @param url_production URL of production API
#' @param url_test URL of test API
#' @param environment whether to use the production, staging or test API. Must be one of 'production', 'staging' or 'test.
#' @param access_type how to access time series data. Must be one of 'oauth' (the default), 'public' or 'preview'.
#' With 'oauth' (open authorization), you must prove your identity by logging
#' in to your account and you will only have the access that is granted to that account.
#' With 'public', you only have access to public time series data. With 'preview', you only have access to a subset of the time series
#' for which previews are allowed. The time series previews will lack the latest 2 years of data.
#' @param read_before_release whether time series vintages should be read before their official release. Defaults to TRUE. This option will only have
#' an effect if you have pre release access to the requested time series.
#' @export
set_config <- function(
  oauth_client_id = NULL,
  oauth_client_token_url = NULL,
  oauth_client_secret = NULL,
  oauth_auth_url = NULL,
  oauth_auth_device_url = NULL,
  oauth_flow = NULL,
  oauth_redirect_url = NULL,
  oauth_offline_token = NULL,
  url_staging = NULL,
  url_production = NULL,
  url_test = NULL,
  environment = NULL,
  access_type = NULL,
  read_before_release = NULL
) {
  if(!is.null(oauth_client_id)) {
    options(tsdbapi.oauth_client_id = oauth_client_id)
  }
  if(!is.null(oauth_client_token_url)) {
    options(tsdbapi.oauth_client_token_url = oauth_client_token_url)
  }
  if(!is.null(oauth_client_secret)) {
    options(tsdbapi.oauth_client_secret = oauth_client_secret)
  }
  if(!is.null(oauth_flow)) {
    options(tsdbapi.oauth_flow = oauth_flow)
  }
  if(!is.null(oauth_auth_url)) {
    options(tsdbapi.oauth_auth_url = oauth_auth_url)
  }
  if(!is.null(oauth_auth_device_url)) {
    options(tsdbapi.oauth_auth_url = oauth_auth_url)
  }
  if(!is.null(oauth_redirect_url)) {
    options(tsdbapi.oauth_redirect_url = oauth_redirect_url)
  }
  if(!is.null(oauth_offline_token)) {
    options(tsdbapi.oauth_offline_token = oauth_offline_token)
  }
  if(!is.null(url_staging)) {
    options(tsdbapi.url_staging = url_staging)
  }
  if(!is.null(url_production)) {
    options(tsdbapi.url_production = url_production)
  }
  if(!is.null(url_test)) {
    options(tsdbapi.url_test = url_test)
  }
  if(!is.null(environment)) {
    options(tsdbapi.environment = environment)
  }
  if(!is.null(access_type)) {
    options(tsdbapi.access_type = access_type)
  }
  if(!is.null(read_before_release)) {
    options(tsdbapi.read_before_release = read_before_release)
  }
}

#' Get current package configuration
#'
#' @returns named character vector
#' @export
get_config <- function() {
  opts <- c(
    "oauth_client_id",
    "oauth_client_token_url",
    "oauth_client_secret",
    "oauth_flow",
    "oauth_auth_url",
    "oauth_auth_device_url",
    "oauth_redirect_url",
    "oauth_offline_token",
    "url_staging",
    "url_production",
    "url_test",
    "environment",
    "access_type",
    "read_before_release")
  
  names(opts) <- opts
  purrr::map(opts, ~getOption(paste0("tsdbapi.", .x)))
}

get_oauth_client <- function() {
  httr2::oauth_client(
    id = getOption("tsdbapi.oauth_client_id"),
    token_url = getOption("tsdbapi.oauth_client_token_url"),
    auth = "body",
    secret = httr2::obfuscated(getOption("tsdbapi.oauth_client_secret"))
  )
} 

#' Requests a refresh token that does not expire at the end of a session.
#'
#' @param set_option set the tsdbapi.oauth_offline_token option. That way, the package will use the offline token to get access tokens.
#' @returns offline token
#' @export
get_offline_token <- function(set_option = T) {
  if(getOption("tsdbapi.oauth_flow")=="device") {
    res <- httr2::oauth_flow_device(
      client = get_oauth_client(),
      scope = "offline_access",
      auth_url = getOption("tsdbapi.oauth_auth_device_url"),
    )
  } else {
    res <- httr2::oauth_flow_auth_code(
      client = get_oauth_client(),
      redirect_uri = getOption("tsdbapi.oauth_redirect_url"),
      auth_url = getOption("tsdbapi.oauth_auth_url"),
      auth_params = list(scope="offline_access")
    )
  }
  
  if(set_option) {
    options(tsdbapi.oauth_offline_token = res$refresh_token)
  }
  
  res$refresh_token
}

req_base <- function(url) {
  
  req <- httr2::request(url) |> httr2::req_error(body = function(res) httr2::resp_body_json(res)$message)
  
  offline_token <- getOption("tsdbapi.oauth_offline_token")
  
  if(offline_token == "") {
    if(getOption("tsdbapi.oauth_flow")=="device") {
      req <- req |> httr2::req_oauth_device(
        client = get_oauth_client(),
        auth_url = getOption("tsdbapi.oauth_auth_device_url"))
    } else {
      req <- req |> httr2::req_oauth_auth_code(
        client = get_oauth_client(),
        redirect_uri = getOption("tsdbapi.oauth_redirect_url"),
        auth_url = getOption("tsdbapi.oauth_auth_url"))
    }
  } else {
    req <- req |> httr2::req_oauth_refresh(get_oauth_client(), refresh_token = offline_token)
  }

  req |> httr2::req_url_query(
    access_type = getOption("tsdbapi.access_type"),
    read_before_release = to_bool_query_param(getOption("tsdbapi.read_before_release"))
  )
}

to_bool_query_param <- function(arg) {
  if(arg) "true" else ""
}

json_to_ts <- function(data) {
  res <- xts::xts(data$value, order.by = as.Date(data$time), frequency = data$frequency)
  if(data$frequency) {
    tsbox::ts_ts(res)
  } else {
    res
  }
}

base_url <- function() {
  envir <- getOption("tsdbapi.environment")
  if(envir == "staging") {
    getOption("tsdbapi.url_staging")
  } else if(envir == "production") {
    getOption("tsdbapi.url_production")
  } else if(envir == "test") {
    getOption("tsdbapi.url_test")
  } else {
    stop("tsdbapi environment ", envir, " not supported")
  }
}

cat_message <- function(res) {
  cat(httr2::resp_body_json(res)$message, "\n")
}

