library(glue)
library(httr)
library(jsonlite)
library(dplyr)
library(tidyr)
library(stringr)


exfile <- "data/reference/beneficiaries.xlsx"

#'Download report ================================================================================


projects <- rio::import("data/reference/themes_by_compoment_long.xlsx") %>% select(Project, Country)



##get new token get report
refresh_token = "1000.b11df28b89daaeb2df10fa2c43178db6.6f953944b607f0ff366915cb9a770edc"

#refresh zoho token --------------------------------------------------------------
new_token <- zohor::refresh_token(
  base_url = "https://accounts.zoho.com",
  client_id = "1000.V0FA571ML6VV7YFWRC4Q7OKQ32U5PZ",
  client_secret = "c551969c7d49a7a945ac2da12d1a3fe5f241b8dae6",
  refresh_token = refresh_token
)



url_app = "https://creator.zoho.com"
account_owner_name = "araupontones"
app_link_name = "uk-pact"
report_link_name = "all_projects"
access_token = new_token
criteria = 'ID != 0'


query_report <- glue::glue("{url_app}/api/v2/{account_owner_name}/{app_link_name}/report/{report_link_name}")


response_report <-  GET(query_report,
                        add_headers(Authorization = glue('Zoho-oauthtoken {access_token}')),
                        query = list(criteria = criteria,
                                     limit = 200,
                                     from = 1))


raw_report <- fromJSON(content(response_report, 'text'))$data
names(raw_report)

#clean report ====================================================================================


#select relevant variables
bens <- raw_report %>%
  select(Project_Name, Lot, contains("Date"), Beneficiaries, Theme, Start_Date) %>%
  filter(Lot != "Component 4: portfolio balancing investment panel")
 

#unnest beneficiaries 


list_bens <- lapply(1:nrow(bens), function(x){
 
#define relevant variables
  data <- bens[x, ]
 project <- data$Project_Name[1]
 component <- data$Lot[1]
 theme <- data$Theme[1]
 start_date <- data$Start_Date[1]

 #convert to tibble
 benes <- do.call(rbind, data$Beneficiaries) %>% tibble()
 
 #if the project has a beneficiary return the data
 names_cols <- which(names(benes) == "display_value")
 
 if(length(names_cols) > 0) {
   
   benes_proj <- benes %>%
     select(Beneficiary = display_value) %>%
     mutate(Project = project,
            Theme = theme,
            Component = component,
            Start_Date = start_date)
   
   return(benes_proj)
   
 } else {
   return(NULL)
 }
 
 
})



#unnest beneficiaries 
bens_unnest <- do.call(rbind, list_bens) %>%
  left_join(projects) %>%
  filter(!is.na(Country)) %>%
  relocate(Country, Project, Theme, Component) %>%
  arrange(Country, Component, Theme, Project, Beneficiary)

View(bens_unnest)

# export data ====================================================================================

rio::export(bens_unnest, exfile, overwrite = T )


