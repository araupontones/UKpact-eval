uiMap <- function(id){
  
  tagList(
    
    leafletOutput(NS(id,'map'), height = 480)
    
  )
}


#server -----------------------------------------------------------------------

serverMap <-  function(id, projects_map, world, palette_map,app_data) {
  moduleServer(id, function(input, output, session) {
    
    
    
    pallete_map <- reactive({
      
      colorFactor(rev(blue_palette), projects_map$components)
      
      # colorNumeric(
      #   rev(blue_palette),
      #   domain = projects_map$components)
      
    })
    
    
    pallete_circles <- reactive({
      
      
      
      colorNumeric(
        rev(blue_palette),
        domain = projects_map$projects)
      
    })
    
    
    #map static
    output$map <- leaflet::renderLeaflet({
      
      leaflet(world,
              options=leafletOptions(dragging=F,
                                     minZoom=2, 
                                     maxZoom=2)) %>%
        addPolygons(fillColor = "gray",
                    color = "white",
                    #layerId = ~ Country,
                    weight = 1)  %>%
        
        #Pact countries ------------------------------------------
        addPolygons(data = projects_map,
                    color = "white",
                    fillColor =  ~ pallete_map()(components),
                    fillOpacity = 1,
                    #label = ~ projects,
                    #labelOptions = list(permanent = TRUE),
                    #layerId = ~ Country,
                    weight = 1) %>%
       
       #number of projects 
        addCircleMarkers(data = projects_map,
                   lat = ~ latitude,
                   lng = ~ longitude,
                   fillColor =  ~ pallete_circles()(projects),
                   color = red_pact,
                   radius = projects_map$projects,
                   group = "circles"
                   ) %>% 
        
        # #add markers
       
        addLabelOnlyMarkers(
          data = projects_map,
          lat = ~ latitude,
          lng = ~ longitude,
          label = ~ projects,
          labelOptions = leaflet::labelOptions(
            noHide = TRUE,
            direction = "bottom",
            textOnly = TRUE,
            offset = c(0, -20),
            opacity = 1,
            color = "white"
          )
         
        ) %>%
        
        #invisible polygons to click on
        addPolygons(data = projects_map,
                    # color = "white",
                    weight = 0,
                    fillOpacity = 0,
                    layerId = ~ Country,
                    
        ) %>%
        
        
        #legend ------------------------------------
        addLegend("topright",
                  pal = pallete_map(),
                  values = ~ projects_map$components,
                  title = "Components",
                  opacity = 1) %>%

        setView(zoom = 7, lng = 0, lat = 18)
    })
    
   
    
    
    
    
    Country <- eventReactive(input$map_shape_click,{
      
      req(!is.null(input$map_shape_click$id))
      input$map_shape_click$id 
      
    })
    
    Country
    
    
    
  })}