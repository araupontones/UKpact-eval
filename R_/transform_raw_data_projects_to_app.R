#format raw data for efficient analysis
#exports data to dashboard

library(dplyr)
library(tidyr)
library(stringr)
exfile <- "data/app/projects.rds"
raw_data <- rio::import("C:/repositaries/1.work/pact/kpis/data_report/themes_by_compoment_long.xlsx")
world <- rio::import("data/shapefile/worldSF.rds") %>% sf::st_as_sf()




#clean it ---------------------------------------------------------------------

clean_data <- raw_data %>%
pivot_longer(starts_with("Component"),
             names_to = "Component") %>%
  filter(value == 1) %>%
  rename(IP = Implementor) %>%
  relocate(Project, IP, Component) %>%
  select(-value) %>%
  #remove Component from components to make it nicer in the dash
  mutate(Component = str_remove(Component, "Component [0-9]: "),
         Component = str_to_title(Component),
         Component = case_when(Component %in% c("Skills Shares","Secondments") ~
                                 "Skills Shares & Secondments",
                               T ~ Component)
         ) %>%
  left_join(world)





#export -----------------------------------------------------------------------
rio::export(clean_data, exfile)
