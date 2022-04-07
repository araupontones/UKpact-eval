uiHeadCountry <- function(id){
  tagList(
    
    uiOutput(NS(id,'head_country'))
  )
  
}



#server -----------------------------------------------------------------------

serverHeadCountry <-  function(id, world, country, data_map, data_country, selected) {
  moduleServer(id, function(input, output, session) {
    
    
    #fetch flag of slected country    
    flag <- reactive({
      
      iso2 <- world$iso2[world$Country == country()]
      flag <- glue::glue("flags/{iso2}.png")
      
      flag
      
    })
    
    #get the number of projects for this combination
    projects <- reactive({
      
      nrow(data_country())
      
    })
    
    
    #reactive text for selected country
    #start with Select a countyr
    text_selected <- reactiveVal(  
      h1(class = "title_country", "Select a country") 
    )
    
    
    
    
    #change it based on selected country
    observe({
      
      exists_in_map <- sum(data_map()$Country == country())
      
      
      
      
      if(exists_in_map > 0){
        
        text_selected(
          tags$div(class = "container-header-country",
                   tags$img(src = flag(), class = "flag"),
                   h1(class = "title_country",country()),
                   h3(glue::glue('{projects()} Projects' ))
          )
        )
        
        
      } else if(nrow(data_map()) >0){
        text_selected(
          h1(class = "title_country", "Select a country") 
        )
        
        
        
      } else {
        text_selected(
          h1(class = "title_country", "This combination of components and themes is not implemented in any country")
        )
        
      }
      
    })
    
    
    
    
    
    output$head_country <- renderUI({
      
      
      
      text_selected()
      
      
      
    })
    
    
    
    
    
  })}