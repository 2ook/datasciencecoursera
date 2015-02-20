barn <- matrix(c(0, 7, 0, 6, 2, 5, 3, 4, -3, 4, 3, 4, 3, 0, 2, 0, 0, 0, 
                 2, 0, 2, 2, -2, 2, -2, 0, 2, 0, 0, 2, 0, 0, -2, 2, -2, 0, 
                 0, 0, 0, 2, -2, 2, -2, 0, -3, 0, -3, 4, -2, 5, 0, 6), ncol = 2, byrow = TRUE)

barnshear <- function(b, type) {
  barn <- matrix(c(0, 7, 0, 6, 2, 5, 3, 4, -3, 4, 3, 4, 3, 0, 2, 0, 0, 0, 
                   2, 0, 2, 2, -2, 2, -2, 0, 2, 0, 0, 2, 0, 0, -2, 2, -2, 0, 
                   0, 0, 0, 2, -2, 2, -2, 0, -3, 0, -3, 4, -2, 5, 0, 6), ncol = 2, byrow = TRUE)
  
  
  if(type == 'X'){
    shear <- matrix(c(1, 0, b, 1), ncol = 2, byrow = TRUE)
  }
  
  if(type == 'Y'){
    shear <- matrix(c(1, b, 0, 1), ncol = 2, byrow = TRUE)
  }
  
  par(pin = c(5, 5))
  
  plot(barn %*% shear, pch = 19, col = 'dark red', type = 'b', axes = F, xlab = '', ylab = '', 
       main = '')
  abline(h = 0)
  abline(v = 0)
  
}

shinyServer(function(input, output) {
  output$barnPlot <- renderPlot({
    par(pin = c(5, 5))
    
    plot(barn, pch = 19, col = 'dark red', type = 'b', axes = F, xlab = '', ylab = '', 
         main = '')
    abline(h = 0)
    abline(v = 0)
  })
  
  output$shearType <- renderPrint({input$shearType})
  
  output$b <- renderPrint({input$b})
  
  output$shearPlot <- renderPlot({
    barnshear(b = input$b, type = input$shearType)
  })
  
}
)