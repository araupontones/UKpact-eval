#create grouped data for app
# so users can display aggregations by theme and component in the map
library(dplyr)

exfile <- "data/app/projects_by_country.rds"
exfile_components <- "data/app/components_by_country.rds"
app_data <- rio::import("data/app/projects.rds")
world <- rio::import("data/shapefile/worldSF.rds") %>% sf::st_as_sf()

View(app_data)
#group data -------------------------------------------------------------------
projects_country <- app_data %>%
  group_by(Country) %>%
  summarise(projects = n(),
            components = length(unique(Component)),
            themes = length(unique(Theme)),
            .groups = 'drop'
  ) %>%
           
  filter(Country != "Multi-country") 




#save --------------------------------------------------------------------------
rio::export(projects_country, exfile)


