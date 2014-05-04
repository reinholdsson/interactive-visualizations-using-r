# ui.r
library(shiny)
library(rCharts)

shinyUI(bootstrapPage(chartOutput("chart", "highcharts"), textOutput("text")))
