#format raw data for efficient analysis
#exports data to dashboard

library(dplyr)
library(tidyr)
library(stringr)
exfile <- "data/app/projects.rds"
raw_data <- rio::import("data/reference/themes_by_compoment_long.xlsx")

#clean it ---------------------------------------------------------------------
names(raw_data)
clean_data <- raw_data %>%
pivot_longer(starts_with("Component"),
             names_to = "Component") %>%
  filter(value == 1) %>%
  rename(IP = Implementor) %>%
  relocate(Project, IP, Component) %>%
  select(-value) %>%
  #remove Component from components to make it nicer in the dash
  mutate(Component = str_remove(Component, "Component [0-9]: "),
         Component = str_to_title(Component))





#export -----------------------------------------------------------------------
rio::export(clean_data, exfile)
