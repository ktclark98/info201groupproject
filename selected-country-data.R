library(dplyr)
library(plotly)

source("get-data.R")

categ.code <- read.csv("data/endanger-code.csv", stringsAsFactors = FALSE)
iso.codes <- read.csv("data/iso-code2.csv", stringsAsFactors = FALSE)

# Given the 2 letter country code, returns total number of threatened species
# in that country
GetNumberSpecies <- function(country.id) {
  endpoint <- paste0("/api/v3/country/getspecies/", country.id, "?token=")
  country <- AccessAPI(endpoint)
  return(country[[1]])
}

GetNumberSpecies("US")

# Returns a dataframe containing the counts of all categories of threatend species
# in the given country.
GetCount <- function(country.id) {
  endpoint <- paste0("/api/v3/country/getspecies/", country.id, "?token=")
  country <- AccessAPI(endpoint)
  count <- country[[1]]
  result <- country[[length(country)]]
  
  counts <- result %>% 
    group_by(category) %>% 
    summarise(total = n())
  
  # Groups all LR categories together
  LR.count <- filter(counts, grepl('LR', category))
  LR.count <- sum(LR.count$total)
  counts <- filter(counts, !grepl('LR', category))
  df <- c("LR", LR.count)
  names(df) <- c("category", "total")
  counts <- rbind(counts, df)
  
  # Puts in formatted names for the categories
  counts <- left_join(counts, categ.code, by = "category")
  return(counts)
}

# Returns the country ISO 2 code given the country's ISO 3 code
GetCountryName <- function(iso2) {
  name <- iso.codes %>% 
    filter(ID == iso2) %>% 
    select(Name)
  return(name[1,1])
}

# Given the country ISO 2 code, returns a pie chart of the count of threatened species
# by their categories of that particular country.
GetPie <- function(country.id) {
  name <- GetCountryName(country.id)
  species <- GetCount(country.id)
  species.pie <- plot_ly(data=species, labels = ~category, values = ~total, type = 'pie',
                         textposition = 'inside',
                         textinfo = 'label+percent',
                         hoverinfo = 'text',
                         text = ~paste0(name, ": ", total, " species")) %>% 
    layout(title = paste0("Count of Threatened Species in ", name), 
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  return(species.pie)
}

