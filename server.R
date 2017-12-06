library(ggplot2)

library(shiny)



source("Tab's-Data-Wrangling.R")

source("country-map.R")

source("selected-country-data.R")

source("overtime-graphic.R")



shinyServer(function(input, output) {
  
  
  
  output$distPlot <- renderPlot({
    
    # Displays the historial assessment graph if the checkbox is selected 
    
    if (input$checkGroup == "historical") {
      
      HistoricalAssessment(input$text) 
      
    }
    
  })
  
  
  output$threatPlot <- renderPlot({
    
    if (input$checkGroup == "threats") {
      
      plot <- ThreatHistogram(input$text)
      
    }
    
    plot
    
  })
  
  output$conservationPlot <- renderPlot({
    
    if (input$checkGroup == "action") {
      
      plot <- ConservationHistogram(input$text)
      
    }
    
    plot
    
  })
  
  output$habitatPlot <- renderPlot({
    
    if (input$checkGroup == "habitat") {
      
      plot <- HabitatHistogram(input$text)
      
    }
    
    plot
    
  })
  
  output$worldMap <- renderPlotly({
    
    p
    
  })
  
  
  
  output$country.pie <- renderPlotly({
    
    iso2 <- as.character(input$country)
    
    GetPie(iso2)
    
  })
  
})

shinyUI(my.ui)