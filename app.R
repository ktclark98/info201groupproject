## app.R ##
library(shiny)
library(shinydashboard)
library(plotly)
library(knitr)
library(ggplot2)

source("Tab's-Data-Wrangling.R")
source("country-map.R")
source("selected-country-data.R")
source("overtime-graphic.R")

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Endangered Species"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Your Country", tabName = "country", icon = icon("map-marker")),
      menuItem("Location", tabName = "location", icon = icon("map")),
      menuItem("Species", tabName = "species", icon = icon("paw")),
      menuItem("About", tabName = "about", icon = icon("user-circle"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "country",
              h2("Country"), 
              fluidRow(
                box(textInput("country", label = h3("Enter Your Country's 2 Letter Code:"))),
                box(
                  textInput("country", label = h3("Enter Your Country's 2 Letter Code:"), value = "US")
                ),
                
                box(
                  plotlyOutput('country.pie', height = 250)
                )
              )
      ),
      
      # Second tab content
      tabItem(tabName = "location",
              h2("Location"),
              fluidRow(
                box(
                  plotlyOutput("worldMap", height = 500)
                )
              )
      ),
      
      tabItem(tabName = "species",
              h2("Species"),
              fluidRow(
                  box(
                    textInput("text", label = h3("Enter Species Name below"), value = "Loxodonta africana")
                  ),
                  box(
                    selectInput("checkGroup",
                                label = h3("Select Information"),
                                choices = list("Actions" = "action", "Threats" = "threats", "Habitat" = "habitat", "Historical Assessment" = "historical")
                    )
                  ),
                  box(
                    plotOutput("histPlot")
                  )
                )
      ),
      
      tabItem(tabName = "about",
              fluidPage(
                includeMarkdown("about-us.Rmd")
              )
      )
    )
  )
)

server <- function(input, output) {
  output$histPlot <- renderPlot({
    if (input$checkGroup == "threats") {
      plot <- ThreatHistogram(input$text)
    } else if (input$checkGroup == "action") {
      plot <- ConservationHistogram(input$text)
    } else if (input$checkGroup == "habitat") {
      plot <- HabitatHistogram(input$text)
    } else if (input$checkGroup == "historical") {
      plot <- HistoricalAssessment(input$text) 
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
}

shinyApp(ui, server)

