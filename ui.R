library(shiny)
library(plotly)
library(knitr)

# Knit markdown file
rmdfile <- c("about-us.Rmd")
sapply(rmdfile, knit, quiet = TRUE)


my.ui <- navbarPage(
  "Endangered Species",
  
  tabPanel("Your Country",
           tags$script('
                $(document).ready(function () {
                  navigator.geolocation.getCurrentPosition(onSuccess, onError);
                       
                  function onError (err) {
                     Shiny.onInputChange("geolocation", false);
                  }
                       
                  function onSuccess (position) {
                     setTimeout(function () {
                        var coords = position.coords;
                        console.log(coords.latitude + ", " + coords.longitude);
                        Shiny.onInputChange("geolocation", true);
                        Shiny.onInputChange("lat", coords.latitude);
                        Shiny.onInputChange("long", coords.longitude);
                     }, 1100)
                  }
                });
          '), 
           
           mainPanel(
              h2("Detected Country: "),
              h3(textOutput('country'))
              
             #This line is still buggy :C
             #,plotlyOutput('country.pie')
           )
  ),
  
  tabPanel("Location",
           mainPanel(
             plotlyOutput("worldMap")
           )
  ),
  
  tabPanel("Species",
            sidebarLayout(
               sidebarPanel(
                 textInput("text", label = h3("Text Input"), value = "Enter Species Name Here..."),
                 checkboxGroupInput("checkGroup",
                                    label = h3("Checkbox Group"),
                                    choices = list("Actions" = "action", "Threats" = "threats", "Habitat" = "habitat" )
                 )
               ),
               mainPanel(plotOutput("distPlot"))
            )
           ),
  
  tabPanel("About Us",
             fluidPage(
               includeMarkdown("about-us.md")
             )
  )
)

# Define UI for application that draws a histogram
shinyUI(my.ui)
