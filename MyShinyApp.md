========================================================
# Developing Data Products - Week 4 Assignment  

Francisco J. Guzman  
01-Jul-2021

========================================================

# Coursera Reproducible Pitch

This is a task for the data science coursera course about developing data products for week 4. As part of this, I have created a shiny app and deployed it on the shiny server. The link is https://rpubs.com/guzmanfr/MyShinyApp  
Code can be found at https://github.com/guzmanfr/MyShinyApp


```r
# summary(swiss)
```

Overview
========================================================

The shiny app plots a graph for Ferlitity standard measure Vs Agriculture and Education. Agriculture is the percentage of Males dedicated to such activity and Education is the percentage of population with complete primary education or beyond.


```
[1] "Fertility:"
```

```
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  35.00   64.70   70.40   70.14   78.45   92.50 
```

```
[1] "Agriculture:"
```

```
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   1.20   35.90   54.10   50.66   67.65   89.70 
```

```
[1] "Education:"
```

```
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   1.00    6.00    8.00   10.98   12.00   53.00 
```

UI Code
========================================================

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


Server Code
========================================================

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
