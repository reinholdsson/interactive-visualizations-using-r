---
title: Interactive visualizations using R
author: Thomas Reinholdsson
mode: selfcontained
framework: impressjs
twitter:
  text: "Interactive visualizations using R!"
widgets     : [quiz] 
ext_widgets : {rCharts: [libraries/highcharts, libraries/nvd3]}

--- #big x:0 y:0 rot:0 scale:10




<style>
  body {
    background: radial-gradient(rgb(255, 255, 255), rgb(214, 236, 248));
  }
  h1 { font-size: 100%; }
  h2 { font-size: 80%; }
  h3 { font-size: 60%; }
  h4 { font-size: 50%; }
  pre code {
    display: block;
    background: white;
    color: #4d4d4c;
    font-family: Menlo, Monaco, Consolas, monospace;
    line-height: 1.5;
    border: 1px solid #ccc;
    padding: 10px;
    font-size: 20%;
}
</style>

Interactive visualizations<br>using <b>R</b>

Thomas Reinholdsson

--- x:0 y:4000 rot:0 scale:4

# **rCharts**

## *... an R package to create, customize and publish interactive javascript visualizations from R using a familiar lattice style plotting interface*

#### By: Ramnathv Vaidyanathan (aut, cre), Kenton Russel (ctb), Thomas Reinholdsson (ctb)

--- x:-2000 y:5000 rot:0 scale:1

## Polychart


```r
a <- rPlot(mpg ~ wt | am + vs, data = mtcars, type = 'point', color = 'gear')
a
```

<iframe src='
assets/fig/unnamed-chunk-1.html
' scrolling='no' seamless
class='rChart polycharts '
id=iframe-
chartc6ae1d507010
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


--- x:-1000 y:5000 rot:0 scale:1

## Morris


```r
data(economics, package = 'ggplot2')
econ <- transform(economics, date = as.character(date))
a <- mPlot(x = 'date', y = c('psavert', 'uempmed'), type = 'Line',
  data = econ)
a$set(pointSize = 0, lineWidth = 1)
a
```

<iframe src='
assets/fig/unnamed-chunk-2.html
' scrolling='no' seamless
class='rChart morris '
id=iframe-
chartc6ae3583d0d
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


--- x:0 y:5000 rot:0 scale:1

## NVD3


```r
hair_eye_male <- subset(as.data.frame(HairEyeColor), Sex == "Male")
a <- nPlot(Freq ~ Hair, group = "Eye", data = hair_eye_male, 
  type = 'multiBarChart')
a
```

<iframe src='
assets/fig/unnamed-chunk-3.html
' scrolling='no' seamless
class='rChart nvd3 '
id=iframe-
chartc6ae7d350bee
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


--- x:1000 y:5000 rot:0 scale:1

## xCharts


```r
require(reshape2)
uspexp <- melt(USPersonalExpenditure)
names(uspexp)[1:2] = c('category', 'year')
a <- xPlot(value ~ year, group = 'category', data = uspexp, 
  type = 'line-dotted')
a
```

<iframe src='
assets/fig/unnamed-chunk-4.html
' scrolling='no' seamless
class='rChart xcharts '
id=iframe-
chartc6ae4d1056e3
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>



--- x:2000 y:5000 rot:0 scale:1

## Rickshaw


```r
usp = reshape2::melt(USPersonalExpenditure)
a <- Rickshaw$new()
a$layer(value ~ Var2, group = 'Var1', data = usp, type = 'area')
a$set(width = 600, height = 350)
a
```

<iframe src='
assets/fig/unnamed-chunk-5.html
' scrolling='no' seamless
class='rChart rickshaw '
id=iframe-
chartc6ae1bf63f5d
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>



--- x:2500 y:-3200 scale:1

# rCharts API

<br>

## Lattice function


```r
library(rCharts)
hPlot(Pulse ~ Height, data = MASS::survey, type = "scatter", group = "Exer")
```


<br>

## Chart methods


```r
library(rCharts)
a <- Highcharts$new()
a$chart(type = "line")
a$title(text = "Monthly Average Rainfall")
...
```


#### ... similar to the original JS chart api:s

```
highcharts({
  chart: {
    type: 'column'
  },
  title: {
      text: 'Monthly Average Rainfall'
  },
  ...
```

--- x:3500 y:-3200 scale:1

Why JavaScript?

#### All included JavaScript libraries uses JSON to set chart properties, add data, theme settings, etc. 

#### Thanks to RJSONIO/rjson it's easy to convert between R lists and JSON.

Package structure
### - Layouts
### - JavaScript dependencies
### - R code (ReferenceClasses)

--- x:3500 y:-2500 scale:1

# Layouts (template)

#### inst/libraries/highcharts/layout/chart.html

```
<script type='text/javascript'>
    (function($){
        $(function () {
            var chart = new Highcharts.Chart({{{ chartParams }}});
        });
    })(jQuery);
</script>

```

--- x:3500 y:-2000 scale:1

# JavaScript dependencies

#### inst/libraries/highcharts/config.yml

```
highcharts:
  jshead:
    - js/jquery-1.9.1.min.js
    - js/highcharts.js
    - js/highcharts-more.js
    - js/exporting.js
  cdn:
    jshead:
      - "http://code.jquery.com/jquery-1.9.1.min.js"
      - "http://code.highcharts.com/highcharts.js"
      - "http://code.highcharts.com/highcharts-more.js"
      - "http://code.highcharts.com/modules/exporting.js"
```

--- x:3500 y:-1500 scale:1

# R code (ReferenceClasses)

#### R/Highcharts.R


```r
# Class defintion

Highcharts <- setRefClass("Highcharts", contains = "rCharts", methods = list(
    initialize = function() {
      callSuper(); lib <<- 'highcharts'; LIB <<- get_lib(lib)
      params <<- c(params, list(
        ...
      )
    )
  },
  
  ...
  
  # Wrapper methods
  
  title = function(..., replace = T) {
    params$title <<- setSpec(params$title, ..., replace = replace)
  },
  
  tooltip = function(..., replace = T) {
    params$tooltip <<- setSpec(params$tooltip, ..., replace = replace)
  },
  
  xAxis = function(..., replace = T) {
    params$xAxis <<- setListSpec(params$xAxis, ..., replace = replace)
  },
  
  ...
```


--- x:-4000 y:-2500 scale:4

## rCharts: Highcharts


```r
a <- Highcharts$new()
a$chart(type = "spline", backgroundColor = NULL)
a$series(data = c(1, 3, 2, 4, 5, 4, 6, 2, 3, 5, NA), dashStyle = "longdash")
a$series(data = c(NA, 4, 1, 3, 4, 2, 9, 1, 2, 3, 1), dashStyle = "shortdot")
a$legend(symbolWidth = 80)
a$set(height = 250)
a
```

<iframe src='
assets/fig/unnamed-chunk-9.html
' scrolling='no' seamless
class='rChart highcharts '
id=iframe-
chartc6ae43ba0102
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


--- x:-5000 y:-1500 scale:1

## Custom Themes


```r
a$chart(type = "bar", backgroundColor = NULL)
a$xAxis(title = list(enabled = F), type = "category", lineWidth = 0, minorTickLength = 0, tickLength = 0)
a$yAxis(title = list(enabled = F), labels = list(enabled = F), lineWidth = 0, gridLineWidth = 0, minorTickLength = 0, tickLength = 0)
a$legend(enabled = F)
```

<iframe src='
assets/fig/unnamed-chunk-10.html
' scrolling='no' seamless
class='rChart highcharts '
id=iframe-
chartc6ae68984d0a
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


--- x:-4000 y:-1500 scale:1

## Custom Tooltips


```r
a$tooltip(
  useHTML = T,
  formatter = "#! function() {
    return '<table height=84><tr><td>'
    + '<img src=\"'
    + this.point.url
    + '\" height=80 width=60></td><td>'
    + this.point.text + '<br><br>' + this.point.x + ' years<br>' + this.point.valkrets
    + '</td></tr></table>';} !#"
)
```

<iframe src='
assets/fig/unnamed-chunk-11.html
' scrolling='no' seamless
class='rChart highcharts '
id=iframe-
chartc6ae66ea012b
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


--- x:-3000 y:-1500 scale:1

## Clickable Points


```r
a$plotOptions(
  scatter = list(
    cursor = "pointer", 
    point = list(
      events = list(
        click = "#! function() { window.open(this.options.url); } !#")), 
    marker = list(
      symbol = "circle", 
      radius = 5
    )
  )
)
```

<iframe src='
assets/fig/unnamed-chunk-12.html
' scrolling='no' seamless
class='rChart highcharts '
id=iframe-
chartc6aecf2e2d6
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


--- x:5400 y:2200 scale:2

## Publish on github


```r
a <- create_chart("code.r")
a$publish("My Chart", host = "gist")
# Please enter your github username: reinholdsson
# Please enter your github password: ************
# Your gist has been published
# View chart at http://rcharts.github.io/viewer/?11519927
```


<br>

<iframe id='iframe_id' src = 'http://rcharts.io/viewer/?11519927' height='450px' width='1000px'></iframe>

--- x:3200 y:3000 scale:2

## Shiny

#### **server.r**: *output$chart <- renderChart({ ... }})*

#### **ui.r**: *chartOutput("chart", "highcharts")*

<iframe id='iframe_id' src = 'http://glimmer.rstudio.com/reinholdsson/shiny-dashboard/' height='550px' width='800px'></iframe>

--- x:5400 y:3800 scale:2

## Highcharts: Shiny Input Binding

#### server.r


```r
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
            
    ))))
    a$addParams(dom = "chart")
    return(a)
  })
})
```


#### ui.r


```r
library(shiny)
library(rCharts)
shinyUI(bootstrapPage(chartOutput("chart", "highcharts"), textOutput("text")))
```


--- x:-4500 y:0 scale:4

# **rMaps**

### *... an R package to create, customize and publish interactive maps from R. It supports multiple mapping libraries, including leaflet, datamaps and crosslet.*

#### By: Ramnath Vaidyanathan (aut, cre)

--- x:-5500 y:1000 scale:1

