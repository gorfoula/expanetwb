#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  shinyjs::hide("submit.button")
  shinyjs::hide("add.button")
  data<-eventReactive({input$file1
                        input$header
                        input$sep
                        input$quote},{
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    
    req(input$file1)
    
    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
      {
        df <- read.csv(input$file1$datapath,
                       header = input$header,
                       sep = input$sep,
                       quote = input$quote)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )
    
    if(ncol(df)>1){
      row.names(df)=df[,1]
      df=df[,2:ncol(df)]
      if(input$header==FALSE){
        colnames(df)=row.names(df)
      }
    }
    return(df)
  })
  
  output$contents <- renderDataTable({return(head(data()))}, 
                                  options = list(scrollX = TRUE))

  
  
  observeEvent(data(),{
    shinyjs::hide("submit.button")
    shinyjs::hide("add.button")
    df=data()
    d.size=dim(df)
    txt<-""
    col.num<-sapply(df, is.numeric)
    ####Square table check  ####Numeric table check
    if( (d.size[1])!=d.size[2] || (length(which(col.num==FALSE))>0)  ){ ## table is not square
      if((d.size[1])!=d.size[2]){
       txt<-paste("The table you have provided is not square. #Rows:",d.size[1]," #Columns: ",d.size[2],".")
      }
      if(length(which(col.num==FALSE))>0){
        txt<-paste(txt,"\r","The table contains non numeric values at columns: ",which(col.num==FALSE),sep = "")
      }
      
      output$msgerror <- renderText({ 
        txt
      })
      showNotification(paste(Sys.time(),"\r",txt), duration = 16,type="error")
      shinyjs::hide("submit.button")
      
    }
    else{
      output$msgerror <- renderText({ 
        "Input looks ok"
      })
      showNotification(paste(Sys.time(),", Input looks ok"), duration = 10,type="message")
      shinyjs::show("submit.button")
      shinyjs::show("add.button")
    }
  })
  ####### SUBMIT transition and adjacency tables
  tables <- reactiveValues(C.adj = NULL,T.adj=NULL,C.tm = NULL,T.tm=NULL)
  observeEvent(input$add.button,{
    if(input$experiment=="C"){
      if(input$matrix=="A"){
        tables$C.adj=data()
      }else{
        tables$C.tm=data()
      }
      
    }else{
      if(input$matrix=="A"){
        tables$T.adj=data()
      }else{
        tables$T.tm=data()
      }
    }
    ###### Monitor submission level
    perc_completion=is.null(tables$C.adj)+is.null(tables$T.adj)+
      is.null(tables$C.tm)+is.null(tables$T.tm)
    output$approvalBox <- renderInfoBox({
      infoBox(
        "Approval", (1-(perc_completion/4))*100,"%"
        , icon = icon("thumbs-up", lib = "glyphicon"),
        color = "yellow", fill = TRUE
      )
    })
    ##
  })
  
})
