#create grouped data for app
# so users can display aggregations by theme and component in the map
library(dplyr)

exfile <- "data/app/projects_group.rds"
app_data <- rio::import("data/app/projects.rds")


#group data -------------------------------------------------------------------
group_data <- app_data %>%
  group_by(Country, Theme, Component) %>%
  summarise(projects = n(), .groups = 'drop')


#save --------------------------------------------------------------------------
rio::export(group_data, exfile)


