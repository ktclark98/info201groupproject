library(dplyr)

source("get-data.R")

library(ggplot2)



scientific.name <- "Loxodonta Africana"

my.stop.words <- data_frame(word = c("&", "-", "and", "is", "or", "level"))

# Takes in a the name of the species and creates a data table that contains the

# titles of the issues causing them to be endangered, if this is still happening and 

# the level of impact it has on the species

ThreatsForSpecies <- function(species.name) {
  
  ending <- paste0("/api/v3/threats/species/name/", species.name, "?token=")
  
  threats <- AccessAPI(ending)
  
  threats.species <- data.frame(threats$result)
  
  threats.species <- select(threats.species, title)
  
  
  
  #Creates first 
  
  threats.rows <- nrow(threats.species)
  
  threats.vector <- threats.species[, 1]
  
  split.vector <- strsplit(threats.vector, " ")
  
  first.data <- data.frame(split.vector[1])
  
  names(first.data) <- "word"
  
  
  
  #Goes through every word in the vector and adds it to a data.frame
  
  for (i in 2:threats.rows) {
    
    threats.vector2 <- threats.species[ , 1]
    
    split.vector2 <- strsplit(threats.vector2, " ")
    
    added.data <- data.frame(split.vector2[i])
    
    names(added.data) <- "word"
    
    newdf <- data.frame(rbind(as.matrix(added.data), as.matrix(first.data)))
    
    first.data <- newdf
    
  }
  
  
  
  word.count <- newdf %>%
    
    group_by(word) %>%
    
    summarise(n = n()) 
  
  
  no.stop.word.count <- word.count %>%
    
    anti_join(my.stop.words, by="word")
  
  return (no.stop.word.count)
  
}


ThreatHistogram <- function(name) {
  
  threats.data <- ThreatsForSpecies(name)
  
  threat <- threats.data %>%
    
    filter(n > 2) %>%
    
    ggplot(aes(word, n)) +
    
    geom_col() +
  
    xlab(NULL) + 
  
    ggtitle("Most Common Words \n Describing Threats") +
    
    labs(x = "Words", y = "frequency")
  
  return(threat)
  
}



# Takes in the name of a species and returns a list of the conservation measures 

# being taken to help the species. 

ConservationMeasures <- function(name) {
  
  ending.for.conservation <- paste0("/api/v3/measures/species/name/", name, "?token=")
  
  conservation <- AccessAPI(ending.for.conservation)
  
  conservation.species <- data.frame(conservation$result)
  
  conservation.species <- select(conservation.species, title)
  
  
  
  # Creates a vector of all the different words described as threats
  
  conservation.rows <- nrow(conservation.species)
  
  conservation.vector <- conservation.species[, 1]
  
  con.split.vector <- strsplit(conservation.vector, " ")
  
  con.first.data <- data.frame(con.split.vector[1])
  
  names(con.first.data) <- "word"
  
  
  
  #Goes through every word in the vector and adds it to a data.frame
  
  for (i in 2:conservation.rows) {
    
    conservation.vector2 <- conservation.species[ , 1]
    
    con.split.vector2 <- strsplit(conservation.vector2, " ")
    
    con.added.data <- data.frame(con.split.vector2[i])
    
    names(con.added.data) <- "word"
    
    newdf <- data.frame(rbind(as.matrix(con.added.data), as.matrix(con.first.data)))
    
    con.first.data <- newdf
    
  }
  
  con.vector.of.words <- newdf[, 1]
  
  con.word.count <- newdf %>%
    
    group_by(word) %>%
    
    summarise(n = n())
  
  con.word.count <- con.word.count %>%
    
    arrange(-n)
  
  no.stop.count <- con.word.count %>%
    
    anti_join(my.stop.words, by="word")
  
  return(no.stop.count)
  
  
  
}

ConservationHistogram <- function(name) {
  
  conservation.data <- ConservationMeasures(name)
  
  conservation <- conservation.data %>%
    
    filter (n > 2) %>%
    
    ggplot(aes(word, n)) +
    
    geom_col() +
    
    xlab(NULL) + 
    
   ggtitle("Most Common Words \n Describing Conservation Efforts") +
    
    labs(x = "Words", y = "frequency")
  
  return(conservation)
  
}


HabitatsOfSpecies <- function(name) {
  
  ending.for.habitats <- paste0("/api/v3/habitats/species/name/", name, "?token=")
  
  habitats <- AccessAPI(ending.for.habitats)
  
  habitats.species <- data.frame(habitats$result)
  
  habitats.species <- select(habitats.species, habitat)
  
  # Creates a vector of all the different words described as threats
  
  habitats.rows <- nrow(habitats.species)
  
  habitats.vector <- habitats.species[, 1]
  
  hab.split.vector <- strsplit(habitats.vector, " ")
  
  hab.first.data <- data.frame(hab.split.vector[1])
  
  names(hab.first.data) <- "word"
  
  
  
  #Goes through every word in the vector and adds it to a data.frame
  
  for (i in 2:habitats.rows) {
    
    habitats.vector2 <- habitats.species[ , 1]
    
    hab.split.vector2 <- strsplit(habitats.vector2, " ")
    
    hab.added.data <- data.frame(hab.split.vector2[i])
    
    names(hab.added.data) <- "word"
    
    newdf <- data.frame(rbind(as.matrix(hab.added.data), as.matrix(hab.first.data)))
    
    hab.first.data <- newdf
    
  }
  
  hab.vector.of.words <- newdf[, 1]
  
  hab.word.count <- newdf %>%
    
    group_by(word) %>%
    
    summarise(n = n())
  
  hab.word.count <- hab.word.count %>%
    
    arrange(-n)
  no.stop.hab.count <- hab.word.count %>%
    
    anti_join(my.stop.words, by="word")
  
  return (no.stop.hab.count)
  
}

HabitatHistogram <- function(name) {
  
  habitats.data <- HabitatsOfSpecies(name)
  
  habitat <- habitats.data %>%
    
    filter (n > 2) %>%
    
    ggplot(aes(word, n)) +
    
    geom_col() +
    
    xlab(NULL) + 
    
    ggtitle("Most Common Words \n Describing Habitats") +
    
    labs(x = "Words", y = "frequency")
  
  return(habitat)
  
}

habitats.data <- HabitatsOfSpecies(scientific.name)