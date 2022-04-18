serverDatabens <-  function(id, country, bens_data) {
  moduleServer(id, function(input, output, session) {
    
    

 bens <- reactive({
   
   
   bens_data %>%
     ungroup() %>%
   filter(Country == country()) %>%
     filter(same_theme_two_components) %>%
     mutate(Component = sub("Component [0-9]:","", Component),
            Component = stringr::str_to_title(Component)) %>%
       select(Beneficiary, Theme, Component, 
              `Start Date` = Start_Date)
   
 })
 
 
 bens
  


})

}



#Beneficiary:

#table: project, theme, Component, start_date