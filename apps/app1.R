require(rCharts)

data <- reactive({
  if (input$measure == "Fixed") {
    c(390, 149, 78, 129, 170, 320, 100)
  } else if (input$measure == "Random") {
    sample(1:100, 7, replace = T)
  }
})

output$test <- renderText({
  input$measure
})

output$librariesChart <- renderChart({
  
  a <- rCharts::Highcharts$new()
  
  #data <- function() c(1,3,2)
  
  lst <- function(type, add_y = 0) {
    list(
      list(
        data = list(
          list(
            y = data()[1] + add_y, 
            url = "http://www.highcharts.com/", 
            marker = list(
              symbol = 'url(https://dl.dropboxusercontent.com/u/2904328/logos/60/highcharts-wide-logo.png)'),
            name = "Highcharts"
          ),
          list(
            y = data()[2] + add_y, 
            url = "http://www.polychartjs.com/", 
            marker = list(
              symbol = 'url(https://dl.dropboxusercontent.com/u/2904328/logos/60/polychart-wide-logo.png)'),
            name = "Polychart"
          ),
          list(
            y = data()[3] + add_y, 
            url = "http://leafletjs.com/", 
            marker = list(
              symbol = 'url(https://dl.dropboxusercontent.com/u/2904328/logos/60/leaflet-wide-logo.png)'),
            name = "Leaflet"
          ),
          list(
            y = data()[4] + add_y, 
            url = "http://tenxer.github.io/xcharts/", 
            marker = list(
              symbol = 'url(https://dl.dropboxusercontent.com/u/2904328/logos/60/xcharts-wide-logo.png)'),
            name = "xCharts"
          ),
          list(
            y = data()[5] + add_y, 
            url = "http://nvd3.org/", 
            marker = list(
              symbol = 'url(https://dl.dropboxusercontent.com/u/2904328/logos/60/nvd3-wide-logo.png)'),
            name = "NVD3"
          ),
          list(
            y = data()[6] + add_y, 
            url = "http://code.shutterstock.com/rickshaw/", 
            marker = list(
              symbol = 'url(https://dl.dropboxusercontent.com/u/2904328/logos/60/rickshaw-wide-logo.png)'),
            name = "Rickshaw"
          ),
          list(
            y = data()[7] + add_y, 
            url = "http://www.oesmith.co.uk/morris.js/", 
            marker = list(
              symbol = 'url(https://dl.dropboxusercontent.com/u/2904328/logos/60/morris-wide-logo.png)'),
            name = "Morris"
          )
        ), type = type, color = "#eeeeee", borderColor= "black"
      )
    )
  }
  
  a$series(lst("column"))
  a$series(lst("scatter", max(data())*0.1))
  
  a$plotOptions(series = list(cursor = 'pointer', point = list(events = list(click = "#! function() { window.open(this.options.url); } !#")), animation = list(duration = 750)))
  a$tooltip(useHTML = T, formatter = "#! function() { return this.point.name; } !#")
  # a$xAxis(title = list(enabled = F), type = "category", lineWidth = 0, minorTickLength = 0, tickLength = 0)
  a$xAxis(title = list(enabled = F), labels = list(enabled = F), lineWidth = 0, minorTickLength = 0, tickLength = 0)
  a$yAxis(title = list(enabled = F), lineWidth = 1.5, gridLineWidth = 0, minorTickLength = 0, tickLength = 10)
  a$legend(enabled = F)
  a$set(dom = 'librariesChart', width = 600)
  a$chart(backgroundColor = NULL)
  #return(a$print(include_assets=T))
  return(a)
  #a$html()
})
