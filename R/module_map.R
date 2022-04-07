uiMap <- function(id){
  
  tagList(
    
    leafletOutput(NS(id,'map'), height = 480)
    
  )
}


#server -----------------------------------------------------------------------

serverMap <-  function(id, data_map, world, palette_map) {
  moduleServer(id, function(input, output, session) {
    
    
    
    pallete_map <- eventReactive(data_map(),{
      
      colorNumeric(
        rev(blue_palette),
        domain = data_map()$projects)
      
    })
    
    
    #map static
    output$map <- leaflet::renderLeaflet({
      
      leaflet(world,
              options=leafletOptions(dragging=F,
                                     minZoom=2, 
                                     maxZoom=2)) %>%
        addPolygons(fillColor = "gray",
                    color = "white",
                    layerId = ~ Country,
                    weight = 1) %>%
        setView(zoom = 2, lng = 0, lat = 10)
    })
    
    
    #map reactive 
    observe({
      proxy <- leafletProxy("map", data = world)
      
      #check if at least one country meets the target criteria (has all the attributes)
      rows <- nrow(data_map())
      
      #remove map there's no country but create the map if it is
      if(rows == 0){
        
        proxy %>%
          clearControls() %>%
          clearGroup("A") 
      } else {
        
        proxy %>%
          clearControls() %>%
          clearGroup("A") %>%
          addPolygons(data = data_map(),
                      color = "black",
                      fillColor =  ~ pallete_map()(projects),
                      fillOpacity = 1,
                      group = "A",
                      label = ~ Country,
                      layerId = ~ Country,
                      weight = 1)
        
        # addLegend(pal = pallete_map(),
        #           values = ~ rev(data_map()$projects),
        #           title = "Projects",
        #           labFormat = labelFormat(transform = function(x) sort(x, decreasing = TRUE))
        #           )
        
        
      }
      
    })
    
    
    
    
    
    
    Country <- eventReactive(input$map_shape_click,{
      
      req(!is.null(input$map_shape_click$id))
      input$map_shape_click$id 
      
    })
    
    Country
    
    
    
  })}