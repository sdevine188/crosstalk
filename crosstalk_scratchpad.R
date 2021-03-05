library(tidyverse)
library(crosstalk)
library(plotly)
library(DT)

# https://rstudio.github.io/crosstalk/using.html
# https://emilyriederer.github.io/demo-crosstalk/tutorial/tutorial-rmd.html
# https://www.htmlwidgets.org/
# https://rmarkdown.rstudio.com/flexdashboard/
# https://plotly.com/r/
# https://plotly-r.com/improving-ggplotly.html
# https://rstudio.github.io/DT/
# https://rstudio.github.io/DT/010-style.html

# create SharedData object to link htmlwidgets via crosstalk
starwars_ct <- starwars %>% select(name, homeworld, sex, height, mass, skin_color, eye_color, species) %>% 
        SharedData$new(key = ~name)
starwars_ct
str(starwars_ct)

# create ggplot
starwars_ggplot <- starwars_ct %>% ggplot(data = ., mapping = aes(x = height, y = mass)) + geom_point()
starwars_ggplot

# convert ggplot into interactive plotly
starwars_ggplotly <- starwars_ggplot %>% ggplotly()
starwars_ggplotly

# create datatable
starwars_datatable <- starwars_ct %>% datatable(filter = "top", 
                          options = list(pageLength = 5, autoWidth = TRUE,
                                         columnDefs = list(list(targets = 8, visible = FALSE)))) %>%
        formatStyle(table = ., columns = 1:8, target = "row", lineHeight = "30%") %>%
        formatStyle(table = ., columns = 1, target = "cell", color = "", 
                    backgroundColor = "#00cc66", fontWeight = "bold", 
                    fontSize = "6px") %>%
        formatStyle(table = ., columns = c("homeworld", "mass"), target = "cell", color = "", 
                    backgroundColor = "#ff9900", fontWeight = "italic", 
                    fontSize = "15px") %>%
        formatStyle(table = ., columns = "sex", valueColumns = "species", target = "cell", 
                    backgroundColor = styleEqual(levels = c("Human", "Droid"), values = c("#00ccff", "#cccc00")))
starwars_datatable 

# create crosstalk plot
bscols(starwars_ggplotly, starwars_datatable,
       options=list(deferRender=TRUE, scrollY=300, scroller=TRUE))



