
#' Detect whether the country has all the components and themes selected
#' @param look_for vector of selected components or themes to confirm
#' @param prefix prefix to assign to the new variable created c(comp_, "theme_)
#' @param target Name of the variable to check against c(Component, Theme)
#' @param .data a grouped tibble with the number of components and themes by country
#' @result A tibble with new variables that indicate which selected components & themes exist in the data




#'Function to detect whether the component or the theme exist in the country
#'It loops over all the selected themes and components to assess if they exist in the country

detect_vars <- function(.data,look_for, prefix, target){
  
  #for each selected attribute, create a variable name
  datas <- lapply(look_for, function(x){
    set_num <- which(look_for == x)
    var_nam <- paste0(prefix, set_num)
    
    #assess whether the attribute exists for each country
    data_look <- mutate(.data, {{var_nam}} := .data[[target]] == x ) %>%
      select({{var_nam}})
    
  })
  
}

#'once that it is detected, bind the datasets with the main one
#'@param lkp vector to check for c(selected components, selected themes)
#'@result the original data with the assessment whether the selected attributes exits

bind_detect <- function(.data, lkp, prefix, target){
  
  #assess all the attributes
  detect <- detect_vars(.data, lkp, prefix = prefix, target = target)
  detect_bin <- do.call(cbind, detect)
  #bind with grouped data
  with_original <- cbind(.data, detect_bin)
  
}

#'keep only Countries that have all selected attributes
#'@param num_ats number of selected attributes
#'@param world shapefile with world polygons

keep_true <- function(.data, num_atts, world){
  
  .data %>%
    group_by(Country) %>%
    mutate(across(c(starts_with("comp"),starts_with("theme")), max)) %>%
    ungroup()%>%
    rowwise() %>%
    mutate(total = sum(c_across(c(starts_with("comp_"),starts_with("theme_"))))) %>%
    ungroup() %>%
    filter(total == num_atts) %>%
    ungroup() %>%
    left_join(world, by = "Country") %>%
    sf::st_as_sf() %>%
    group_by(Country) %>%
    summarise(projects = sum(projects), .groups = 'drop') 
}



