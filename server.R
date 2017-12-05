library(ggplot2)
library(shiny)

source("Tab's-Data-Wrangling.R")
source("country-map.R")
source("region-detect.R")

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
  
  output$country <- renderPrint({
    indices <- coords2country(data.frame(input$long, input$lat, stringsAsFactors = FALSE))
    return(as.character(indices$NAME))
  })
  
  output$country.hist <- renderPrint({
    indices <- coords2country(data.frame(input$long, input$lat, stringsAsFactors = FALSE))
    iso2 <- as.character(indices$ISO_A2)
    
  })
})
