
uiSideBar <- function(id, v_components, v_themes){
  
  tagList(
    
    selectInput(NS(id,"component"), "Components", choices = v_components, multiple = T, selected = v_components[1]),
    selectInput(NS(id,"theme"), "Themes", choices = v_themes, multiple = T, selected = "Energy")
    
    #reactable::reactableOutput('table')
  )
  
}

