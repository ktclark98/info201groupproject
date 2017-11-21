library(httr)
library(jsonlite)

# Make sure you name api-key file "api-key.R"
# Name the variable "api.key"
source("api-key.R")

base.url <- "http://apiv3.iucnredlist.org"

# Given the endpoint (found on API) will return a list with the data pulled
# from API. 
# Note: Make sure endpoint ends at "token="
# Note: Browse the list returned for the dataframe you want (usually the last element). 
AccessAPI <- function(endpoint) {
  response <- GET(paste0(base.url, endpoint, api.key))
  body <- content(response, "text")
  data <- fromJSON(body)
}
