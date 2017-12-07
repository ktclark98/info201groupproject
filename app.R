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
source("species-country.R")

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Endangered Species",
                  tags$li(class="dropdown",
                          tags$a(href="https://github.com/ktclark98/info201groupproject",
                                 tags$img(height = "20px",
                                          src="GitHub-Mark-Light-64px.png")
                                 )
                          )
                  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("database")),
      menuItem("Country", tabName = "country", icon = icon("globe")),
      menuItem("Species", tabName = "species", icon = icon("paw")),
      menuItem("About", tabName = "about", icon = icon("user-circle"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dashboard",
              fluidPage(
                title="dash",
                fluidRow(
                  valueBox(species.count, "Total Species", icon=icon("bug"),width =3, color="red"),
                  valueBox(country.count, "Total Countries", icon=icon("globe"), width=3,color="red")
                ),
                fluidRow(
                  box(
                    style="font-size:120%", background = "purple",
                    h2("Our Goal"),
                    p("Species extinction is happening faster than ever as modern human industries continue to grow.
                      This site is dedicated to informing you about the threatened species of the world. We have two specific
                      goals in mind:"),
                    tags$ul(
                      tags$li("Give information on threatened species in your country"),
                      tags$li("Give information on a specific threatened species of your choosing")
                    )
                  )
                ),
                fluidRow(
                  box(
                    style="font-size:120%", background = "purple",
                    h2("Data Source"),
                    p("Our data is obtained from the", a(strong("IUCN Red List API"), href="http://apiv3.iucnredlist.org/",
                                                         target="_blank", style="color :white; font-weight : bold;"),
                      ". The IUCN, or International Union for Conservation of Nature is an international organization established
                      in 1948 with the mission to help societies throughout the world conserve the integrity and diversity of nature. 
                      They are most known for their Red List of Threatened Species"
                    )
                  )
                )
              )
      ),
      tabItem(tabName = "country",
              fluidRow(
                box(
                  style = "font-size: 120%", background = "light-blue", 
                  solidHeader = FALSE, collapsible = FALSE,
                  h2("Country"),
                  p("For the country page, we put our focus on showing visitors what levels 
                    endangerment are for any country. The pie chart shows 
                    the percentage of animals in each category depending on the country input. 
                    For example, if you put in US for the United States, it 
                    shows that 68% of the accounted species are under the least concern of endangerment, 
                    while only around 3% are considered extinct. 
                    We have also constructed a map that shows all the countries at once for any given endangerment level")
                ),
                valueBoxOutput("species")
              ),
              fluidRow(
                box(
                  textInput("country", label = h3("Enter Country's 3 Letter Code:"), value = "USA")
                ),
                box(
                  selectInput("mapGroup",
                              label = h3("Select Endangered Level"),
                              choices = list("Critically Endangered" = "CR",
                                             "Endangered" = "EN",
                                             "Extinct" = "EX",
                                             "Extinct in the Wild" = "EW",
                                             "Vulnerable" = "VU",
                                             "Near Threatened" = "NT",
                                             "Least Concern" = "LC")
                  )
                ),
                box(
                  plotlyOutput('country.pie', height = 500)
                ),

                box(
                  plotlyOutput("worldMap", height = 500)
                )
              )
      ),
      
      tabItem(tabName = "species",
              fluidRow(
                box(
                  style = "font-size: 120%", background = "light-blue", 
                  solidHeader = FALSE, collapsible = FALSE,
                  h2("Species"),
                  p("For the species page, we have several different inputs of data. For the actions, habitats, and threats options
                    a histogram is created. This histogram is used because our data sets for these topics gave us sentences as data describing
                    the issues. The histogram shows the most commonly occurring words or phrases that account for that topic. This can give
                    the readers ideas about the most prevalent issues for action that needs to be made for conservation, the general habitats
                    of the animal, and the things threatening the animal. We also have created a line plot to show the how the endangerment
                    levels for the animal has changed over the years.")
                )
              ),
              fluidRow(
                box(
                  status = "primary",
                  textInput("text", label = h3("Enter Species Name below"), value = "Loxodonta africana"), width=6
                ),
                valueBoxOutput("nameBox", width=3),
                valueBoxOutput("countryBox", width=3)
              ),
              fluidRow(
                tabBox(
                  title="Graphs",
                  id = "tabGraphs",
                  tabPanel("Historical Assessment", plotOutput("historical")),
                  tabPanel("Habitat", plotOutput("habitat")),
                  tabPanel("Threats", plotOutput("threat")),
                  tabPanel("Conservation Actions", plotOutput("action"))
                ),
              
                box(
                  title = "Picture", solidHeader = TRUE, status ="primary",
                  htmlOutput("picture"),
                  uiOutput("url"), width=2
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
  output$threat <- renderPlot({
    ThreatHistogram(input$text)
  })
  
  output$historical <- renderPlot({
    HistoricalAssessment(input$text)
  })
  
  output$action <- renderPlot({
    ConservationHistogram(input$text)
  })
  
  output$habitat <- renderPlot({
    HabitatHistogram(input$text)
  })
  
  output$picture <- renderText({
    src <- GetImageURL(input$text)
    c('<img src="', src, '" width="335px" height="300px">')  
  })
  
  output$species <- renderValueBox({
    valueBox(
      GetNumberSpecies(GetISO2(as.character(input$country))), "Threatened Species in Selected Country", 
      icon=icon("bug"), color="red"
    ) 
  })
  
  output$worldMap <- renderPlotly({
    plot <- CategoryMap(input$mapGroup)
  })
  
  output$country.pie <- renderPlotly({
    iso2 <- GetISO2(as.character(input$country))
    GetPie(iso2)
  })
  
  output$url <- renderUI({
    this.url <- a("IUCN RedList", href=GetUrl(input$text))
    tagList("Link to more information:", this.url)
  })
  
  output$nameBox <- renderValueBox({
    valueBox(
      paste0(GetCommonName(input$text)), "Common Name", icon = icon("bug"),
      color = "purple", width=3
    )
  })
  
  output$countryBox <- renderValueBox({
    valueBox(
      CountryOfSpecies(input$text), "Countries This Species Habitats", icon=icon("globe"),
      color = "purple", width=3
    )
  })
}

shinyApp(ui, server)