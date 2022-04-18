uiHeadCountry <- function(id){
  tagList(
    
    uiOutput(NS(id,'head_country'))
  )
  
}



#server -----------------------------------------------------------------------

serverHeadCountry <-  function(id, country, projects_map) {
  moduleServer(id, function(input, output, session) {
    
    
    #fetch flag of slected country    
    flag <- reactive({
      
      iso2 <- projects_map$iso2[projects_map$Country == country()]
      flag <- glue::glue("flags/{iso2}.png")
      
      flag
      
    })
    
    
    projects <- reactive({
      
      projects <- projects_map$projects[projects_map$Country == country()]
    
      projects
      })
    
    
    components <- reactive({
      
      components <- projects_map$components[projects_map$Country == country()]
      
      components
    })
    
    
    themes <- reactive({
      
      themes <- projects_map$themes[projects_map$Country == country()]
      
      themes
    })
    
   
    list(
      flag = flag,
      projects = projects,
      components  = components,
      themes = themes
    )
    
    
    
  })}