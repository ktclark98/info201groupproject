library(dplyr)
library(plotly)

source("get-data.R")
iso.codes <- read.csv("data/iso-codes.csv", stringsAsFactors = FALSE)

# IDEA: Maybe ranking compared to other countries of how many threated species are in country

# Given the country ISO 2 code, returns a pie chart of the count of threatened species
# by their categories of that particular country.
GetPie <- function(country.id) {
  species <- GetCount(country.id)
  species.pie <- plot_ly(data=species, labels = ~category, values = ~total, type = 'pie',
                         textposition = 'inside',
                         textinfo = 'label+percent',
                         hoverinfo = 'text',
                         text = ~paste0(code, ": ", total, " species")) %>% 
    layout(title = "Count of Threatened Species Category",
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  return(species.pie)
}

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
  
  # Calculates and add a percent column to the dataframe
  percent <- as.integer(counts$total)
  total <- sum(percent)
  percent <- (percent/total)*100
  counts$percent <- percent
  
  counts$code <- c("Critically Endangered", "Data Deficient", "Endangered", "Extinct in the Wild",
                   "Extinct", "Least Concern", "Near Threatened", "Vulnerable", "Low Risk")
  return(counts)
}

# Returns the country ISO 2 code given the country's ISO 3 code
GetISO2 <- function(iso3) {
  iso2 <- iso.codes %>% 
    filter(Code == iso3) %>% 
    select(ID)
  return(iso2[1,1])
}

