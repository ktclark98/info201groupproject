library(dplyr)
source("get-data.R")

pages <- 1:100
ending.for.names <- "/api/v3/species/region/europe/page/0?token="
names <- AccessAPI(ending.for.names)
total.names <- data.frame(names$result)
total.names <- select(total.names, scientific_name)

scientific.name <- "Loxodonta Africana"

# Takes in a the name of the species and creates a data table that contains the
# titles of the issues causing them to be endangered, if this is still happening and 
# the level of impact it has on the species
ThreatsForSpecies <- function(species.name) {
  ending <- paste0("/api/v3/threats/species/name/", species.name, "?token=")
  threats <- AccessAPI(ending)
  threats.species <- data.frame(threats$result)
  threats.species <- select(threats.loxodonta, title, timing, score)
  return (threats.loxodonta)
}

# Example
ThreatsForSpecies(scientific.name)

# Takes in the name of a species and returns a list of the conservation measures 
# being taken to help the species. 
ConservationMeasures <- function(name) {
  ending.for.conservation <- paste0("/api/v3/measures/species/name/", name, "?token=")
  conservation <- AccessAPI(ending.for.conservation)
  conservation.species <- data.frame(conservation$result)
  conservation.species <- conservation.species$title
  return (conservation.species)
}

ConservationMeasures(scientific.name)

HabitatsOfSpecies <- function(name) {
  ending.for.habitats <- paste0("/api/v3/habitats/species/name/", name, "?token=")
  habitats <- AccessAPI(ending.for.habitats)
  habitats.species <- data.frame(habitats$result)
  return(habitats.species)
}

HabitatsOfSpecies(scientific.name)
