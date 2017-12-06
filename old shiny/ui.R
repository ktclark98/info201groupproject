library(shiny)
library(plotly)
library(knitr)
library(tidytext)
# Knit markdown file
rmdfile <- c("about-us.Rmd")
sapply(rmdfile, knit, quiet = TRUE)

my.ui <- navbarPage(
  
  "Endangered Species",
  
  tabPanel("Your Country",
           sidebarLayout(
             sidebarPanel(
               textInput("country", label = h3("Enter Your Country's 2 Letter Code:"))
             ),
             mainPanel(
               plotlyOutput('country.pie')
             )
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
               textInput("text", label = h3("Species"), value = "Enter Species Name Here..."),
               selectInput("checkGroup",
                           label = h3("Select Information"),
                           choices = list("Actions" = "action", "Threats" = "threats", "Habitat" = "habitat", "Historial Assessment" = "historical")
               )
             ),
             mainPanel(
               #plotOutput("distPlot"),
               plotOutput("histPlot")
             )
           )
  ),
  
  tabPanel("About Us",
           fluidPage (
             includeMarkdown("about-us.Rmd")
           )
  )
)


# Define UI for application that draws a histogram
shinyUI(my.ui)