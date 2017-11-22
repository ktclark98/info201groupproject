library(plotly)
library(dplyr)

# Get 3 letter country code to map using ploty
iso.codes <- read.csv("data/iso-codes.csv", stringsAsFactors = FALSE)
country.count <- read.csv("data/country-count.csv", stringsAsFactors = FALSE)
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
    title = 'Endangered Species Count by Country',
    geo = g
  )
