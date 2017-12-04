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
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Information For Species"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
          textInput("text", label = h3("Text Input"), value = "Enter Species Name Here..."), 
          checkboxGroupInput("checkGroup",
                             label = h3("Checkbox Group"),
                             choices = list("Actions" = "action", "Threats" = "threats", "Habitat" = "habitat" )
          )
    ),
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
