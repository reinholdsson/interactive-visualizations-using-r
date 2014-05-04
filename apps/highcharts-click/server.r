# server.r
library(shiny)
library(rCharts)

shinyServer(function(input, output) {
  
  output$text <- renderText({
    sprintf("You have clicked on %s.", input$click$capital)
  })
  
  output$chart <- renderChart({
    
    a <- Highcharts$new()
    
    a$series(data = list(
      list(x = 0, y = 40, capital = "Stockholm"),
      list(x = 1, y = 50, capital = "Copenhagen"),
      list(x = 2, y = 60, capital = "Oslo")
    ), type = "bar")
    
    a$plotOptions(
      bar = list(
        cursor = "pointer", 
        point = list(
          events = list(
            
            click = "#! function() { Shiny.onInputChange('click', {capital: this.capital})} !#"
            
          )
        )
      )
    )
    
    a$addParams(dom = "chart")
    return(a)
  })
})