# --------------------------------------------
# Author: Francisco J. Guzman
# Date: 01-Jul-2021
# Filename: server.R
# Description: Shiny application to demonstrate application deployment and user
#               interaction - server code
# --------------------------------------------

setwd("~/Learning_R/DevDataProds/MyShinyApp")

library(shiny)

shinyServer(function(input, output) {
  fit1 <- lm(Fertility ~ Agriculture, data = swiss)
  fit2 <- lm(Fertility ~ Education, data = swiss)
  
  fit1pred <- reactive({
    valAgri <- input$sliderAgri
    predict(fit1, newdata = data.frame(Agriculture = valAgri))
  })
  
  fit2pred <- reactive({
    valEdu <- input$sliderEdu
    predict(fit2, newdata = data.frame(Education = valEdu))
  })
  
  output$FertPlot <- renderPlot({
    valAgri <- input$sliderAgri
    valEdu <- input$sliderEdu
    
    if((input$showEdu) && (input$showAgri)){
      par(mfrow = c(1, 2), mar = c(5, 4, 2, 1))
    }
    
    # Plot #1: Fertility Vs Agriculture (% of males dedicated to Agriculture)
    if(input$showAgri){
      plot(swiss$Agriculture, swiss$Fertility, xlab = "% of males dedicated", 
           ylab = "Fertility (Std Measure)", pch = 20, col = "dark blue", main = "Fertility Vs Agriculture", xlim = c(0,100))
      
      abline(fit1, col = "dark green", lwd = 2)
      points(valAgri, fit1pred(), col = "dark red", pch = 16, cex = 2)
    }
    
    # Plot #2: Fertility Vs Education (% of people beyond Primary education)
    if(input$showEdu){
      plot(swiss$Education, swiss$Fertility, xlab = "% beyond primary School", 
           ylab = "Fertility (Std Measure)", pch = 20, col = "dark blue", main = "Fertility Vs Education", xlim = c(0,100))
      
      abline(fit2, col = "dark green", lwd = 2)
      points(valEdu, fit2pred(), col = "dark red", pch = 16, cex = 2)
    }
  })
  
  output$predAgri<- renderText({
    if(input$showAgri){
      paste("Predicted Fertility based on % of males dedicated to Agriculture: ", round(fit1pred(), digits = 3))
    }
  })
  
  output$predEdu <- renderText({
    if(input$showEdu){
      paste("Predicted Fertility based on % of People beyond primary Education: ", round(fit2pred(), digits = 3))
    }
  })
})