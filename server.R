library(ggplot2)
library(shiny)

source("Tab's-Data-Wrangling.R")
source("country-map.R")
source("region-detect.R")
source("selected-country-data.R")

shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    action <- ConservationMeasures(input$text)
    threats <- ThreatsForSpecies(input$text)
    habitat <- HabitatsOfSpecies(input$text)
    
    word.count <- eval(parse(text = input$checkGroup))
    
    word.count %>%
      arrange(-n)
      filter (n > 2) %>%
      ggplot(aes(title, n)) +
      geom_col() +
      xlab(NULL) + 
      coord_flip()
    
  })
  
  output$worldMap <- renderPlotly({
    p
  })
  
  output$country.pie <- renderPlotly({
    iso2 <- as.character(input$country)
    GetPie(iso2)
  })
})
