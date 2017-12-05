library(dplyr)
library(ggplot2)

source("get-data.R")

# TEST SPECIES: WITH CHANGES IN ASSESSMENT 
scientific.name <- "Cobitis paludica"

# TEST SPECIES: WITH NO CHANGES IN ASSESSMENT 
scientific.name <- "Xerotricha mariae"

# Given the scientific name for a species, the historial assessment is returned  
HistoricalAssessment <- function(species.name) {
  historial.ending <- paste0("/api/v3/species/history/name/", species.name, "?token=")
  access.data <- AccessAPI(historial.ending)
  historial.assessment.data <- data.frame(access.data$result)
  return(historial.assessment.data)
} 

assessment.result <- HistoricalAssessment(scientific.name)

# Given the dataframe, if there are more than one historical categorization a visual representation is returned.
# Otherwise, a sentence is returned explained the details. 
EndangermentInformation <- function(endangered.data) {
  if (nrow(endangered.data) > 1) {
    # Creates the visual representation of the endangerment for the species over the years 
    return (ggplot(data = assessment.result, aes(x = year, y = category, group = 1)) + geom_point(size = 4) + geom_line() +  
           scale_y_discrete(limits = c("Data Deficient", "Indeterminate", "Lower Risk/least concern", "Least Concern", "Lower Risk/near threatened", 
                                       "Vulnerable", "Endangered", "Critically Endangered", "Extinct in the Wild", "Extinct")) +
          labs(title = "Species' Endangerment Level over the Years", x = "Year", y = "Level of Endangerment")) 
  } else {
    print.result <- paste("This species has been categorized as", endangered.data$category, "since" , paste0(endangered.data$year, "."), sep = " ")
    return (print.result)
    }
}

EndangermentInformation(assessment.result)


