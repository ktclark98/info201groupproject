library(dplyr)
library(jsonlite)
library(httr)
library(maptools)
library(ggplot2)
library(rgdal)
library(RColorBrewer)
library(ggmap)
library(OpenStreetMap)

source("api-key.R")

base.url <- "http://apiv3.iucnredlist.org"

# Given the endpoint (found on API) will return a list with the data pulled
# from API. 
# Note: Make sure endpoint ends at "token= "
# Note: Browse the list returned for the dataframe you want (usually the last element). 
#       Notice that the other indexes can also be useful info too.
AcessAPI <- function(endpoint) {
  response <- GET(paste0(base.url, endpoint, api.key))
  body <- content(list, "text")
  data <- fromJSON(body)
}



country.list <- GET(paste0(base.url, "/api/v3/country/list?token=", api.key))
country <- content(country.list, "text")
country.data <- fromJSON(country)[[2]] %>% 
  arrange(country)

# az = azerbaijan. See country.data for all ID's
az.ep <- paste0("/api/v3/country/getspecies/AZ?token=", api.key)
response <- GET(paste0(base.url, az.ep))
body <- content(response, "text")
az.data <- fromJSON(body)[[3]]

# Testing spatial data

area <- readShapeSpatial("AMPHIBIANS.shp")
area2 <- readOGR("AMPHIBIANS.shp")
colors <- brewer.pal(9, "RdPu")

area2 <- fortify(area2) # turns to a dataframe, takes a long ass time

mapImage <- get_map(location = "europe",
                    color = "color",
                    source = "google",
                    maptype = "terrain",
                    zoom = 6)

ggmap(mapImage) +
  geom_polygon(aes(x = long,
                   y = lat,
                   group = group),
                   data = area2,
                   color = colors[9],
                   fill = colors[6],
                  alpha = 0.5) +
  labs(x = "Longitude",
       y = "Latitude",
       title = "WORK DAMMIT")
