data_map_server <-  function(id, sum_data, world) {
  moduleServer(id, function(input, output, session) {
    
    
    
    #reactive data for map -------------------------------------------------------
    map_component <- reactive({
      
      req(input$component)
      
      sum_data %>%
        filter(Component %in% input$component,
               Theme %in% input$theme) 
      
    })
    
    
    
    map_theme <- reactive({
      
      req(input$theme)
      map_component() %>%
        filter(Theme %in% input$theme)
      
      
    })
    
    map_sum <- reactive({
      
      #for the dashboard to identify components and themes
      components <- input$component
      themes <- input$theme
      
      selected_ats <- length(c(components, themes))
      
      map_theme() %>%
        #detect countries with selected components
        bind_detect(.,lkp = components, prefix = "comp_", target = "Component") %>%
        #detect countries with selected themes
        bind_detect(., lkp = themes, prefix = "theme_", target = "Theme") %>%
        #keep countries that have all selected attributes
        keep_true(selected_ats, world)
      
      
    })
    
    map_sum
    
    
    
  }
  )}