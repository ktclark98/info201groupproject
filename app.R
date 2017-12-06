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
  dashboardHeader(title = "Endangered Species"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Your Country", tabName = "country", icon = icon("th")),
      menuItem("Location", tabName = "location", icon = icon("th")),
      menuItem("Species", tabName = "species", icon = icon("th")),
      menuItem("About", tabName = "about", icon = icon("th"))
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
                  textInput("text", label = h3("Species"), value = "Enter Species Name Here...")
                ),
                box(
                  checkboxGroupInput("checkGroup",
                                     label = h3("Select Information"),
                                     choices = list("Actions" = "action", "Threats" = "threats", "Habitat" = "habitat", "Historial Assessment" = "historical")
                                     )
                ),
                box(
                  plotOutput("distPlot", height = 250),
                  plotOutput("threatPlot", height = 250)
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
  output$country.pie <- renderPlotly({
    iso2 <- as.character(input$country)
    GetPie(iso2)
  })
  
  output$worldMap <- renderPlotly({
    p
  })
  
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
}

shinyApp(ui, server)

