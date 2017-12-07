library(dplyr)
source("get-data.R")

CountryOfSpecies <- function(name) {
  ep <- paste0("/api/v3/species/countries/name/", name, "?token=")
  list <- AccessAPI(ep)
  df <- list[[length(list)]]
  df <- dplyr::filter(df, !grepl('Extinct', presence))
  return(nrow(df))
}

TotalCountry <- function() {
  country.ep <- "/api/v3/country/list?token="
  country <- AccessAPI(country.ep)
  country.df <- country[[2]]
  return(nrow(country.df))
}

country.count <- TotalCountry()

TotalSpecies <- function() {
  ep <- "/api/v3/speciescount?token="
  species <- AccessAPI(ep)
  return(species[[1]])
}

species.count <- TotalSpecies()
