#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source("auxiliary_funcs.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  shinyjs::hide("submit.button")
  shinyjs::hide("add.button1")
  shinyjs::hide("add.button2")
  shinyjs::hide("add.button3")
  
  mesgs <- reactiveValues()
  data1<-eventReactive(input$file1,{
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    req(input$file1)
    df=load.file(input$file1$datapath)
    return(df)
  })
  data2<-eventReactive(input$file2,{
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    req(input$file2)
    df=load.file(input$file2$datapath)
    return(df)
  })
  data3<-eventReactive(input$file3,{
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    req(input$file3)
    df=load.file(input$file3$datapath)
    return(df)
  })
  ###### VALIDATE INPUT AT STEP 1
  observeEvent(data1(),{
    shinyjs::hide("add.button1")
    v1=valid.table(data1())
    c.msgs=c(paste("The table is not square. #Rows:",v1[3],
                   " #Columns: ",v1[4],".",sep = ""),
             paste("The table contains non numeric values at columns: ",
                   v1[5],".",sep = "")
             )
    if(v1[1]=="TRUE" & v1[2]=="TRUE"){
      showNotification(paste(Sys.time(),", [STEP1] Input looks ok!")
                       , duration = 10
                       ,type="message")
      shinyjs::show("add.button1")
    }else{
      c.msgs.string=paste(c.msgs[v1[1:2]=="FALSE"],
                                collapse=" ")
      showNotification(paste(Sys.time(),", [STEP1] ",c.msgs.string)
                       , duration = 15
                       ,type="error")
      shinyjs::hide("add.button1")
    }
  })
  ###### VALIDATE INPUT AT STEP 2
  observeEvent(data2(),{
    shinyjs::hide("add.button2")
    v1=valid.table(data2())
    c.msgs=c(paste("The table is not square. #Rows:",v1[3],
                   " #Columns: ",v1[4],".",sep = ""),
             paste("The table contains non numeric values at columns: ",
                   v1[5],".",sep = "")
    )
    if(v1[1]=="TRUE" & v1[2]=="TRUE"){
      showNotification(paste(Sys.time(),", [STEP2] Input looks ok!")
                       , duration = 10
                       ,type="message")
      shinyjs::show("add.button2")
    }else{
      c.msgs.string=paste(c.msgs[v1[1:2]=="FALSE"],
                          collapse=" ")
      showNotification(paste(Sys.time(),", [STEP2] ",c.msgs.string)
                       , duration = 15
                       ,type="error")
      shinyjs::hide("add.button2")
    }
  })
  ###### VALIDATE INPUT AT STEP 3
  observeEvent(data3(),{
    shinyjs::hide("add.button3")
    df=data3()
    if(ncol(df)==2){
      showNotification(paste(Sys.time(),", [STEP3] Input looks ok!")
                       , duration = 10
                       ,type="message")
      shinyjs::show("add.button3")
    }else{
      showNotification(paste(Sys.time(),", [STEP3] "
                             ,"The gene set looks problematic")
                       , duration = 15
                       ,type="error")
      shinyjs::hide("add.button3")
    }
  })
  ##### PROGRESS BARS #####
  progressValue <- reactiveValues()
  progressValue$one <- 0
  progressValue$two <- 0
  progressValue$three <- 0
  progressValue$four <- 0

  output$progressOne <- renderUI({
    progressGroup(text = "Control experiment submission",
                  value = progressValue$one,
                  min = 0, max = 100, color = "aqua")
  })
  
  output$progressTwo <- renderUI({
    progressGroup(text = "Condition experiment submission", 
                  value = progressValue$two,   
                  min = 0, max = 100, color = "red")
  })
  
  output$progressThree <- renderUI({
    progressGroup(text = "Gene-Path mapping submission",        
                  value = progressValue$three, 
                  min = 0, max = 100, color = "green")
  })
  ######## List of tables uploaded
  tables <- reactiveValues(C.adj = NULL,T.adj=NULL,C.tm = NULL,T.tm=NULL)
  ####### STEP1:SUBMIT transition and adjacency tables
  observeEvent(input$add.button1,{
      
    if(input$matrix.step1=="A"){
      tables$C.adj=data1()
      txt="Adjacency"
    }else{
      tables$C.tm=data1()
      txt="Transition"
    }
    ####### Notify User
    showNotification(paste(Sys.time(),", [STEP1] ",txt
                           ," matrix successfully submitted")
                     , duration = 10
                     ,type="message")
    ###### Monitor submission level
    progressValue$one <- (1- ((is.null(tables$C.tm)+is.null(tables$C.adj))/2) )*100
  })
  ####### STEP2:SUBMIT transition and adjacency tables
  observeEvent(input$add.button2,{
    
    if(input$matrix.step2=="A"){
      tables$T.adj=data2()
      txt="Adjacency"
    }else{
      tables$T.tm=data2()
      txt="Transition"
    }
    ####### Notify User
    showNotification(paste(Sys.time(),", [STEP2] ",txt
                           ," matrix successfully submitted")
                     , duration = 10
                     ,type="message")
    ###### Monitor submission level
    progressValue$two <- (1- ((is.null(tables$T.tm)+is.null(tables$T.adj))/2) )*100
  })
  
})
