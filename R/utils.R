
.onLoad <- function(libname, pkgname) {
  options(
    tsdbapi.oauth_client_id = Sys.getenv("TSDBAPI_OAUTH_CLIENT_ID", unset = "tsdb-api"),
    tsdbapi.oauth_client_token_url = Sys.getenv("TSDBAPI_OAUTH_CLIENT_TOKEN_URL", unset = "https://keycloak.kof.ethz.ch/realms/main/protocol/openid-connect/token"),
    tsdbapi.oauth_client_key = Sys.getenv("TSDBAPI_OAUTH_CLIENT_KEY", unset = "test"),
    tsdbapi.oauth_client_secret = Sys.getenv("TSDBAPI_OAUTH_CLIENT_SECRET", unset = "HyrQnGXNGrppID3bHB2zj2VIIMYCYbnQ"),
    tsdbapi.oauth_auth_url = Sys.getenv("TSDBAPI_OAUTH_AUTH_URL", unset = "https://keycloak.kof.ethz.ch/realms/main/protocol/openid-connect/auth"),
    tsdbapi.oauth_redirect_url = Sys.getenv("TSDBAPI_OAUTH_REDIRECT_URL", unset = "http://localhost:1011"),
    tsdbapi.oauth_offline_token = Sys.getenv("TSDBAPI_OAUTH_OFFLINE_TOKEN", unset = ""),
    tsdbapi.url_staging = Sys.getenv("TSDBAPI_URL_STAGING", unset = "https://tsdb-api.stage.kof.ethz.ch/v2"),
    tsdbapi.url_production = Sys.getenv("TSDBAPI_URL_PRODUCTION", unset = "https://tsdb-api.kof.ethz.ch/v2"),
    tsdbapi.url_test = Sys.getenv("TSDBAPI_URL_TEST", unset = "https://localhost:3001"),
    tsdbapi.environment = Sys.getenv("TSDBAPI_ENVIRONMENT", unset = "production")
  )
}

get_oauth_client <- function() {
  httr2::oauth_client(
    id = getOption("tsdbapi.oauth_client_id"),
    token_url = getOption("tsdbapi.oauth_client_token_url"),,
    key = getOption("tsdbapi.oauth_client_key"),
    auth = "body",
    secret = getOption("tsdbapi.oauth_client_secret"))
} 


#' Requests a refresh token that does not expire at the end of a session.
#'
#' @param set_option set the tsdbapi.oauth_offline_token option. That way, the package will use the offline token to get temporary access tokens.
#' @returns offline token
#' @export
get_offline_token <- function(set_option = T) {
  res <- httr2::oauth_flow_auth_code(
    client = get_oauth_client(),
    redirect_uri = getOption("tsdbapi.oauth_redirect_url"),
    auth_url = getOption("tsdbapi.oauth_auth_url"),
    auth_params = list(scope="offline_access"))
  
  if(set_option) {
    options(tsdbapi.oauth_offline_token = res$refresh_token)
  }
  
  res$refresh_token
}

req_base <- function(url) {
  
  req <- httr2::request(url) %>% httr2::req_error(body = function(res) httr2::resp_body_json(res)$message)
  
  offline_token <- getOption("tsdbapi.oauth_offline_token")
  
  if(offline_token == "") {
    req <- req %>% httr2::req_oauth_auth_code(
      client = get_oauth_client(),
      auth_url = getOption("tsdbapi.oauth_auth_url"))
  } else {
    req <- req %>% httr2::req_oauth_refresh(client, refresh_token = offline_token)
  }

  req 
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
