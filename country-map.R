library(plotly)
library(dplyr)

# Given the species endangered category, returns a world map in which
# countries are colored by how many of those type of species are in the country
CategoryMap <- function(categ) {
  # Get 3 letter country code to map using ploty
  iso.codes <- read.csv("data/iso-codes.csv", stringsAsFactors = FALSE)
  file.path <- paste0("data/",categ,"-count.csv")
  country.count <- read.csv(file = file.path, stringsAsFactors = FALSE)
  
  country.count <- country.count %>% 
    left_join(iso.codes, by= "ID") %>% 
    select(ID, Code, Country, Count)
  
  # light grey boundaries
  l <- list(color = toRGB("grey"), width = 0.5)
  
  # specify map projection/options
  g <- list(
    showframe = FALSE,
    showcoastlines = FALSE,
    projection = list(type = 'Mercator')
  )
  
  p <- plot_geo(country.count) %>%
    add_trace(
      z = ~Count, colors = "Purples",
      text = ~Country, locations = ~Code, marker = list(line = l)
    ) %>%
    colorbar(title = 'Species Count') %>%
    layout(
      title = 'Number of Selected Species Category by Country',
      geo = g
    )
  return(p)
}
