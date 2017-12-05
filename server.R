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
  
  indices <- reactive({
    data <- coords2country(data.frame(input$long, input$lat, stringsAsFactors = FALSE))
  })
  
  output$country <- renderPrint({
    as.character(indices()$NAME)
  })
  
  output$country.pie <- renderPrint({
    iso2 <- as.character(indices()$ISO_A2)
    return(GetPie(iso2))
  })
})
