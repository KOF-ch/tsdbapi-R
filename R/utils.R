client <- httr2::oauth_client(
  id = "test",
  token_url = "https://keycloak.kof.ethz.ch/realms/dev-test/protocol/openid-connect/token",
  key =  "test",
  auth = "body",
  secret = "HyrQnGXNGrppID3bHB2zj2VIIMYCYbnQ")

offline_token <- function(set_env_var=F) {
  
  res <- httr2::oauth_flow_auth_code(
    client = client,
    redirect_uri = "http://localhost:1011",
    auth_url = "https://keycloak.kof.ethz.ch/realms/dev-test/protocol/openid-connect/auth",
    auth_params = list(scope="offline_access"))
  if(set_env_var) {
    Sys.setenv(KOFDATA_OFFLINE_TOKEN = res$refresh_token)
  } else {
    res$refresh_token
  }
}

req_base <- function(url) {
  
  req <- httr2::request(url) %>% httr2::req_error(body = function(res) httr2::resp_body_json(res)$message)
  
  offline_token <- Sys.getenv("KOFDATA_OFFLINE_TOKEN")
  
  if(offline_token == "") {
    req <- req %>% httr2::req_oauth_auth_code(
      client = client,
      auth_url = "https://keycloak.kof.ethz.ch/realms/dev-test/protocol/openid-connect/auth")
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
  "https://tsdb.kof.ethz.ch/"
  # "http://localhost:3001/"
}