## Datamaps


```r
ichoropleth(
  Crime ~ State,
  data = subset(violent_crime, Year == 2010),
  pal = 'PuRd'
)
```

<iframe src='
assets/fig/unnamed-chunk-16.html
' scrolling='no' seamless
class='rChart datamaps '
id=iframe-
chartc6ae1e0a563e
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


--- x:-4500 y:1000 scale:1

## Animations with AngularJS


```r
ichoropleth(
  Crime ~ State,
  data = violent_crime,
  animate = 'Year'
)
```

<iframe src='
assets/fig/unnamed-chunk-17.html
' scrolling='no' seamless
class='rChart datamaps '
id=iframe-
chartc6ae38a40fda
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


#### Use argument `play = T` to add a play button.

--- x:-3500 y:1000 scale:1

## Leaflet





```r
# data <- ...
a <- rMaps:::Leaflet$new()
a$setView(c(59.34201, 18.09503), zoom = 13)
a$geoJson(data,
  onEachFeature = '#! function(feature, layer){
    if (feature.properties && feature.properties.popupContent) {
        layer.bindPopup(feature.properties.popupContent);
    }
  } !#',
  pointToLayer =  "#! function(feature, latlng){
    return L.circleMarker(latlng, {
      radius: 6,
      fillColor: feature.properties.fillColor,
      weight: 1,
      fillOpacity: 0.8
    })
  }!#"
)
a$set(height = 300)
a
```

<iframe src='
assets/fig/unnamed-chunk-19.html
' scrolling='no' seamless
class='rChart leaflet '
id=iframe-
chartc6ae1b0cce43
></iframe>
<style>iframe.rChart{ width: 100%; height: 400px;}</style>


--- x:4500 y:0 scale:4

# **googleVis**

## *... an R package providing an interface between R and the Google Chart Tools*

### By: Markus Gesmann (aut, cre), Diego de Castillo (aut), Joe Cheng (ctb)

--- x:4000 y:1000 scale:1

## Sankey


```r
dat <- data.frame(From=c(rep("A",3), rep("B", 3)), 
                  To=c(rep(c("X", "Y", "Z"),2)),
                  Weight=c(5,7,6,2,9,4))
a <- gvisSankey(dat, from="From", to="To", weight="Weight",
                options=list(height=250))
```


<!-- Sankey generated in R 3.0.2 by googleVis 0.5.1 package -->
<!-- Sun May  4 19:36:42 2014 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataSankeyIDc6ae65b99e94 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
 "A",
"X",
5 
],
[
 "A",
"Y",
7 
],
[
 "A",
"Z",
6 
],
[
 "B",
"X",
2 
],
[
 "B",
"Y",
9 
],
[
 "B",
"Z",
4 
] 
];
data.addColumn('string','From');
data.addColumn('string','To');
data.addColumn('number','Weight');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartSankeyIDc6ae65b99e94() {
var data = gvisDataSankeyIDc6ae65b99e94();
var options = {};
options["width"] =    400;
options["height"] =    250;

    var chart = new google.visualization.Sankey(
    document.getElementById('SankeyIDc6ae65b99e94')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "sankey";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartSankeyIDc6ae65b99e94);
})();
function displayChartSankeyIDc6ae65b99e94() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartSankeyIDc6ae65b99e94"></script>
 
<!-- divChart -->
  
<div id="SankeyIDc6ae65b99e94"
  style="width: 400px; height: 250px;">
</div>


--- x:5000 y:1100 scale:1

## Calendar


```r
a <- gvisCalendar(Cairo, datevar="Date",
                  numvar="Temp",
                  options=list(calendar="{ cellSize: 10 }"))
```


<!-- Calendar generated in R 3.0.2 by googleVis 0.5.1 package -->
<!-- Sun May  4 19:36:42 2014 -->


<!-- jsHeader -->
<script type="text/javascript">
 
