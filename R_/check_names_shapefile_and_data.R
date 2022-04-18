# Confirm that data and shapefile matches
#if matches, save the shapefile in the data dir

library(dplyr)

exfile <- "data/shapefile/worldSF.rds"

raw_shape <- rio::import("C:/repositaries/shapefiles/clean/worldSF.rds")
raw_data <- rio::import("data/reference/themes_by_compoment_long.xlsx")



check_countries <- raw_data %>%
  group_by(Country) %>%
  slice(1) %>%
  ungroup() %>%
  select(Country) %>%
  left_join(select(raw_shape, c(Country, iso2)), by = "Country")

View(raw_shape)
#all countries match with the data!!!


#save shapefiles

shape_sf <- sf::st_as_sf(raw_shape)


rio::export(shape_sf, exfile)
