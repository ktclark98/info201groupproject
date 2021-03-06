library(dplyr)
source("get-data.R")

# 
GetUrl <- function(species.name) {
  ending <- paste0("/api/v3/weblink/", species.name, "?token=")
  website <- AccessAPI(ending)
  return(website$rlurl)
}


GetCommonName <- function(species.name) {
  ending <- paste0("/api/v3/species/common_names/", species.name, "?token=")
  common.name <- AccessAPI(ending)
  common.name <- common.name$result
  return(common.name[1, 1])
}

