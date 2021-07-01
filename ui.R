# -----------------------------------
# Author: Francisco J Guzman
# Date: 01-Jul-2021
# Filename: ui.R
# Description: Shiny application to demonstrate application deployment and user
#               interaction - User Interface code
# -----------------------------------

setwd("~/Learning_R/DevDataProds/MyShinyApp")

library(shiny)

shinyUI(fluidPage(
  # Application title
  titlePanel("Impact of Agriculture and Education in population Fertility"),
  
  # Sidebar with a slider input for Agriculture 
  sidebarLayout(
    sidebarPanel(
      checkboxInput("showAgri", "Turn Fert~Agri plot on/off", value = TRUE),
      
      sliderInput("sliderAgri",
                  "Select Agriculture % value:",
                  min = 1,
                  max = 100,
                  value = 50),
      
      checkboxInput("showEdu", "Turn Fert~Edu Plot on/off", value = TRUE),
      
      sliderInput("sliderEdu",
                  "Select Education % value:",
                  min = 1,
                  max = 100,
                  value = 50),
      
      submitButton("Calculate & Refresh")
    ),
    
    # Show a plot of the generated Fertility
    mainPanel(
      plotOutput("FertPlot"),
      
      #h3("Predicted Fertility based on Agriculture:"), 
      h3(textOutput("predAgri")),
      #h3("Predicted Fertility based on Education:"), 
      h3(textOutput("predEdu"))
    )
  )
))