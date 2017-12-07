library(dplyr)
library(ggplot2)

source("get-data.R")

# Given the scientific name for a species, a visual representation the historial assessment overtime is returned
HistoricalAssessment <- function(species.name) {
  historial.ending <- paste0("/api/v3/species/history/name/", species.name, "?token=")
  access.data <- AccessAPI(historial.ending)
  historial.assessment.data <- data.frame(access.data$result)
  assessment.result <- data.frame(access.data$result)
  return (ggplot(data = assessment.result, aes(x = year, y = category, group = 1)) +
            geom_point(size = 4, color = "#ffb3b3") + geom_line() + theme(legend.position="none") + 
            scale_y_discrete(limits = c("Data Deficient", "Indeterminate", "Lower Risk/least concern", "Least Concern", "Lower Risk/near threatened", 
                                        "Vulnerable", "Endangered", "Critically Endangered", "Extinct in the Wild", "Extinct")) +
            labs(title = "Species' Endangerment Level over the Years", x = "Year", y = "Level of Endangerment")) 
} 

