# Instructions

OBS:
- Make sure to have an empty "assets" folder.

```{r}
# Run with Shiny in background
library(slidify)
runDeck(".")   # where the path is the presentation's root folder

# RStudio viewer
library(slidify)
slidify("index.Rmd")
view_deck()
```
