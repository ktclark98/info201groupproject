# This script generates a csv file that coutains data of endangered species
# count in each country. 
# DO NOT NEED TO RUN AGAIN. It takes a very long time to run.
# Use the data file that's already in the data folder.
library(dplyr)
source("get-data.R")

country.ep <- "/api/v3/country/list?token="

country <- AccessAPI(country.ep)
country.df <- country[[2]]
country.code <- country.df$isocode

uz.data <- "/api/v3/country/getspecies/UZ?token="
uz <- AccessAPI(uz.data)
uz.count <- uz[[1]]

# Set up counts dataframe
counts.df <- data.frame("UZ", uz.count, stringsAsFactors = FALSE)
names(counts.df) <- c("Country", "Count")

GetCountryCount <- function(country.id) {
  endpoint <- paste0("/api/v3/country/getspecies/", country.id, "?token=")
  country <- AccessAPI(endpoint)
  country.count <- country[[1]]
  # add to df
  df <- c(country.id, country.count)
  names(df) <- c("Country", "Count")
  return(rbind(counts.df, df))
}

country.code <- country.code[175:251]
for (i in country.code) {
  counts.df <- GetCountryCount(i)
}

colnames(counts.df) <- c("isocode", "Count")
result <- left_join(country.df, counts.df)
colnames(result) <- c("ID", "Country", "Count")

write.csv(result, file = "data/country-count.csv")
