library(dplyr)
source("get-data.R")
library(ggplot2)

scientific.name <- "Loxodonta Africana"

my.stop.words <- data_frame(word = c("&", "-", "and", "is", "or", "level", "Named", "species"))

# Takes in a the name of the species and creates a data table that contains the
# titles of the issues causing them to be endangered, if this is still happening and 
# the level of impact it has on the species. It takes the sentences and makes a new
# data table that shows the frequency of each word in the description. 
ThreatsForSpecies <- function(species.name) {
  ending <- paste0("/api/v3/threats/species/name/", species.name, "?token=")
  threats <- AccessAPI(ending)
  threats.species <- data.frame(threats$result)
  threats.species <- select(threats.species, title)
  
  # Creates the table of words rather than sentences.
  threats.rows <- nrow(threats.species)
  threats.vector <- threats.species[, 1]
  split.vector <- strsplit(threats.vector, " ")
  first.data <- data.frame(split.vector[1])
  names(first.data) <- "word"
  for (i in 2:threats.rows) {
    threats.vector2 <- threats.species[ , 1]
    split.vector2 <- strsplit(threats.vector2, " ")
    added.data <- data.frame(split.vector2[i])
    names(added.data) <- "word"
    newdf <- data.frame(rbind(as.matrix(added.data), as.matrix(first.data)))
    first.data <- newdf
  }
  
  # Groups the table by the words and finds the count of each. Also gets rid
  # of words that won't be good descriptors
  word.count <- newdf %>%
    group_by(word) %>%
    summarise(n = n()) 
  no.stop.word.count <- word.count %>%
    anti_join(my.stop.words, by="word")
  return (no.stop.word.count)
}

# Uses the function that creates a new data table of words and frequencies to make
# a histogram of the most common words used to describe the threats to the species
ThreatHistogram <- function(name) {
  threats.data <- ThreatsForSpecies(name)
  threat <- threats.data %>%
    filter(n > 2) %>%
    ggplot(aes(word, n)) +
    
    geom_col(fill = "#ff6666") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +

    xlab(NULL) + 
    ggtitle("Most Common Words \n Describing Threats") +
    labs(x = "Words", y = "Frequency")
  return(threat)
}

# Takes in the name of a species and returns a data frame of the conservation measures 
# being taken to help the species. This data frame is then used to make a new data frame
# of the most common words used to describe these measures.
ConservationMeasures <- function(name) {
  ending.for.conservation <- paste0("/api/v3/measures/species/name/", name, "?token=")
  conservation <- AccessAPI(ending.for.conservation)
  conservation.species <- data.frame(conservation$result)
  conservation.species <- select(conservation.species, title)

  # Creates a data frame with the most common words
  conservation.rows <- nrow(conservation.species)
  conservation.vector <- conservation.species[, 1]
  con.split.vector <- strsplit(conservation.vector, " ")
  con.first.data <- data.frame(con.split.vector[1])
  names(con.first.data) <- "word"
  for (i in 2:conservation.rows) {
    conservation.vector2 <- conservation.species[ , 1]
    con.split.vector2 <- strsplit(conservation.vector2, " ")
    con.added.data <- data.frame(con.split.vector2[i])
    names(con.added.data) <- "word"
    newdf <- data.frame(rbind(as.matrix(con.added.data), as.matrix(con.first.data)))
    con.first.data <- newdf
  }
  
  # Creates a data frame that discludes non applicable words
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

# Creates a histogram that of the most common words associated with
# the description of the conservation measure for the given species
ConservationHistogram <- function(name) {
  conservation.data <- ConservationMeasures(name)
  conservation <- conservation.data %>%
    filter (n > 2) %>%
    ggplot(aes(word, n)) +
    
    geom_col(fill = "#80bfff") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
    
    xlab(NULL) + 
    ggtitle("Most Common Words \n Describing Conservation Efforts") +
    labs(x = "Words", y = "Frequency")
  return(conservation)
}

# Creates a new data frame that contains the words that describes the habitats
HabitatsOfSpecies <- function(name) {
  ending.for.habitats <- paste0("/api/v3/habitats/species/name/", name, "?token=")
  habitats <- AccessAPI(ending.for.habitats)
  habitats.species <- data.frame(habitats$result)
  habitats.species <- select(habitats.species, habitat)

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

# Creates a histogram of the most common frequencies of words
# Describing the habitats of the species
HabitatHistogram <- function(name) {
  habitats.data <- HabitatsOfSpecies(name)
  habitat <- habitats.data %>%
    filter (n > 2) %>%
    ggplot(aes(word, n)) +
    
    geom_col(fill = "#269900") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    
    xlab(NULL) + 
    ggtitle("Most Common Words \n Describing Habitats") +
    labs(x = "Words", y = "Frequency")
  return(habitat)
  
}

habitats.data <- HabitatsOfSpecies(scientific.name)