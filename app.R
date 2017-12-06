## app.R ##
library(shiny)
library(shinydashboard)

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
              h2("Country")
      ),
      
      # Second tab content
      tabItem(tabName = "location",
              h2("Location")
      ),
      
      tabItem(tabName = "species",
              h2("Species")
      ),
      
      tabItem(tabName = "about",
              fluidPage(
                includeMarkdown("about-us.Rmd")
              )
      )
    )
  )
)

server <- function(input, output) { }

shinyApp(ui, server)

