library(dplyr)
source("get-data.R")

scientific.name <- "Loxodonta Africana"

HistoricalAssessment <- function(species.name) {
  historial.ending <- paste0("/api/v3/species/history/name/", species.name, "?token=")
  access.data <- AccessAPI(historial.ending)
  historial.assessment.data <- data.frame(access.data$result)
  return (historial.assessment.data)
}

result <- HistoricalAssessment(scientific.name)
