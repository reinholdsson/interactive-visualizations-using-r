## Stockholm R useR group (SRUG)

May 5, 2014

http://reinholdsson.github.io/interactive-visualizations-using-r

**Required packages:**

```{r}
install.packages(c("shiny", "base64enc", "googleVis", "lubridate", "RColorBrewer", "qtl", "RJSONIO", "devtools", "XML", "knitr"))
install_github("kbroman/qtlcharts")
install_github("ramnathv/slidify@dev")
install_github("ramnathv/slidifyLibraries@dev")
install_github("ramnathv/rCharts@dev")
install_github("ramnathv/rMaps")
```

**Run locally:**

```{r}
library(knitr)
library(slidify)
runDeck(".")   # where the path is the presentation's root folder
```
