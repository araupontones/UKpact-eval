serverDialog <-  function(id, country, country_info, sankey, bens, timevis) {
  moduleServer(id, function(input, output, session) {
    
  
    
    bens_synergy <- reactive({
      
      rows <- nrow(bens())
      
      
      
      if(rows == 0){
        
        bens_name <- ""
        bens_number <- rows
        bens_text <- "None beneficiary is"
        bens_table <- NULL
        
        
        
      } else {
        
        bens_name <- unique(bens()$Beneficiary)
        bens_number <- length(bens)
        bens_table <- reactable(bens())
      }
      
      
      if(bens_number == 1){
        
        bens_text <- paste(bens_number, "beneficiary is")
        
      }
      
      if(bens_number > 1){
        
        
        bens_text <- paste(bens_number, "beneficiaries are")
      }
      
      
      list(bens_number = bens_number, 
           bens_number = bens_number,
           bens_table = bens_table,
           bens_text = bens_text
           )
    })
    
    
    
    observeEvent(country(),{
     
      
      showModal(modalDialog(
        title = tags$div(
          tags$img(src = country_info$flag(), class = "flag"),
          h1(class = "title_country", paste0(country(),
                                             ": ",
                                             country_info$projects(),
                                             " Projects, ",
                                             country_info$components(),
                                             " Components, ",
                                             country_info$themes(),
                                             " theme(s)."
          )
             
             )
        ),
        #footer = NULL,
        #easyClose = T,
        fade = FALSE,
         fluidRow(
          column(6, sankey()),
          column(6,
                 h4( class = 'title-bens', "Start dates of components:"),
                 timevis(),
                   h4( class = 'title-bens',
                     paste( bens_synergy()$bens_text,
                            "supported in the same theme by more than one component."
                            
                     )
                   )
                  ,
                   tags$div(class = 'table-bens',
                            bens_synergy()$bens_table
                   )
                 
                 )
        )
        
       
      )) 
      
    })
    
    
    })
  
  }