data_country_server <-  function(id, app_data, country) {
  moduleServer(id, function(input, output, session) {
    
    
    
    data_country <- reactive({
      
      req(!is.null(country()))
      
      app_data %>%
        filter(Country == country()) %>%
        filter(Component %in% input$component) %>%
        filter(Theme %in% input$theme) %>%
        arrange(Component, Theme) %>%
        select(- c(Country, ends_with("Date")))
    })
    
    
    
    
  })}



