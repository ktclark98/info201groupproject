#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(ggplot2)
library(shiny)
source("Tab's-Data-Wrangling.R")
source("country-map.R")
# Define server logic required to draw a histogram
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
  
})
