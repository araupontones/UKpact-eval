library(shiny)
library(leaflet)
library(shiny)
library(dplyr)
library(reactable)


#load data
app_data <- rio::import("data/app/projects.rds")
sum_data <- rio::import("data/app/projects_group.rds")
world <- rio::import("data/shapefile/worldSF.rds") %>% sf::st_as_sf()


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
     sidebarLayout(
        
        sidebarPanel( class = "form",
           
           uiSideBar("sideBar", v_components, v_themes),
           
           #reactable::reactableOutput('table')
           uiHeadCountry("head_country")
           
        ),
        mainPanel(
           
           
           uiMap('map')
           
           
        )
     
  )),
  
  fluidRow(
    uiDataCountry('table_country')
  )
 
  
)

server <- function(input, output, session) {
  
#reactive data for map -------------------------------------------------------
#returns data used for the map   (all countries that meet the attributes)
   data_map <- data_map_server("sideBar", sum_data, world)
   
 
#reactive map ------------------------------------------------------------------
#returns selected country in the map

   country <- serverMap("map", data_map, world, palette_map = blue_palette)
   

#data for country selected country in the map-----------------------------------
 
 data_country <- data_country_server("sideBar", app_data, country)

 
 
 #head of table with flag and name of country ---------------------------------
 
 serverHeadCountry("head_country", world, country, data_map, data_country, selected)
 
#table for country data -------------------------------------------------------
 
 serverCountryTable("table_country", data_map, country, data_country)
    
 
 
 
 
 
 
 #table to test the data ======================================================
 output$table <- reactable::renderReactable({
   
   data_table <- data_map() %>% as.data.frame() %>% select(Country, projects)
   
   
   reactable::reactable(data_table,
                        selection = "single",
                        onClick = "select")
 })
 
 
 #to capture selection of the table
 selected <- reactive(getReactableState("table", "selected"))
 
 observe({
    
    #print(selected())
 })
}

shinyApp(ui, server)