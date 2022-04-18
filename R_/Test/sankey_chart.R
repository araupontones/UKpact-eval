library(networkD3)
library(dplyr)

#load data
app_data <- rio::import("data/app/projects.rds")

countries <- unique(app_data$Country)

#format data
links <- app_data %>%
  group_by(Country,Component, Theme) %>%
  summarise(value = n()) %>%
  filter(Country == countries[[5]]) %>%
  mutate(Theme2 = glue::glue('<img src="www/icons/{Theme}.svg">')) %>%
  rename(source = Component, 
         target = Theme)
  
  



nodes <- data.frame(
  name=c(as.character(links$source), 
         as.character(links$target)) %>% unique()
)

# With networkD3, connection must be provided using id, not using real name like in the links dataframe.. So we need to reformat it.
links$IDsource <- match(links$source, nodes$name)-1 
links$IDtarget <- match(links$target, nodes$name)-1


p <- sankeyNetwork(Links = links, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "value", NodeID = "name", 
                   sinksRight=FALSE)

p
?sankeyNetwork