// jsData 
function gvisDataCalendarIDc6ae7d5a3ab8 () {
var data = new google.visualization.DataTable();
var datajson =
[
 [
 new Date(2002,0,1),
13.61111111 
],
[
 new Date(2002,0,2),
15.16666667 
],
[
 new Date(2002,0,3),
12 
],
[
 new Date(2002,0,4),
12 
],
[
 new Date(2002,0,5),
13.05555556 
],
[
 new Date(2002,0,6),
10.05555556 
],
[
 new Date(2002,0,7),
9.277777778 
],
[
 new Date(2002,0,8),
10.5 
],
[
 new Date(2002,0,9),
9.888888889 
],
[
 new Date(2002,0,10),
8.666666667 
],
[
 new Date(2002,0,11),
10.83333333 
],
[
 new Date(2002,0,12),
10.94444444 
],
[
 new Date(2002,0,13),
11.72222222 
],
[
 new Date(2002,0,14),
11.44444444 
],
[
 new Date(2002,0,15),
13.16666667 
],
[
 new Date(2002,0,16),
12.88888889 
],
[
 new Date(2002,0,17),
12.88888889 
],
[
 new Date(2002,0,18),
13 
],
[
 new Date(2002,0,19),
13.66666667 
],
[
 new Date(2002,0,20),
13.5 
],
[
 new Date(2002,0,21),
13.66666667 
],
[
 new Date(2002,0,22),
13.66666667 
],
[
 new Date(2002,0,23),
13.83333333 
],
[
 new Date(2002,0,24),
13 
],
[
 new Date(2002,0,25),
13.27777778 
],
[
 new Date(2002,0,26),
13.77777778 
],
[
 new Date(2002,0,27),
13.33333333 
],
[
 new Date(2002,0,28),
14.66666667 
],
[
 new Date(2002,0,29),
14.5 
],
[
 new Date(2002,0,30),
14.33333333 
],
[
 new Date(2002,0,31),
14.05555556 
],
[
 new Date(2002,1,1),
14.11111111 
],
[
 new Date(2002,1,2),
15.16666667 
],
[
 new Date(2002,1,3),
15.66666667 
],
[
 new Date(2002,1,4),
16.16666667 
],
[
 new Date(2002,1,5),
16 
],
[
 new Date(2002,1,6),
14.55555556 
],
[
 new Date(2002,1,7),
16.33333333 
],
[
 new Date(2002,1,8),
16.55555556 
],
[
 new Date(2002,1,9),
18.22222222 
],
[
 new Date(2002,1,10),
15.88888889 
],
[
 new Date(2002,1,11),
14.05555556 
],
[
 new Date(2002,1,12),
15.16666667 
],
[
 new Date(2002,1,13),
15.33333333 
],
[
 new Date(2002,1,14),
15.38888889 
],
[
 new Date(2002,1,15),
16.05555556 
],
[
 new Date(2002,1,16),
16 
],
[
 new Date(2002,1,17),
15.83333333 
],
[
 new Date(2002,1,18),
15.44444444 
],
[
 new Date(2002,1,19),
15.05555556 
],
[
 new Date(2002,1,20),
15.88888889 
],
[
 new Date(2002,1,21),
18.22222222 
],
[
 new Date(2002,1,22),
18.77777778 
],
[
 new Date(2002,1,23),
23.27777778 
],
[
 new Date(2002,1,24),
17.27777778 
],
[
 new Date(2002,1,25),
17.88888889 
],
[
 new Date(2002,1,26),
15.77777778 
],
[
 new Date(2002,1,27),
14.5 
],
[
 new Date(2002,1,28),
15 
],
[
 new Date(2002,2,1),
15.94444444 
],
[
 new Date(2002,2,2),
16.5 
],
[
 new Date(2002,2,3),
17.27777778 
],
[
 new Date(2002,2,4),
18.11111111 
],
[
 new Date(2002,2,5),
17.55555556 
],
[
 new Date(2002,2,6),
19.72222222 
],
[
 new Date(2002,2,7),
22.83333333 
],
[
 new Date(2002,2,8),
22.94444444 
],
[
 new Date(2002,2,9),
22.66666667 
],
[
 new Date(2002,2,10),
24 
],
[
 new Date(2002,2,11),
24.55555556 
],
[
 new Date(2002,2,12),
20.22222222 
],
[
 new Date(2002,2,13),
18.44444444 
],
[
 new Date(2002,2,14),
17.5 
],
[
 new Date(2002,2,15),
17.55555556 
],
[
 new Date(2002,2,16),
17.11111111 
],
[
 new Date(2002,2,17),
17.33333333 
],
[
 new Date(2002,2,18),
19.44444444 
],
[
 new Date(2002,2,19),
18.27777778 
],
[
 new Date(2002,2,20),
17.44444444 
],
[
 new Date(2002,2,21),
19.05555556 
],
[
 new Date(2002,2,22),
19.88888889 
],
[
 new Date(2002,2,23),
22.61111111 
],
[
 new Date(2002,2,24),
23.72222222 
],
[
 new Date(2002,2,25),
19.22222222 
],
[
 new Date(2002,2,26),
16.16666667 
],
[
 new Date(2002,2,27),
16.33333333 
],
[
 new Date(2002,2,28),
15.88888889 
],
[
 new Date(2002,2,29),
15.72222222 
],
[
 new Date(2002,2,30),
18.55555556 
],
[
 new Date(2002,2,31),
20.38888889 
],
[
 new Date(2002,3,1),
17.94444444 
],
[
 new Date(2002,3,2),
15.83333333 
],
[
 new Date(2002,3,3),
17.88888889 
],
[
 new Date(2002,3,4),
22.05555556 
],
[
 new Date(2002,3,5),
27.83333333 
],
[
 new Date(2002,3,6),
24.16666667 
],
[
 new Date(2002,3,7),
19.33333333 
],
[
 new Date(2002,3,8),
18.5 
],
[
 new Date(2002,3,9),
18.88888889 
],
[
 new Date(2002,3,10),
19.33333333 
],
[
 new Date(2002,3,11),
20.66666667 
],
[
 new Date(2002,3,12),
22.55555556 
],
[
 new Date(2002,3,13),
26.5 
],
[
 new Date(2002,3,14),
31.38888889 
],
[
 new Date(2002,3,15),
30.83333333 
],
[
 new Date(2002,3,16),
25.61111111 
],
[
 new Date(2002,3,17),
21 
],
[
 new Date(2002,3,18),
19.16666667 
],
[
 new Date(2002,3,19),
19.33333333 
],
[
 new Date(2002,3,20),
19.05555556 
],
[
 new Date(2002,3,21),
19.27777778 
],
[
 new Date(2002,3,22),
19.88888889 
],
[
 new Date(2002,3,23),
22.22222222 
],
[
 new Date(2002,3,24),
20.16666667 
],
[
 new Date(2002,3,25),
19.61111111 
],
[
 new Date(2002,3,26),
18.72222222 
],
[
 new Date(2002,3,27),
18.94444444 
],
[
 new Date(2002,3,28),
19.5 
],
[
 new Date(2002,3,29),
19.27777778 
],
[
 new Date(2002,3,30),
20.22222222 
],
[
 new Date(2002,4,1),
21.44444444 
],
[
 new Date(2002,4,2),
21.16666667 
],
[
 new Date(2002,4,3),
21.66666667 
],
[
 new Date(2002,4,4),
23.27777778 
],
[
 new Date(2002,4,5),
25.88888889 
],
[
 new Date(2002,4,6),
25.66666667 
],
[
 new Date(2002,4,7),
24.33333333 
],
[
 new Date(2002,4,8),
24.88888889 
],
[
 new Date(2002,4,9),
26 
],
[
 new Date(2002,4,10),
27.33333333 
],
[
 new Date(2002,4,11),
24.83333333 
],
[
 new Date(2002,4,12),
27.77777778 
],
[
 new Date(2002,4,13),
29.72222222 
],
[
 new Date(2002,4,14),
22.88888889 
],
[
 new Date(2002,4,15),
22.27777778 
],
[
 new Date(2002,4,16),
22.61111111 
],
[
 new Date(2002,4,17),
22.55555556 
],
[
 new Date(2002,4,18),
23.22222222 
],
[
 new Date(2002,4,19),
23.16666667 
],
[
 new Date(2002,4,20),
24.22222222 
],
[
 new Date(2002,4,21),
27.72222222 
],
[
 new Date(2002,4,22),
24 
],
[
 new Date(2002,4,23),
24.83333333 
],
[
 new Date(2002,4,24),
24.44444444 
],
[
 new Date(2002,4,25),
25.5 
],
[
 new Date(2002,4,26),
27.66666667 
],
[
 new Date(2002,4,27),
26.61111111 
],
[
 new Date(2002,4,28),
24.94444444 
],
[
 new Date(2002,4,29),
26.05555556 
],
[
 new Date(2002,4,30),
29.33333333 
],
[
 new Date(2002,4,31),
25.44444444 
],
[
 new Date(2002,5,1),
24.66666667 
],
[
 new Date(2002,5,2),
24.83333333 
],
[
 new Date(2002,5,3),
25.44444444 
],
[
 new Date(2002,5,4),
25.77777778 
],
[
 new Date(2002,5,5),
25.05555556 
],
[
 new Date(2002,5,6),
25.66666667 
],
[
 new Date(2002,5,7),
26.88888889 
],
[
 new Date(2002,5,8),
29.88888889 
],
[
 new Date(2002,5,9),
30.88888889 
],
[
 new Date(2002,5,10),
31.5 
],
[
 new Date(2002,5,11),
28.22222222 
],
[
 new Date(2002,5,12),
25.77777778 
],
[
 new Date(2002,5,13),
25.66666667 
],
[
 new Date(2002,5,14),
26.44444444 
],
[
 new Date(2002,5,15),
26.88888889 
],
[
 new Date(2002,5,16),
26.88888889 
],
[
 new Date(2002,5,17),
27.66666667 
],
[
 new Date(2002,5,22),
27.44444444 
],
[
 new Date(2002,5,23),
27.5 
],
[
 new Date(2002,5,24),
28.11111111 
],
[
 new Date(2002,5,25),
28.72222222 
],
[
 new Date(2002,5,26),
28.44444444 
],
[
 new Date(2002,5,27),
28.16666667 
],
[
 new Date(2002,5,28),
27.11111111 
],
[
 new Date(2002,5,29),
27.16666667 
],
[
 new Date(2002,5,30),
28.27777778 
],
[
 new Date(2002,6,1),
29 
],
[
 new Date(2002,6,2),
28.5 
],
[
 new Date(2002,6,3),
27.61111111 
],
[
 new Date(2002,6,4),
28.5 
],
[
 new Date(2002,6,5),
30.33333333 
],
[
 new Date(2002,6,6),
29.66666667 
],
[
 new Date(2002,6,7),
29.5 
],
[
 new Date(2002,6,8),
28.77777778 
],
[
 new Date(2002,6,9),
32.33333333 
],
[
 new Date(2002,6,10),
29.05555556 
],
[
 new Date(2002,6,11),
28.66666667 
],
[
 new Date(2002,6,12),
29.88888889 
],
[
 new Date(2002,6,13),
31 
],
[
 new Date(2002,6,14),
30.66666667 
],
[
 new Date(2002,6,15),
29.5 
],
[
 new Date(2002,6,16),
30.72222222 
],
[
 new Date(2002,6,17),
31.61111111 
],
[
 new Date(2002,6,18),
31.33333333 
],
[
 new Date(2002,6,19),
30.27777778 
],
[
 new Date(2002,6,20),
29.44444444 
],
[
 new Date(2002,6,21),
28.44444444 
],
[
 new Date(2002,6,22),
28.27777778 
],
[
 new Date(2002,6,23),
29.27777778 
],
[
 new Date(2002,6,24),
29.66666667 
],
[
 new Date(2002,6,25),
29.11111111 
],
[
 new Date(2002,6,26),
31.94444444 
],
[
 new Date(2002,6,27),
34 
],
[
 new Date(2002,6,28),
33.77777778 
],
[
 new Date(2002,6,29),
36.55555556 
],
[
 new Date(2002,6,30),
35.44444444 
],
[
 new Date(2002,6,31),
33.22222222 
],
[
 new Date(2002,7,1),
31 
],
[
 new Date(2002,7,2),
29 
],
[
 new Date(2002,7,3),
28.77777778 
],
[
 new Date(2002,7,4),
29.66666667 
],
[
 new Date(2002,7,5),
30.16666667 
],
[
 new Date(2002,7,6),
30.44444444 
],
[
 new Date(2002,7,7),
30.5 
],
[
 new Date(2002,7,8),
31.61111111 
],
[
 new Date(2002,7,9),
29.05555556 
],
[
 new Date(2002,7,10),
28.83333333 
],
[
 new Date(2002,7,11),
29.33333333 
],
[
 new Date(2002,7,12),
31.77777778 
],
[
 new Date(2002,7,13),
31.83333333 
],
[
 new Date(2002,7,14),
29.66666667 
],
[
 new Date(2002,7,15),
28.94444444 
],
[
 new Date(2002,7,16),
28.77777778 
],
[
 new Date(2002,7,17),
28.55555556 
],
[
 new Date(2002,7,18),
28.61111111 
],
[
 new Date(2002,7,19),
28.38888889 
],
[
 new Date(2002,7,20),
28.88888889 
],
[
 new Date(2002,7,21),
28.83333333 
],
[
 new Date(2002,7,22),
28.27777778 
],
[
 new Date(2002,7,23),
27.55555556 
],
[
 new Date(2002,7,24),
27.55555556 
],
[
 new Date(2002,7,25),
27.77777778 
],
[
 new Date(2002,7,26),
28.5 
],
[
 new Date(2002,7,27),
29 
],
[
 new Date(2002,7,28),
28.66666667 
],
[
 new Date(2002,7,29),
28.11111111 
],
[
 new Date(2002,7,30),
28.22222222 
],
[
 new Date(2002,7,31),
29.5 
],
[
 new Date(2002,8,1),
31.77777778 
],
[
 new Date(2002,8,2),
27.33333333 
],
[
 new Date(2002,8,3),
29.77777778 
],
[
 new Date(2002,8,4),
28.61111111 
],
[
 new Date(2002,8,5),
27.38888889 
],
[
 new Date(2002,8,6),
27.44444444 
],
[
 new Date(2002,8,7),
27.88888889 
],
[
 new Date(2002,8,8),
28.05555556 
],
[
 new Date(2002,8,9),
29.27777778 
],
[
 new Date(2002,8,10),
31.22222222 
],
[
 new Date(2002,8,11),
27.72222222 
],
[
 new Date(2002,8,12),
28.22222222 
],
[
 new Date(2002,8,13),
28.83333333 
],
[
 new Date(2002,8,14),
28.11111111 
],
[
 new Date(2002,8,15),
29.94444444 
],
[
 new Date(2002,8,16),
33.66666667 
],
[
 new Date(2002,8,17),
34.55555556 
],
[
 new Date(2002,8,18),
27.94444444 
],
[
 new Date(2002,8,19),
26.22222222 
],
[
 new Date(2002,8,20),
25.27777778 
],
[
 new Date(2002,8,21),
25.55555556 
],
[
 new Date(2002,8,22),
26.38888889 
],
[
 new Date(2002,8,23),
26.05555556 
],
[
 new Date(2002,8,24),
26.61111111 
],
[
 new Date(2002,8,25),
26.05555556 
],
[
 new Date(2002,8,26),
28 
],
[
 new Date(2002,8,27),
29 
],
[
 new Date(2002,8,28),
28.44444444 
],
[
 new Date(2002,8,29),
30 
],
[
 new Date(2002,8,30),
29.16666667 
],
[
 new Date(2002,9,1),
28.5 
],
[
 new Date(2002,9,2),
26 
],
[
 new Date(2002,9,3),
23.33333333 
],
[
 new Date(2002,9,4),
23.77777778 
],
[
 new Date(2002,9,5),
23.83333333 
],
[
 new Date(2002,9,6),
24.11111111 
],
[
 new Date(2002,9,7),
25.16666667 
],
[
 new Date(2002,9,8),
25.94444444 
],
[
 new Date(2002,9,9),
24.88888889 
],
[
 new Date(2002,9,10),
24.66666667 
],
[
 new Date(2002,9,11),
25 
],
[
 new Date(2002,9,12),
26.11111111 
],
[
 new Date(2002,9,13),
27.05555556 
],
[
 new Date(2002,9,14),
26.66666667 
],
[
 new Date(2002,9,15),
25 
],
[
 new Date(2002,9,16),
22.83333333 
],
[
 new Date(2002,9,17),
24.05555556 
],
[
 new Date(2002,9,18),
24.27777778 
],
[
 new Date(2002,9,19),
24.5 
],
[
 new Date(2002,9,20),
24.05555556 
],
[
 new Date(2002,9,21),
23.88888889 
],
[
 new Date(2002,9,22),
22.66666667 
],
[
 new Date(2002,9,23),
22.88888889 
],
[
 new Date(2002,9,24),
23.55555556 
],
[
 new Date(2002,9,25),
24.05555556 
],
[
 new Date(2002,9,26),
25.22222222 
],
[
 new Date(2002,9,27),
23.44444444 
],
[
 new Date(2002,9,28),
22.44444444 
],
[
 new Date(2002,9,29),
22.11111111 
],
[
 new Date(2002,9,30),
21.83333333 
],
[
 new Date(2002,9,31),
21.66666667 
],
[
 new Date(2002,10,1),
21.44444444 
],
[
 new Date(2002,10,2),
21.61111111 
],
[
 new Date(2002,10,3),
22.33333333 
],
[
 new Date(2002,10,4),
22.61111111 
],
[
 new Date(2002,10,5),
22.27777778 
],
[
 new Date(2002,10,6),
21.55555556 
],
[
 new Date(2002,10,7),
21.44444444 
],
[
 new Date(2002,10,8),
24.22222222 
],
[
 new Date(2002,10,9),
22.5 
],
[
 new Date(2002,10,10),
20.61111111 
],
[
 new Date(2002,10,11),
20.16666667 
],
[
 new Date(2002,10,12),
20.33333333 
],
[
 new Date(2002,10,13),
19.44444444 
],
[
 new Date(2002,10,14),
19.72222222 
],
[
 new Date(2002,10,15),
19.55555556 
],
[
 new Date(2002,10,16),
20.83333333 
],
[
 new Date(2002,10,17),
20.66666667 
],
[
 new Date(2002,10,18),
19.72222222 
],
[
 new Date(2002,10,19),
18.44444444 
],
[
 new Date(2002,10,20),
18.22222222 
],
[
 new Date(2002,10,21),
19.44444444 
],
[
 new Date(2002,10,22),
19.88888889 
],
[
 new Date(2002,10,23),
19.72222222 
],
[
 new Date(2002,10,24),
19.61111111 
],
[
 new Date(2002,10,25),
18.83333333 
],
[
 new Date(2002,10,26),
17.88888889 
],
[
 new Date(2002,10,27),
18.11111111 
],
[
 new Date(2002,10,28),
16.72222222 
],
[
 new Date(2002,10,29),
19.05555556 
],
[
 new Date(2002,10,30),
18.33333333 
],
[
 new Date(2002,11,1),
17.94444444 
],
[
 new Date(2002,11,2),
18.61111111 
],
[
 new Date(2002,11,3),
17.88888889 
],
[
 new Date(2002,11,4),
16.61111111 
],
[
 new Date(2002,11,5),
18.16666667 
],
[
 new Date(2002,11,6),
18.83333333 
],
[
 new Date(2002,11,7),
18.27777778 
],
[
 new Date(2002,11,8),
20.61111111 
],
[
 new Date(2002,11,9),
17.66666667 
],
[
 new Date(2002,11,10),
16.11111111 
],
[
 new Date(2002,11,11),
16.16666667 
],
[
 new Date(2002,11,12),
15.72222222 
],
[
 new Date(2002,11,13),
15.11111111 
],
[
 new Date(2002,11,14),
15.05555556 
],
[
 new Date(2002,11,15),
16.66666667 
],
[
 new Date(2002,11,16),
16.88888889 
],
[
 new Date(2002,11,17),
16.5 
],
[
 new Date(2002,11,18),
16.66666667 
],
[
 new Date(2002,11,19),
17.05555556 
],
[
 new Date(2002,11,20),
13.94444444 
],
[
 new Date(2002,11,21),
11.83333333 
],
[
 new Date(2002,11,22),
12.27777778 
],
[
 new Date(2002,11,23),
13.16666667 
],
[
 new Date(2002,11,24),
14.88888889 
],
[
 new Date(2002,11,25),
15.5 
],
[
 new Date(2002,11,26),
17.27777778 
],
[
 new Date(2002,11,27),
16.38888889 
],
[
 new Date(2002,11,28),
15.5 
],
[
 new Date(2002,11,29),
15.88888889 
],
[
 new Date(2002,11,30),
16.44444444 
],
[
 new Date(2002,11,31),
16.22222222 
],
[
 new Date(2003,0,1),
16.5 
],
[
 new Date(2003,0,2),
16.11111111 
],
[
 new Date(2003,0,3),
16.22222222 
],
[
 new Date(2003,0,4),
17.05555556 
],
[
 new Date(2003,0,5),
17.88888889 
],
[
 new Date(2003,0,6),
19.44444444 
],
[
 new Date(2003,0,7),
18.16666667 
],
[
 new Date(2003,0,8),
17.61111111 
],
[
 new Date(2003,0,9),
16.11111111 
],
[
 new Date(2003,0,10),
16.27777778 
],
[
 new Date(2003,0,11),
16.94444444 
],
[
 new Date(2003,0,12),
20.44444444 
],
[
 new Date(2003,0,13),
16.55555556 
],
[
 new Date(2003,0,14),
16.11111111 
],
[
 new Date(2003,0,15),
14.44444444 
],
[
 new Date(2003,0,16),
14.83333333 
],
[
 new Date(2003,0,17),
14.94444444 
],
[
 new Date(2003,0,18),
15.27777778 
],
[
 new Date(2003,0,19),
14.33333333 
],
[
 new Date(2003,0,20),
15.22222222 
],
[
 new Date(2003,0,21),
15.5 
],
[
 new Date(2003,0,22),
15.83333333 
],
[
 new Date(2003,0,23),
15.66666667 
],
[
 new Date(2003,0,24),
15.94444444 
],
[
 new Date(2003,0,25),
15.77777778 
],
[
 new Date(2003,0,26),
17.27777778 
],
[
 new Date(2003,0,27),
15.55555556 
],
[
 new Date(2003,0,28),
14.61111111 
],
[
 new Date(2003,0,29),
15.38888889 
],
[
 new Date(2003,0,30),
15.61111111 
],
[
 new Date(2003,0,31),
15.72222222 
],
[
 new Date(2003,1,1),
17.66666667 
],
[
 new Date(2003,1,2),
16.61111111 
],
[
 new Date(2003,1,3),
14.22222222 
],
[
 new Date(2003,1,4),
14.16666667 
],
[
 new Date(2003,1,5),
14.22222222 
],
[
 new Date(2003,1,6),
15.27777778 
],
[
 new Date(2003,1,7),
18.55555556 
],
[
 new Date(2003,1,8),
13.66666667 
],
[
 new Date(2003,1,9),
13.27777778 
],
[
 new Date(2003,1,10),
13.05555556 
],
[
 new Date(2003,1,11),
14 
],
[
 new Date(2003,1,12),
15.5 
],
[
 new Date(2003,1,13),
13.83333333 
],
[
 new Date(2003,1,14),
13.83333333 
],
[
 new Date(2003,1,15),
14.05555556 
],
[
 new Date(2003,1,16),
14.88888889 
],
[
 new Date(2003,1,17),
19.72222222 
],
[
 new Date(2003,1,18),
21.5 
],
[
 new Date(2003,1,19),
15.83333333 
],
[
 new Date(2003,1,20),
14.55555556 
],
[
 new Date(2003,1,21),
15.66666667 
],
[
 new Date(2003,1,22),
13.61111111 
],
[
 new Date(2003,1,23),
15.11111111 
],
[
 new Date(2003,1,24),
10.83333333 
],
[
 new Date(2003,1,25),
10.44444444 
],
[
 new Date(2003,1,26),
11.27777778 
],
[
 new Date(2003,1,27),
12.38888889 
],
[
 new Date(2003,1,28),
13.33333333 
],
[
 new Date(2003,2,1),
16.83333333 
],
[
 new Date(2003,2,2),
20.44444444 
],
[
 new Date(2003,2,3),
16.5 
],
[
 new Date(2003,2,4),
16.66666667 
],
[
 new Date(2003,2,5),
18.94444444 
],
[
 new Date(2003,2,6),
15.94444444 
],
[
 new Date(2003,2,7),
15.77777778 
],
[
 new Date(2003,2,8),
15.5 
],
[
 new Date(2003,2,9),
16.22222222 
],
[
 new Date(2003,2,10),
15.72222222 
],
[
 new Date(2003,2,11),
14.11111111 
],
[
 new Date(2003,2,12),
14 
],
[
 new Date(2003,2,13),
15.94444444 
],
[
 new Date(2003,2,14),
18.5 
],
[
 new Date(2003,2,15),
18.16666667 
],
[
 new Date(2003,2,16),
16.61111111 
],
[
 new Date(2003,2,17),
19.38888889 
],
[
 new Date(2003,2,18),
16.05555556 
],
[
 new Date(2003,2,19),
14.88888889 
],
[
 new Date(2003,2,20),
14.72222222 
],
[
 new Date(2003,2,21),
14.38888889 
],
[
 new Date(2003,2,22),
15.16666667 
],
[
 new Date(2003,2,23),
15.44444444 
],
[
 new Date(2003,2,24),
12.11111111 
],
[
 new Date(2003,2,25),
8.777777778 
],
[
 new Date(2003,2,26),
14.16666667 
],
[
 new Date(2003,2,27),
16.38888889 
],
[
 new Date(2003,2,28),
16.16666667 
],
[
 new Date(2003,2,29),
16.05555556 
],
[
 new Date(2003,2,30),
16.72222222 
],
[
 new Date(2003,2,31),
19.55555556 
],
[
 new Date(2003,3,1),
21.38888889 
],
[
 new Date(2003,3,2),
28.33333333 
],
[
 new Date(2003,3,3),
25.05555556 
],
[
 new Date(2003,3,5),
31.55555556 
],
[
 new Date(2003,3,6),
22.11111111 
],
[
 new Date(2003,3,7),
21 
],
[
 new Date(2003,3,8),
20.5 
],
[
 new Date(2003,3,9),
19.27777778 
],
[
 new Date(2003,3,10),
18 
],
[
 new Date(2003,3,11),
18.11111111 
],
[
 new Date(2003,3,12),
19.66666667 
],
[
 new Date(2003,3,13),
19.61111111 
],
[
 new Date(2003,3,14),
20.22222222 
],
[
 new Date(2003,3,15),
18.61111111 
],
[
 new Date(2003,3,16),
19.05555556 
],
[
 new Date(2003,3,17),
23.88888889 
],
[
 new Date(2003,3,18),
26.44444444 
],
[
 new Date(2003,3,19),
21.83333333 
],
[
 new Date(2003,3,20),
18.61111111 
],
[
 new Date(2003,3,21),
17.77777778 
],
[
 new Date(2003,3,22),
18.72222222 
],
[
 new Date(2003,3,23),
26.38888889 
],
[
 new Date(2003,3,24),
31.77777778 
],
[
 new Date(2003,3,25),
23.22222222 
],
[
 new Date(2003,3,26),
18.5 
],
[
 new Date(2003,3,27),
18.22222222 
],
[
 new Date(2003,3,28),
19.27777778 
],
[
 new Date(2003,3,29),
20.16666667 
],
[
 new Date(2003,3,30),
20.05555556 
],
[
 new Date(2003,4,1),
21.05555556 
],
[
 new Date(2003,4,2),
23.27777778 
],
[
 new Date(2003,4,3),
25.11111111 
],
[
 new Date(2003,4,4),
26.05555556 
],
[
 new Date(2003,4,5),
25.77777778 
],
[
 new Date(2003,4,6),
24.38888889 
],
[
 new Date(2003,4,7),
24 
],
[
 new Date(2003,4,8),
25.55555556 
],
[
 new Date(2003,4,9),
25.27777778 
],
[
 new Date(2003,4,10),
24.38888889 
],
[
 new Date(2003,4,11),
24.77777778 
],
[
 new Date(2003,4,12),
26.27777778 
],
[
 new Date(2003,4,13),
27.66666667 
],
[
 new Date(2003,4,14),
28.11111111 
],
[
 new Date(2003,4,15),
31.27777778 
],
[
 new Date(2003,4,16),
29.11111111 
],
[
 new Date(2003,4,17),
26.27777778 
],
[
 new Date(2003,4,18),
27.5 
],
[
 new Date(2003,4,19),
27.83333333 
],
[
 new Date(2003,4,20),
26.44444444 
],
[
 new Date(2003,4,21),
27.44444444 
],
[
 new Date(2003,4,22),
27.66666667 
],
[
 new Date(2003,4,23),
30.11111111 
],
[
 new Date(2003,4,24),
27.66666667 
],
[
 new Date(2003,4,25),
27 
],
[
 new Date(2003,4,26),
26.38888889 
],
[
 new Date(2003,4,27),
25.38888889 
],
[
 new Date(2003,4,28),
30.88888889 
],
[
 new Date(2003,4,29),
34.38888889 
],
[
 new Date(2003,4,30),
27.33333333 
],
[
 new Date(2003,4,31),
26.27777778 
],
[
 new Date(2003,5,1),
25.44444444 
],
[
 new Date(2003,5,2),
26.72222222 
],
[
 new Date(2003,5,3),
26.38888889 
],
[
 new Date(2003,5,4),
25.61111111 
],
[
 new Date(2003,5,5),
27 
],
[
 new Date(2003,5,6),
28.05555556 
],
[
 new Date(2003,5,7),
28.94444444 
],
[
 new Date(2003,5,8),
27.72222222 
],
[
 new Date(2003,5,9),
27.72222222 
],
[
 new Date(2003,5,10),
28 
],
[
 new Date(2003,5,11),
27.27777778 
],
[
 new Date(2003,5,12),
27.83333333 
],
[
 new Date(2003,5,13),
28.05555556 
],
[
 new Date(2003,5,14),
28.66666667 
],
[
 new Date(2003,5,15),
30.44444444 
],
[
 new Date(2003,5,16),
32.5 
],
[
 new Date(2003,5,17),
31.72222222 
],
[
 new Date(2003,5,18),
28.83333333 
],
[
 new Date(2003,5,19),
28.61111111 
],
[
 new Date(2003,5,20),
28.5 
],
[
 new Date(2003,5,21),
29.77777778 
],
[
 new Date(2003,5,22),
29.94444444 
],
[
 new Date(2003,5,23),
28.72222222 
],
[
 new Date(2003,5,24),
28.77777778 
],
[
 new Date(2003,5,25),
29.27777778 
],
[
 new Date(2003,5,26),
29.33333333 
],
[
 new Date(2003,5,27),
28.72222222 
],
[
 new Date(2003,5,28),
29.27777778 
],
[
 new Date(2003,5,29),
28.94444444 
],
[
 new Date(2003,5,30),
29.44444444 
],
[
 new Date(2003,6,1),
29.38888889 
],
[
 new Date(2003,6,2),
29.5 
],
[
 new Date(2003,6,3),
30.83333333 
],
[
 new Date(2003,6,4),
30.94444444 
],
[
 new Date(2003,6,5),
30.05555556 
],
[
 new Date(2003,6,6),
31.77777778 
],
[
 new Date(2003,6,7),
28.88888889 
],
[
 new Date(2003,6,8),
27.77777778 
],
[
 new Date(2003,6,9),
27.22222222 
],
[
 new Date(2003,6,10),
26.77777778 
],
[
 new Date(2003,6,11),
26.88888889 
],
[
 new Date(2003,6,12),
27.22222222 
],
[
 new Date(2003,6,13),
27.72222222 
],
[
 new Date(2003,6,14),
27 
],
[
 new Date(2003,6,15),
27.33333333 
],
[
 new Date(2003,6,16),
27.77777778 
],
[
 new Date(2003,6,17),
28.16666667 
],
[
 new Date(2003,6,18),
29.33333333 
],
[
 new Date(2003,6,19),
30.38888889 
],
[
 new Date(2003,6,20),
30.38888889 
],
[
 new Date(2003,6,21),
28.16666667 
],
[
 new Date(2003,6,22),
27.77777778 
],
[
 new Date(2003,6,23),
28.77777778 
],
[
 new Date(2003,6,24),
28.44444444 
],
[
 new Date(2003,6,25),
28.61111111 
],
[
 new Date(2003,6,26),
29.38888889 
],
[
 new Date(2003,6,27),
28.61111111 
],
[
 new Date(2003,6,28),
28.33333333 
],
[
 new Date(2003,6,29),
28.72222222 
],
[
 new Date(2003,6,30),
28.72222222 
],
[
 new Date(2003,6,31),
29.05555556 
],
[
 new Date(2003,7,1),
29.44444444 
],
[
 new Date(2003,7,2),
30.27777778 
],
[
 new Date(2003,7,3),
30.61111111 
],
[
 new Date(2003,7,4),
29.83333333 
],
[
 new Date(2003,7,5),
28.88888889 
],
[
 new Date(2003,7,6),
29 
],
[
 new Date(2003,7,7),
28.38888889 
],
[
 new Date(2003,7,8),
28.94444444 
],
[
 new Date(2003,7,9),
28.83333333 
],
[
 new Date(2003,7,10),
28.5 
],
[
 new Date(2003,7,11),
27.27777778 
],
[
 new Date(2003,7,12),
27.38888889 
],
[
 new Date(2003,7,13),
28.11111111 
],
[
 new Date(2003,7,14),
27.77777778 
],
[
 new Date(2003,7,15),
27.94444444 
],
[
 new Date(2003,7,16),
28.38888889 
],
[
 new Date(2003,7,17),
29.05555556 
],
[
 new Date(2003,7,18),
29 
],
[
 new Date(2003,7,19),
29.66666667 
],
[
 new Date(2003,7,20),
29.83333333 
],
[
 new Date(2003,7,21),
29.16666667 
],
[
 new Date(2003,7,22),
29.22222222 
],
[
 new Date(2003,7,23),
28.88888889 
],
[
 new Date(2003,7,24),
28.88888889 
],
[
 new Date(2003,7,25),
29.22222222 
],
[
 new Date(2003,7,26),
28.94444444 
],
[
 new Date(2003,7,27),
28.94444444 
],
[
 new Date(2003,7,28),
30.44444444 
],
[
 new Date(2003,7,29),
29.5 
],
[
 new Date(2003,7,30),
29.05555556 
],
[
 new Date(2003,7,31),
29 
],
[
 new Date(2003,8,1),
29.66666667 
],
[
 new Date(2003,8,2),
31.27777778 
],
[
 new Date(2003,8,3),
30.11111111 
],
[
 new Date(2003,8,4),
29.27777778 
],
[
 new Date(2003,8,5),
26.66666667 
],
[
 new Date(2003,8,6),
25 
],
[
 new Date(2003,8,7),
25.33333333 
],
[
 new Date(2003,8,8),
26.27777778 
],
[
 new Date(2003,8,9),
25.44444444 
],
[
 new Date(2003,8,10),
28.83333333 
],
[
 new Date(2003,8,11),
31.66666667 
],
[
 new Date(2003,8,12),
28.22222222 
],
[
 new Date(2003,8,13),
27.27777778 
],
[
 new Date(2003,8,14),
27.05555556 
],
[
 new Date(2003,8,15),
26.77777778 
],
[
 new Date(2003,8,16),
27.27777778 
],
[
 new Date(2003,8,17),
30.44444444 
],
[
 new Date(2003,8,18),
28.05555556 
],
[
 new Date(2003,8,19),
25.72222222 
],
[
 new Date(2003,8,20),
25.66666667 
],
[
 new Date(2003,8,21),
26.05555556 
],
[
 new Date(2003,8,22),
25.44444444 
],
[
 new Date(2003,8,23),
25.83333333 
],
[
 new Date(2003,8,24),
26.22222222 
],
[
 new Date(2003,8,25),
25.11111111 
],
[
 new Date(2003,8,26),
25.05555556 
],
[
 new Date(2003,8,27),
24.88888889 
],
[
 new Date(2003,8,28),
24.16666667 
],
[
 new Date(2003,8,29),
24.22222222 
],
[
 new Date(2003,8,30),
26.11111111 
],
[
 new Date(2003,9,1),
26.11111111 
],
[
 new Date(2003,9,2),
24.88888889 
],
[
 new Date(2003,9,3),
25.05555556 
],
[
 new Date(2003,9,4),
25.27777778 
],
[
 new Date(2003,9,5),
25.38888889 
],
[
 new Date(2003,9,6),
26.16666667 
],
[
 new Date(2003,9,7),
26 
],
[
 new Date(2003,9,8),
25.77777778 
],
[
 new Date(2003,9,9),
26 
],
[
 new Date(2003,9,10),
25.72222222 
],
[
 new Date(2003,9,11),
23.05555556 
],
[
 new Date(2003,9,12),
21.72222222 
],
[
 new Date(2003,9,13),
22.55555556 
],
[
 new Date(2003,9,14),
23 
],
[
 new Date(2003,9,15),
22.55555556 
],
[
 new Date(2003,9,16),
22.55555556 
],
[
 new Date(2003,9,17),
22.66666667 
],
[
 new Date(2003,9,18),
24.11111111 
],
[
 new Date(2003,9,19),
23.55555556 
],
[
 new Date(2003,9,20),
24.5 
],
[
 new Date(2003,9,21),
26 
],
[
 new Date(2003,9,22),
26.61111111 
],
[
 new Date(2003,9,23),
26.5 
],
[
 new Date(2003,9,24),
26.88888889 
],
[
 new Date(2003,9,25),
25.05555556 
],
[
 new Date(2003,9,26),
26.16666667 
],
[
 new Date(2003,9,27),
23.77777778 
],
[
 new Date(2003,9,28),
24.44444444 
],
[
 new Date(2003,9,29),
21.5 
],
[
 new Date(2003,9,30),
20.33333333 
],
[
 new Date(2003,9,31),
24.5 
],
[
 new Date(2003,10,1),
28 
],
[
 new Date(2003,10,2),
25.66666667 
],
[
 new Date(2003,10,3),
24.44444444 
],
[
 new Date(2003,10,4),
24.27777778 
],
[
 new Date(2003,10,5),
22.66666667 
],
[
 new Date(2003,10,6),
23.55555556 
],
[
 new Date(2003,10,7),
23.05555556 
],
[
 new Date(2003,10,8),
21.16666667 
],
[
 new Date(2003,10,9),
20.27777778 
],
[
 new Date(2003,10,10),
18.38888889 
],
[
 new Date(2003,10,11),
17.83333333 
],
[
 new Date(2003,10,12),
17.5 
],
[
 new Date(2003,10,13),
17.77777778 
],
[
 new Date(2003,10,14),
18.61111111 
],
[
 new Date(2003,10,15),
18.83333333 
],
[
 new Date(2003,10,16),
18.88888889 
],
[
 new Date(2003,10,17),
18.83333333 
],
[
 new Date(2003,10,18),
19.22222222 
],
[
 new Date(2003,10,19),
18.77777778 
],
[
 new Date(2003,10,20),
19.22222222 
],
[
 new Date(2003,10,21),
19.11111111 
],
[
 new Date(2003,10,22),
19.66666667 
],
[
 new Date(2003,10,23),
19.72222222 
],
[
 new Date(2003,10,24),
19.27777778 
],
[
 new Date(2003,10,25),
19.27777778 
],
[
 new Date(2003,10,26),
18.61111111 
],
[
 new Date(2003,10,27),
17.77777778 
],
[
 new Date(2003,10,28),
17.5 
],
[
 new Date(2003,10,29),
17.72222222 
],
[
 new Date(2003,10,30),
17.66666667 
],
[
 new Date(2003,11,1),
17.72222222 
],
[
 new Date(2003,11,2),
17.11111111 
],
[
 new Date(2003,11,3),
17.11111111 
],
[
 new Date(2003,11,4),
15.27777778 
],
[
 new Date(2003,11,5),
15.77777778 
],
[
 new Date(2003,11,6),
16.22222222 
],
[
 new Date(2003,11,7),
16.38888889 
],
[
 new Date(2003,11,8),
16.44444444 
],
[
 new Date(2003,11,9),
18.33333333 
],
[
 new Date(2003,11,10),
16.94444444 
],
[
 new Date(2003,11,11),
17.44444444 
],
[
 new Date(2003,11,12),
18.11111111 
],
[
 new Date(2003,11,13),
18.38888889 
],
[
 new Date(2003,11,14),
18.88888889 
],
[
 new Date(2003,11,15),
18.61111111 
],
[
 new Date(2003,11,16),
18 
],
[
 new Date(2003,11,17),
17.38888889 
],
[
 new Date(2003,11,18),
12.5 
],
[
 new Date(2003,11,19),
12.88888889 
],
[
 new Date(2003,11,20),
12.77777778 
],
[
 new Date(2003,11,21),
12.5 
],
[
 new Date(2003,11,22),
12.38888889 
],
[
 new Date(2003,11,23),
13.33333333 
],
[
 new Date(2003,11,24),
12.72222222 
],
[
 new Date(2003,11,25),
13.38888889 
],
[
 new Date(2003,11,26),
12 
],
[
 new Date(2003,11,27),
11.94444444 
],
[
 new Date(2003,11,28),
13.72222222 
],
[
 new Date(2003,11,29),
13.88888889 
],
[
 new Date(2003,11,30),
13.27777778 
],
[
 new Date(2003,11,31),
13.88888889 
],
[
 new Date(2004,0,1),
14.94444444 
],
[
 new Date(2004,0,2),
15.94444444 
],
[
 new Date(2004,0,3),
13.83333333 
],
[
 new Date(2004,0,4),
15.94444444 
],
[
 new Date(2004,0,5),
15.77777778 
],
[
 new Date(2004,0,6),
14.66666667 
],
[
 new Date(2004,0,7),
13.27777778 
],
[
 new Date(2004,0,8),
11.77777778 
],
[
 new Date(2004,0,9),
13.22222222 
],
[
 new Date(2004,0,10),
13.83333333 
],
[
 new Date(2004,0,11),
15.72222222 
],
[
 new Date(2004,0,12),
12.16666667 
],
[
 new Date(2004,0,13),
14.05555556 
],
[
 new Date(2004,0,14),
15 
],
[
 new Date(2004,0,15),
16.72222222 
],
[
 new Date(2004,0,16),
17 
],
[
 new Date(2004,0,17),
15.38888889 
],
[
 new Date(2004,0,18),
13.94444444 
],
[
 new Date(2004,0,19),
13.38888889 
],
[
 new Date(2004,0,20),
15 
],
[
 new Date(2004,0,21),
16.94444444 
],
[
 new Date(2004,0,22),
17.44444444 
],
[
 new Date(2004,0,23),
12.61111111 
],
[
 new Date(2004,0,24),
12.05555556 
],
[
 new Date(2004,0,25),
14.22222222 
],
[
 new Date(2004,0,26),
12.72222222 
],
[
 new Date(2004,0,27),
14.55555556 
],
[
 new Date(2004,0,28),
14.33333333 
],
[
 new Date(2004,0,29),
16 
],
[
 new Date(2004,0,30),
17.16666667 
],
[
 new Date(2004,0,31),
14.55555556 
],
[
 new Date(2004,1,1),
13.61111111 
],
[
 new Date(2004,1,2),
14.05555556 
],
[
 new Date(2004,1,3),
13.66666667 
],
[
 new Date(2004,1,4),
12.38888889 
],
[
 new Date(2004,1,5),
13 
],
[
 new Date(2004,1,6),
13.72222222 
],
[
 new Date(2004,1,7),
15.16666667 
],
[
 new Date(2004,1,8),
15.88888889 
],
[
 new Date(2004,1,9),
15.05555556 
],
[
 new Date(2004,1,10),
15.44444444 
],
[
 new Date(2004,1,11),
14.77777778 
],
[
 new Date(2004,1,12),
16.38888889 
],
[
 new Date(2004,1,13),
15.94444444 
],
[
 new Date(2004,1,14),
10.05555556 
],
[
 new Date(2004,1,15),
11.5 
],
[
 new Date(2004,1,16),
13.94444444 
],
[
 new Date(2004,1,17),
15.16666667 
],
[
 new Date(2004,1,18),
15.61111111 
],
[
 new Date(2004,1,19),
13.16666667 
],
[
 new Date(2004,1,20),
13.33333333 
],
[
 new Date(2004,1,21),
14.33333333 
],
[
 new Date(2004,1,22),
13.05555556 
],
[
 new Date(2004,1,23),
14.16666667 
],
[
 new Date(2004,1,24),
20.83333333 
],
[
 new Date(2004,1,25),
19.38888889 
],
[
 new Date(2004,1,26),
21 
],
[
 new Date(2004,1,27),
22.66666667 
],
[
 new Date(2004,1,28),
24.88888889 
],
[
 new Date(2004,1,29),
26.44444444 
],
[
 new Date(2004,2,1),
21.22222222 
],
[
 new Date(2004,2,2),
20.61111111 
],
[
 new Date(2004,2,3),
25.38888889 
],
[
 new Date(2004,2,4),
31.44444444 
],
[
 new Date(2004,2,5),
20.77777778 
],
[
 new Date(2004,2,6),
15.88888889 
],
[
 new Date(2004,2,7),
13.22222222 
],
[
 new Date(2004,2,8),
13.27777778 
],
[
 new Date(2004,2,9),
14.61111111 
],
[
 new Date(2004,2,10),
17.88888889 
],
[
 new Date(2004,2,11),
18.05555556 
],
[
 new Date(2004,2,12),
16.83333333 
],
[
 new Date(2004,2,13),
16.16666667 
],
[
 new Date(2004,2,14),
15.55555556 
],
[
 new Date(2004,2,15),
15.05555556 
],
[
 new Date(2004,2,16),
14.83333333 
],
[
 new Date(2004,2,17),
15 
],
[
 new Date(2004,2,18),
16 
],
[
 new Date(2004,2,19),
16.61111111 
],
[
 new Date(2004,2,20),
16.33333333 
],
[
 new Date(2004,2,21),
16.55555556 
],
[
 new Date(2004,2,22),
18 
],
[
 new Date(2004,2,23),
19.05555556 
],
[
 new Date(2004,2,24),
19 
],
[
 new Date(2004,2,25),
18.94444444 
],
[
 new Date(2004,2,26),
17.61111111 
],
[
 new Date(2004,2,27),
18.11111111 
],
[
 new Date(2004,2,28),
20.33333333 
],
[
 new Date(2004,2,29),
23.77777778 
],
[
 new Date(2004,2,30),
23.66666667 
],
[
 new Date(2004,2,31),
23.05555556 
],
[
 new Date(2004,3,1),
27.33333333 
],
[
 new Date(2004,3,2),
21.72222222 
],
[
 new Date(2004,3,3),
18.11111111 
],
[
 new Date(2004,3,4),
18.44444444 
],
[
 new Date(2004,3,5),
17.77777778 
],
[
 new Date(2004,3,6),
16.77777778 
],
[
 new Date(2004,3,7),
17.22222222 
],
[
 new Date(2004,3,8),
17.61111111 
],
[
 new Date(2004,3,9),
18 
],
[
 new Date(2004,3,10),
19.94444444 
],
[
 new Date(2004,3,11),
22.27777778 
],
[
 new Date(2004,3,12),
23.27777778 
],
[
 new Date(2004,3,13),
24.44444444 
],
[
 new Date(2004,3,14),
25.05555556 
],
[
 new Date(2004,3,15),
20.61111111 
],
[
 new Date(2004,3,16),
18.16666667 
],
[
 new Date(2004,3,17),
19.94444444 
],
[
 new Date(2004,3,18),
25.05555556 
],
[
 new Date(2004,3,19),
22.05555556 
],
[
 new Date(2004,3,20),
25.11111111 
],
[
 new Date(2004,3,21),
21.61111111 
],
[
 new Date(2004,3,22),
20.55555556 
],
[
 new Date(2004,3,23),
19.22222222 
],
[
 new Date(2004,3,24),
19.94444444 
],
[
 new Date(2004,3,25),
21.88888889 
],
[
 new Date(2004,3,26),
25.88888889 
],
[
 new Date(2004,3,27),
25.66666667 
],
[
 new Date(2004,3,28),
26 
],
[
 new Date(2004,3,29),
21.22222222 
],
[
 new Date(2004,3,30),
21.38888889 
],
[
 new Date(2004,4,1),
24.38888889 
],
[
 new Date(2004,4,2),
23.83333333 
],
[
 new Date(2004,4,3),
21.66666667 
],
[
 new Date(2004,4,4),
22.05555556 
],
[
 new Date(2004,4,5),
26 
],
[
 new Date(2004,4,6),
30.83333333 
],
[
 new Date(2004,4,7),
27.55555556 
],
[
 new Date(2004,4,8),
27.11111111 
],
[
 new Date(2004,4,9),
30.33333333 
],
[
 new Date(2004,4,10),
30.38888889 
],
[
 new Date(2004,4,11),
23.27777778 
],
[
 new Date(2004,4,12),
22.33333333 
],
[
 new Date(2004,4,13),
26.61111111 
],
[
 new Date(2004,4,14),
29.16666667 
],
[
 new Date(2004,4,15),
22.55555556 
],
[
 new Date(2004,4,16),
22.27777778 
],
[
 new Date(2004,4,17),
24.5 
],
[
 new Date(2004,4,18),
26.77777778 
],
[
 new Date(2004,4,19),
26.11111111 
],
[
 new Date(2004,4,20),
22.38888889 
],
[
 new Date(2004,4,21),
22 
],
[
 new Date(2004,4,22),
23.11111111 
],
[
 new Date(2004,4,23),
22.83333333 
],
[
 new Date(2004,4,24),
23.44444444 
],
[
 new Date(2004,4,25),
24.22222222 
],
[
 new Date(2004,4,26),
24.94444444 
],
[
 new Date(2004,4,27),
26.72222222 
],
[
 new Date(2004,4,28),
25.33333333 
],
[
 new Date(2004,4,29),
28.5 
],
[
 new Date(2004,4,30),
30.11111111 
],
[
 new Date(2004,4,31),
24.77777778 
],
[
 new Date(2004,5,1),
23.5 
],
[
 new Date(2004,5,2),
23.72222222 
],
[
 new Date(2004,5,3),
24.05555556 
],
[
 new Date(2004,5,4),
24.66666667 
],
[
 new Date(2004,5,5),
25.55555556 
],
[
 new Date(2004,5,6),
28.55555556 
],
[
 new Date(2004,5,7),
31.27777778 
],
[
 new Date(2004,5,8),
26.72222222 
],
[
 new Date(2004,5,9),
24.61111111 
],
[
 new Date(2004,5,10),
25.05555556 
],
[
 new Date(2004,5,11),
26.33333333 
],
[
 new Date(2004,5,12),
27.27777778 
],
[
 new Date(2004,5,13),
27.72222222 
],
[
 new Date(2004,5,14),
27.5 
],
[
 new Date(2004,5,15),
28.72222222 
],
[
 new Date(2004,5,16),
28.27777778 
],
[
 new Date(2004,5,17),
28.5 
],
[
 new Date(2004,5,18),
30.55555556 
],
[
 new Date(2004,5,19),
32.05555556 
],
[
 new Date(2004,5,20),
27.05555556 
],
[
 new Date(2004,5,21),
27.05555556 
],
[
 new Date(2004,5,22),
27.38888889 
],
[
 new Date(2004,5,23),
27.66666667 
],
[
 new Date(2004,5,24),
27.22222222 
],
[
 new Date(2004,5,25),
26.66666667 
],
[
 new Date(2004,5,26),
27.5 
],
[
 new Date(2004,5,27),
28.38888889 
],
[
 new Date(2004,5,28),
28 
],
[
 new Date(2004,5,29),
28 
],
[
 new Date(2004,5,30),
29.22222222 
],
[
 new Date(2004,6,1),
29.11111111 
],
[
 new Date(2004,6,2),
27.16666667 
],
[
 new Date(2004,6,3),
27.5 
],
[
 new Date(2004,6,4),
28.11111111 
],
[
 new Date(2004,6,5),
29.5 
],
[
 new Date(2004,6,6),
29.88888889 
],
[
 new Date(2004,6,7),
29.55555556 
],
[
 new Date(2004,6,8),
28.77777778 
],
[
 new Date(2004,6,9),
28.61111111 
],
[
 new Date(2004,6,10),
29.5 
],
[
 new Date(2004,6,11),
29.44444444 
],
[
 new Date(2004,6,12),
30.11111111 
],
[
 new Date(2004,6,13),
31.38888889 
],
[
 new Date(2004,6,14),
33.27777778 
],
[
 new Date(2004,6,15),
30.44444444 
],
[
 new Date(2004,6,16),
28.55555556 
],
[
 new Date(2004,6,17),
27.05555556 
],
[
 new Date(2004,6,18),
26.94444444 
],
[
 new Date(2004,6,19),
27.66666667 
],
[
 new Date(2004,6,20),
27.27777778 
],
[
 new Date(2004,6,21),
27.44444444 
],
[
 new Date(2004,6,22),
28.16666667 
],
[
 new Date(2004,6,23),
28.44444444 
],
[
 new Date(2004,6,24),
28.66666667 
],
[
 new Date(2004,6,25),
29.22222222 
],
[
 new Date(2004,6,26),
30.5 
],
[
 new Date(2004,6,27),
30.83333333 
],
[
 new Date(2004,6,28),
30.61111111 
],
[
 new Date(2004,6,29),
31.33333333 
],
[
 new Date(2004,6,30),
31.11111111 
],
[
 new Date(2004,6,31),
29.05555556 
],
[
 new Date(2004,7,1),
27.61111111 
],
[
 new Date(2004,7,2),
27.44444444 
],
[
 new Date(2004,7,3),
28.11111111 
],
[
 new Date(2004,7,4),
28.33333333 
],
[
 new Date(2004,7,5),
28.22222222 
],
[
 new Date(2004,7,6),
29.22222222 
],
[
 new Date(2004,7,7),
29.22222222 
],
[
 new Date(2004,7,8),
30.94444444 
],
[
 new Date(2004,7,9),
29.94444444 
],
[
 new Date(2004,7,10),
28.66666667 
],
[
 new Date(2004,7,11),
29.55555556 
],
[
 new Date(2004,7,12),
28.22222222 
],
[
 new Date(2004,7,13),
28.72222222 
],
[
 new Date(2004,7,14),
29.22222222 
],
[
 new Date(2004,7,15),
29.66666667 
],
[
 new Date(2004,7,16),
30.94444444 
],
[
 new Date(2004,7,17),
30.22222222 
],
[
 new Date(2004,7,18),
27.94444444 
],
[
 new Date(2004,7,19),
26.83333333 
],
[
 new Date(2004,7,20),
27.5 
],
[
 new Date(2004,7,21),
29.22222222 
],
[
 new Date(2004,7,22),
29.94444444 
],
[
 new Date(2004,7,23),
29.44444444 
],
[
 new Date(2004,7,24),
28.88888889 
],
[
 new Date(2004,7,25),
28.05555556 
],
[
 new Date(2004,7,26),
27.33333333 
],
[
 new Date(2004,7,27),
28.05555556 
],
[
 new Date(2004,7,28),
29.77777778 
],
[
 new Date(2004,7,29),
28 
],
[
 new Date(2004,7,30),
26.61111111 
],
[
 new Date(2004,7,31),
26.83333333 
],
[
 new Date(2004,8,1),
26.94444444 
],
[
 new Date(2004,8,2),
27.94444444 
],
[
 new Date(2004,8,3),
27.77777778 
],
[
 new Date(2004,8,4),
28 
],
[
 new Date(2004,8,5),
28.61111111 
],
[
 new Date(2004,8,6),
28.55555556 
],
[
 new Date(2004,8,7),
28.44444444 
],
[
 new Date(2004,8,8),
27.83333333 
],
[
 new Date(2004,8,9),
26.22222222 
],
[
 new Date(2004,8,10),
25.61111111 
],
[
 new Date(2004,8,11),
25 
],
[
 new Date(2004,8,12),
24.44444444 
],
[
 new Date(2004,8,13),
24.83333333 
],
[
 new Date(2004,8,14),
24.66666667 
],
[
 new Date(2004,8,15),
24.61111111 
],
[
 new Date(2004,8,16),
24.33333333 
],
[
 new Date(2004,8,17),
25.38888889 
],
[
 new Date(2004,8,18),
25.61111111 
],
[
 new Date(2004,8,19),
26.38888889 
],
[
 new Date(2004,8,20),
27.61111111 
],
[
 new Date(2004,8,21),
26.61111111 
],
[
 new Date(2004,8,22),
26.22222222 
],
[
 new Date(2004,8,23),
26.27777778 
],
[
 new Date(2004,8,24),
25.61111111 
],
[
 new Date(2004,8,25),
27.11111111 
],
[
 new Date(2004,8,26),
28.83333333 
],
[
 new Date(2004,8,27),
27.61111111 
],
[
 new Date(2004,8,28),
28.05555556 
],
[
 new Date(2004,8,29),
28.77777778 
],
[
 new Date(2004,8,30),
28.88888889 
],
[
 new Date(2004,9,1),
27.66666667 
],
[
 new Date(2004,9,2),
26.44444444 
],
[
 new Date(2004,9,3),
25.27777778 
],
[
 new Date(2004,9,4),
25.22222222 
],
[
 new Date(2004,9,5),
24.77777778 
],
[
 new Date(2004,9,6),
24.44444444 
],
[
 new Date(2004,9,7),
24 
],
[
 new Date(2004,9,8),
23.55555556 
],
[
 new Date(2004,9,9),
23.16666667 
],
[
 new Date(2004,9,10),
23.11111111 
],
[
 new Date(2004,9,11),
22.94444444 
],
[
 new Date(2004,9,12),
23.44444444 
],
[
 new Date(2004,9,13),
23.83333333 
],
[
 new Date(2004,9,14),
23.77777778 
],
[
 new Date(2004,9,15),
24.11111111 
],
[
 new Date(2004,9,16),
24.88888889 
],
[
 new Date(2004,9,17),
25.55555556 
],
[
 new Date(2004,9,18),
26.22222222 
],
[
 new Date(2004,9,19),
26.55555556 
],
[
 new Date(2004,9,20),
25.44444444 
],
[
 new Date(2004,9,21),
25.44444444 
],
[
 new Date(2004,9,22),
25.38888889 
],
[
 new Date(2004,9,23),
25.27777778 
],
[
 new Date(2004,9,24),
24.5 
],
[
 new Date(2004,9,25),
25.11111111 
],
[
 new Date(2004,9,26),
25.27777778 
],
[
 new Date(2004,9,27),
24.27777778 
],
[
 new Date(2004,9,28),
23.61111111 
],
[
 new Date(2004,9,29),
23.55555556 
],
[
 new Date(2004,9,30),
25.5 
],
[
 new Date(2004,9,31),
24.05555556 
],
[
 new Date(2004,10,1),
23.83333333 
],
[
 new Date(2004,10,2),
24.55555556 
],
[
 new Date(2004,10,3),
25.11111111 
],
[
 new Date(2004,10,4),
24.55555556 
],
[
 new Date(2004,10,5),
24.55555556 
],
[
 new Date(2004,10,6),
24.33333333 
],
[
 new Date(2004,10,7),
23 
],
[
 new Date(2004,10,8),
24.38888889 
],
[
 new Date(2004,10,9),
24.38888889 
],
[
 new Date(2004,10,10),
24.33333333 
],
[
 new Date(2004,10,11),
24.05555556 
],
[
 new Date(2004,10,12),
23.33333333 
],
[
 new Date(2004,10,13),
22.11111111 
],
[
 new Date(2004,10,14),
22.11111111 
],
[
 new Date(2004,10,15),
24.61111111 
],
[
 new Date(2004,10,16),
23.33333333 
],
[
 new Date(2004,10,17),
21.16666667 
],
[
 new Date(2004,10,18),
19.27777778 
],
[
 new Date(2004,10,19),
18.61111111 
],
[
 new Date(2004,10,20),
19 
],
[
 new Date(2004,10,21),
19.94444444 
],
[
 new Date(2004,10,22),
15.27777778 
],
[
 new Date(2004,10,23),
13.33333333 
],
[
 new Date(2004,10,24),
15.05555556 
],
[
 new Date(2004,10,25),
17 
],
[
 new Date(2004,10,26),
14.66666667 
],
[
 new Date(2004,10,27),
13.94444444 
],
[
 new Date(2004,10,28),
14.72222222 
],
[
 new Date(2004,10,29),
16 
],
[
 new Date(2004,10,30),
16.11111111 
],
[
 new Date(2004,11,1),
16.11111111 
],
[
 new Date(2004,11,2),
16.38888889 
],
[
 new Date(2004,11,3),
16.44444444 
],
[
 new Date(2004,11,4),
15.72222222 
],
[
 new Date(2004,11,5),
16.05555556 
],
[
 new Date(2004,11,6),
16.83333333 
],
[
 new Date(2004,11,7),
17.11111111 
],
[
 new Date(2004,11,8),
17 
],
[
 new Date(2004,11,9),
15.38888889 
],
[
 new Date(2004,11,10),
15.33333333 
],
[
 new Date(2004,11,11),
16 
],
[
 new Date(2004,11,12),
15.66666667 
],
[
 new Date(2004,11,13),
14.94444444 
],
[
 new Date(2004,11,14),
14.44444444 
],
[
 new Date(2004,11,15),
14.88888889 
],
[
 new Date(2004,11,16),
13.61111111 
],
[
 new Date(2004,11,17),
12.11111111 
],
[
 new Date(2004,11,18),
12.38888889 
],
[
 new Date(2004,11,19),
15.38888889 
],
[
 new Date(2004,11,20),
15.33333333 
],
[
 new Date(2004,11,21),
15.27777778 
],
[
 new Date(2004,11,22),
14.83333333 
],
[
 new Date(2004,11,23),
15.22222222 
],
[
 new Date(2004,11,24),
15 
],
[
 new Date(2004,11,25),
13.27777778 
],
[
 new Date(2004,11,26),
14.22222222 
],
[
 new Date(2004,11,27),
14.27777778 
],
[
 new Date(2004,11,28),
14.55555556 
],
[
 new Date(2004,11,29),
16.16666667 
],
[
 new Date(2004,11,30),
16.83333333 
],
[
 new Date(2004,11,31),
18.33333333 
] 
];
data.addColumn('date','Date');
data.addColumn('number','Temp');
data.addRows(datajson);
return(data);
}
 
