#'Count the number of times a beneficiary is supported
#'Whether it is supported by different themes, or components
#'And whether the beneficiary is supported in the same theme by different components 
#


infile <- "data/reference/beneficiaries.xlsx"
exfile <- "data/reference/beneficiaries_synergies.xlsx"

bens_clean <- rio::import(infile)


#utils =======================================================================
count_bens <- function(.data, 
                       grupo,
                       new_var,
                       count_this,
                       total = F,
                       ...){
  
  if(!total){
    .data %>%
      group_by_at(grupo) %>%
      mutate('{{new_var}}' := n()) %>%
      ungroup()
  } else { 
    
    
    .data %>%
      group_by_at(grupo) %>%
      mutate('{{new_var}}' := length(unique({{count_this}}))) %>%
      ungroup()
    
  }
  
}



#only beneficiaries that are supported more than once ==========================================================
synergies <- bens_clean %>%
  
  #Number of projects that the beneficiary is supported from
  count_bens(grupo = c("Country", "Beneficiary"), new_var = times_supported) %>%
  filter(times_supported > 1) %>%
  arrange(desc(times_supported), Country, Beneficiary) %>%
  #number of different themes that the beneficiary is supported
  count_bens(grupo = c("Beneficiary","Country"), new_var = number_themes, count_this = Theme, total = T) %>%
  #Number of different components that the beneficiary is supported
  count_bens(grupo = c("Beneficiary","Country"), new_var = number_components, count_this = Component, total = T) %>%
  #whether the beneficiary is supported twice in the same theme
  count_bens(grupo = c("Country", "Beneficiary", "Theme"), new_var = same_theme_more_than_once) %>%
  mutate(same_theme_more_than_once = same_theme_more_than_once > 1) %>%
  #whether the beneficiary is supported twice in the same theme
  count_bens(grupo = c("Country", "Beneficiary", "Component"), new_var = same_component_more_than_once) %>%
  mutate(same_component_more_than_once = same_component_more_than_once > 1) %>%
  #number of components by theme 
  count_bens(grupo = c("Beneficiary","Country", "Theme"), new_var = same_theme_two_components, count_this = Component, total = T) %>%
  mutate(same_theme_two_components = same_theme_two_components > 1)


#export ==========================================================================
rio::export(synergies, exfile, overwrite = T)
