#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
my.ui <- navbarPage(
  "Endangered Species",
  
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
           sidebarLayout(
               textOutput("Hello"),
             mainPanel("HI")
           )
  )
  
)

# Define UI for application that draws a histogram
shinyUI(my.ui)
