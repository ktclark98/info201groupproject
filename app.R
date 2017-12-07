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
source("get-image.R")
source("url-and-common-name.R")

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Endangered Species"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Your Country", tabName = "country", icon = icon("map-marker")),
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
                box(
                  textInput("country", label = h3("Enter Your Country's 2 Letter Code:"), value = "US")
                ),
                box(
                  selectInput("mapGroup",
                              label = h3("Select Information"),
                              choices = list("Critically Endangered" = "cr")
                  )
                ),
                box(
                  plotlyOutput('country.pie', height = 250)
                ),

                box(
                  plotlyOutput("worldMap", height = 500)
                ),
                box(
                  title = "Notes:", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                  htmlOutput("paragraphcountry")
                )

              )
      ),
      
      tabItem(tabName = "species",
              h2("Species"),
              fluidRow(
                
                valueBoxOutput("nameBox"),
                
                  box(
                    status = "primary",
                    textInput("text", label = h3("Enter Species Name below"), value = "Loxodonta africana")
                  ),
                  box(
                    status = "primary",
                    selectInput("checkGroup",
                                label = h3("Select Information"),
                                choices = list("Actions" = "action", "Threats" = "threats", "Habitat" = "habitat", "Historical Assessment" = "historical")
                    )
                  ),
                  
                box(
                  title = "Graph", status = "info", solidHeader = TRUE, collapsible = TRUE,
                  plotOutput("histPlot")
                ),
                
                  box(
                    title = "Picture", status = "info", solidHeader = TRUE,
                    htmlOutput("picture"),
                    uiOutput("url")
                  ),
                  
                  box(
                    title = "Notes:", status = "primary", solidHeader = TRUE, collapsible = TRUE,
                    htmlOutput("paragraph")
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
  
  output$paragraph <- renderText({
    "For the species page, we have several different inputs of data. For the actions, habitats, and threats options
    a histogram is created. This histogram is used because our data sets for these topics gave us sentences as data describing
    the issues. The histogram shows the most commonly occurring words or phrases that account for that topic. This can give
    the readers ideas about the most prevalent issues for action that needs to be made for conservation, the general habitats
    of the animal, and the things threatening the animal. We also have created a line plot to show the how the endangerment
    levels for the animal has changed over the years."
    
  })
  
  output$paragraphcountry <- renderText ({
    "For the country page, we put our focus on showing visitors what levels of endangerment are for any country. The pie chart shows 
     the percentage of animals in each category depending on the country input. For example, if you put in US for the United States, it 
     shows that 68% of the accounted species are under the least concern of endangerment, while only around 3% are considered extinct. 
     We have also constructed a map that shows all the countries at once for any given endangerment level"
  })
  
  output$picture <- renderText({
    src <- GetImageURL(input$text)
    c('<img src="', src, '" width="300px" height="300px">')  
  })
  
  output$worldMap <- renderPlotly({
    p
  })
  
  output$country.pie <- renderPlotly({
    iso2 <- as.character(input$country)
    GetPie(iso2)
  })
  
  output$url <- renderUI({
    tagList("Link to more information:", GetUrl(input$text))
  })
  
  output$nameBox <- renderValueBox({
    valueBox(
      paste0(GetCommonName(input$text)), "Common Name", icon = icon("bug"),
      color = "purple"
    )
  })
  
}

shinyApp(ui, server)