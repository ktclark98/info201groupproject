# This script generates a csv file that coutains data of endangered species
# count in each country. 
# DO NOT NEED TO RUN AGAIN. It takes a very long time to run.
# Use the data file that's already been generated in the data folder.
library(dplyr)
source("get-data.R")

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

# Given the endangered species category, pulls the count of that type of species
# for all country in the RedList API and writes the resulting datafram into a 
# csv file.
WriteData <- function(categ) {
  country.ep <- "/api/v3/country/list?token="
  country <- AccessAPI(country.ep)
  country.df <- country[[2]]
  country.code <- country.df$isocode
  
  # Need to get out the first country to set up the counts dataframe
  uz.data <- "/api/v3/country/getspecies/UZ?token="
  uz <- AccessAPI(uz.data)
  uz.df <- uz[[3]]
  
  # Filters for count of critically endangered species
  uz.count <- uz.df %>% 
    filter(category==categ) %>% 
    nrow()
  
  # Set up counts dataframe
  counts.df <- data.frame("UZ", uz.count, stringsAsFactors = FALSE)
  names(counts.df) <- c("Country", "Count")
  
  # Given the 2-code country ID, get the country's counts of critically endangered species
  # then adds the country to the counts dataframe.
  GetCountryCount <- function(country.id) {
    endpoint <- paste0("/api/v3/country/getspecies/", country.id, "?token=")
    country <- AccessAPI(endpoint)
    country.df <- country[[length(country)]]
    country.count <- country.df %>% 
        filter(category==categ) %>% 
        nrow()
    df <- c(country.id, country.count)
    names(df) <- c("Country", "Count")
    return(rbind(counts.df, df))
  }
  
  country.code <- country.code[2:251]
  for (i in country.code) {
    # These countries throw an error on mac due to character conversion or something
    # so not going to include them.
    if (i != "AN" && i != "CW" && i != "CI" && i != "RE") {
      counts.df <- GetCountryCount(i)
    }
  }
  
  # Format
  colnames(counts.df) <- c("isocode", "Count")
  result <- left_join(country.df, counts.df)
  colnames(result) <- c("ID", "Country", "Count")
  
  write.csv(result, file = paste0("data/", categ, "-count.csv"))
}

codes <- c("EW", "EN", "VU", "NT", "LC")
sapply(codes, WriteData)
