library(shiny)
library(leaflet)
library(shiny)
library(dplyr)
library(reactable)
library(networkD3)
library(timevis)


#load data
#Creted in R_/transform_raw_data_projects_to_app.R
app_data <- rio::import("data/app/projects.rds")
bens_data <- rio::import("data/reference/beneficiaries_synergies.xlsx")
#sum_data <- rio::import("data/app/projects_group.rds")
world <- rio::import("data/shapefile/worldSF.rds") %>% sf::st_as_sf()

#Created in R_/count_projects_country
projects_country <- rio::import("data/app/projects_by_country.rds") %>% sf::st_as_sf()

#create vectors for selectors
v_components <- sort(unique(app_data$Component))
v_themes <- sort(unique(app_data$Theme))


ui <- fluidPage(
  
  uiLinks("links"),
  tags$div(class = "container-logo",
    
    tags$img(src = "logos/ukpact.svg", class = "pact-logo"),
    tags$h1(class = "text-logo", " - Evaluation")
  
  ),
  
  fluidRow(
    shinycssloaders::withSpinner(uiMap('map'), color = red_pact)
    
  
 
  
)
)

server <- function(input, output, session) {
  
#reactive data for map -------------------------------------------------------
#returns data used for the map   (all countries that meet the attributes)
   #data_map <- data_map_server("sideBar", sum_data, world)
   
 
#reactive map ------------------------------------------------------------------
#returns selected country in the map

   country <- serverMap("map", projects_map = projects_country, world, 
                        palette_map = blue_palette, app_data)
   
   #returns flag, projects, components, themes by country
   country_info <- serverHeadCountry("head_country",projects_map = projects_country ,country)
   
   #data of beneficiaries supported same theme, 2 components
   bens <- serverDatabens('map', country, bens_data)
   
   #sankey chart by theme
   sankey <- serverSankey("map", country, app_data) 
   
   timevis <- serverTimeVis("map", country, app_data)
   
#summary of country as a dialig
   serverDialog('map', country, country_info, sankey, bens, timevis)
   

    
 
 
 
}

shinyApp(ui, server)