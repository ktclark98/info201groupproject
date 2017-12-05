source("get-data.R")

iso.codes <- read.csv("data/iso-codes.csv", stringsAsFactors = FALSE)

# Returns the country ISO 2 code given the country's ISO 3 code
GetISO2 <- function(iso3) {
  iso2 <- iso.codes %>% 
    filter(Code == iso3) %>% 
    select(ID)
  return(iso2[1,1])
}

country.id <- "US"

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
  
  LR.count <- filter(counts, grepl('LR', category))
  LR.count <- sum(LR.count$total)
  
  counts <- filter(counts, !grepl('LR', category))
  
  df <- c("LR", LR.count)
  names(df) <- c("category", "total")
  counts <- rbind(counts, df)
}


