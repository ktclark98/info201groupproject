library(ggplot2)
library(shiny)

source("Tab's-Data-Wrangling.R")
source("country-map.R")
source("selected-country-data.R")
source("overtime-graphic.R")

shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    # # generate bins based on input$bins from ui.R
    # action <- ConservationMeasures(input$text)
    # threats <- ThreatsForSpecies(input$text)
    # habitat <- HabitatsOfSpecies(input$text)
    # 
    # word.count <- eval(parse(text = input$checkGroup))
    # 
    # word.count %>%
    #   arrange(-n)
    #   filter (n > 2) %>%
    #   ggplot(aes(title, n)) +
    #   geom_col() +
    #   xlab(NULL) + 
    #   coord_flip()
    
    # Displays the historial assessment graph if the checkbox is selected 
    if (input$checkGroup == "historical") {
      HistoricalAssessment(input$text) 
    }
  })
  
  output$threatPlot <- renderPlot({
    if (input$checkGroup == "threats") {
      plot <- TreatHistogram(input$text)
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
