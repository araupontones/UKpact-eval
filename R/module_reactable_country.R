uiDataCountry <- function(id){
  tagList(
    
    reactableOutput(NS(id,"country_table"))
  )
  
}



#server -----------------------------------------------------------------------

serverCountryTable <-  function(id, data_map, country, data_country) {
  moduleServer(id, function(input, output, session) {
  
    
    
    output$country_table <- reactable::renderReactable({
      
      #only render table if country exists in data_map
      exists_in_map <- sum(data_map()$Country == country())
      
    
      #!is.null(data_country() & 
      if(exists_in_map > 0){
        reactable(data_country(),
                  columns = list(
                    Theme = colDef(minWidth = 70),
                    Description = colDef(minWidth = 250)
                    
                  ))
                  
        
      } else {
        
        
        
      }
      
      
      
    })
    
    
    
    
    })}