// jsDrawChart
function drawChartCalendarIDc6ae7d5a3ab8() {
var data = gvisDataCalendarIDc6ae7d5a3ab8();
var options = {};
options["width"] =    600;
options["height"] =    500;
options["calendar"] = { cellSize: 10 };

    var chart = new google.visualization.Calendar(
    document.getElementById('CalendarIDc6ae7d5a3ab8')
    );
    chart.draw(data,options);
    

}
  
 
// jsDisplayChart
(function() {
var pkgs = window.__gvisPackages = window.__gvisPackages || [];
var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
var chartid = "calendar";
  
// Manually see if chartid is in pkgs (not all browsers support Array.indexOf)
var i, newPackage = true;
for (i = 0; newPackage && i < pkgs.length; i++) {
if (pkgs[i] === chartid)
newPackage = false;
}
if (newPackage)
  pkgs.push(chartid);
  
// Add the drawChart function to the global list of callbacks
callbacks.push(drawChartCalendarIDc6ae7d5a3ab8);
})();
function displayChartCalendarIDc6ae7d5a3ab8() {
  var pkgs = window.__gvisPackages = window.__gvisPackages || [];
  var callbacks = window.__gvisCallbacks = window.__gvisCallbacks || [];
  window.clearTimeout(window.__gvisLoad);
  // The timeout is set to 100 because otherwise the container div we are
  // targeting might not be part of the document yet
  window.__gvisLoad = setTimeout(function() {
  var pkgCount = pkgs.length;
  google.load("visualization", "1", { packages:pkgs, callback: function() {
  if (pkgCount != pkgs.length) {
  // Race condition where another setTimeout call snuck in after us; if
  // that call added a package, we must not shift its callback
  return;
}
while (callbacks.length > 0)
callbacks.shift()();
} });
}, 100);
}
 
// jsFooter
</script>
 
<!-- jsChart -->  
<script type="text/javascript" src="https://www.google.com/jsapi?callback=displayChartCalendarIDc6ae7d5a3ab8"></script>
 
<!-- divChart -->
  
<div id="CalendarIDc6ae7d5a3ab8"
  style="width: 600px; height: 500px;">
</div>


--- x:-5400 y:2200 scale:2

# *qtlcharts*

#### By: Karl Broman

<iframe src='assets/fig/qtlcharts.html' scrolling='no' seamless class='rChart polycharts 'id=iframe-qtlcharts></iframe>


--- x:-3200 y:3000 scale:2

# **ggvis**

### *... implements a interactive grammar of graphics, taking the best parts of ggplot2, combining them with shiny's reactive framework and drawing web graphics using vega.*

#### By: RStudio, Inc.

<br>

![](https://dl.dropboxusercontent.com/u/2904328/ggvis.png)

--- x:0 y:-2900 rot:70 z:-100 rotx:-40 roty:-10 scale:3

# **Thank you!**
