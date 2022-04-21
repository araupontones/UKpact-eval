
serverTimeVis <-  function(id, country, app_data) {
  moduleServer(id, function(input, output, session) {
    
    
    
    timevis <- reactive({
      
      #take data app
      components_time <- app_data %>%
        rename(content = Component) %>%
        group_by(Country, content) %>%
        summarise(start = min(Start_Date),
                  end = "30-Mar-2022",
                  .groups = 'drop') %>%
        arrange(desc(start))
      
      
      
      data <- components_time %>%
        filter(Country == country())
      
      
      timevis::timevis(data = data,
                       showZoom =  F)
      
      
      
    })
    
    
    
   
   
    
    
    
    
    timevis
    
  
    
    
   
  })
  
}




