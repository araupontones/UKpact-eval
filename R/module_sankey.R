
serverSankey <-  function(id, country, app_data) {
  moduleServer(id, function(input, output, session) {
    
    
    
    sankey <- reactive({
      
      #format data
        links <- app_data %>%
        filter(Country == country()) %>%
        #Count projects by component %>%
        group_by(Component) %>%
        mutate(Component = paste0(Component," (", n(), ")")) %>%
        ungroup() %>%
        group_by(Theme) %>%
        mutate(themes = n(),
               Theme = paste0(Theme," (", themes, ")")) %>%
        ungroup()%>%
       group_by(Component, Theme,themes) %>%
        summarise(value = n(), .groups = 'drop') %>%
          arrange(desc(themes)) %>%
        rename(source = Component, 
               target = Theme)
        
        
        nodes <- data.frame(
          name=c(as.character(links$source), 
                 as.character(links$target)) %>% unique()
        )
        
        
        # With networkD3, connection must be provided using id, not using real name like in the links dataframe.. So we need to reformat it.
        links$IDsource <- match(links$source, nodes$name)-1 
        links$IDtarget <- match(links$target, nodes$name)-1
        
        
        sankey <- sankeyNetwork(Links = links, Nodes = nodes,
                           Source = "IDsource", Target = "IDtarget",
                           Value = "value", NodeID = "name", 
                           sinksRight=FALSE)
        
        sankey
      
      
    })
    
    
    
   
   
    
    
    
    
   sankey
    
  
    
    
   
  })
  
}




