#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#library(shiny)
#source("auxiliary_funcs.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  shinyjs::hide("submit.button")
  shinyjs::hide("status.button")
  shinyjs::hide("score.button")
  shinyjs::hide("add.button1")
  shinyjs::hide("add.button2")
  #kegg.files <- list.files(path = "orgs_gene_sets", pattern = ".[.]R$", full.names = TRUE)
  ######## Reactive Values
  tables <- reactiveValues(C.adj = NULL,T.adj=NULL,C.tm = NULL,T.tm=NULL,paths=NULL,pnames=NULL)
  progressValue <- reactiveValues(one=0,two=0,three=0)
  smt<-matrix(nrow = 2,ncol = 2,"")
  colnames(smt)=c("Adjacency","Transition")
  row.names(smt)=c("Control","Treatment")
  progressTable<- reactiveVal(smt)
    ######### TABLE LOADING ##########
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
  ###### ORGANISM DROP DOWN #####
  load(paste(kegg.folder,"/orgs.R",sep = ""))
  output$choose.organism <- renderUI({
    selectInput("organism", "Organism", as.list(orgs.sel[,2]))
    
  })
  observeEvent(input$organism,{
    found=which(orgs.sel[,2]==input$organism)
    #print(orgs.sel[found,1])
    load(paste(kegg.folder,"/",orgs.sel[found,1],"_names.R",sep = ""))
    load(paste(kegg.folder,"/",orgs.sel[found,1],".R",sep = ""))
    tables$paths=gene.set[1:5]
    tables$pnames=paths.names
    
    #d.score<-read.csv("data/output/res2fc02505cc9//scores.csv",header = TRUE,sep = ",")
    #res=map.path.names(d.score,tables$pnames)
    
    
    output$num.paths<- renderText({
      paste(length(gene.set)," pathways loaded.",sep = "")
    })
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
  ##### PROGRESS BARS #####
  output$progressOne <- renderUI({
    progressGroup(text = "Control experiment",
                  value = progressValue$one,
                  min = 0, max = 100, color = "aqua")
  })
  
  output$progressTwo <- renderUI({
    progressGroup(text = "Treatment experiment", 
                  value = progressValue$two,   
                  min = 0, max = 100, color = "red")
  })
  
  #output$progressThree <- renderUI({
  #  progressGroup(text = "Organism Selection",        
  #                value = progressValue$three, 
  #                min = 0, max = 100, color = "green")
  #})
  ####### Submited Files Summary  ####
  output$progresstable<- renderTable({
    progressTable()
  },rownames = TRUE)
  ####### STEP1:SUBMIT transition and adjacency tables
  observeEvent(input$add.button1,{
    tmpt=progressTable()  
    if(input$matrix.step1=="A"){
      tables$C.adj=data1()
      tmpt[1,1]=isolate(input$file1)$name
      txt="Adjacency"
    }else{
      tables$C.tm=data1()
      tmpt[1,2]=isolate(input$file1)$name
      txt="Transition"
    }
    progressTable(tmpt)
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
    tmpt=progressTable()
    if(input$matrix.step2=="A"){
      tables$T.adj=data2()
      tmpt[2,1]=isolate(input$file2)$name
      txt="Adjacency"
    }else{
      tables$T.tm=data2()
      tmpt[2,2]=isolate(input$file2)$name
      txt="Transition"
    }
    progressTable(tmpt)
    ####### Notify User
    showNotification(paste(Sys.time(),", [STEP2] ",txt
                           ," matrix successfully submitted")
                     , duration = 10
                     ,type="message")
    ###### Monitor submission level
    progressValue$two <- (1- ((is.null(tables$T.tm)+is.null(tables$T.adj))/2) )*100
  })
  ####### JOB SUBMISSION #####
  observeEvent({progressValue$one
                progressValue$two},{
      if(progressValue$one==100 & progressValue$two==100){
        shinyjs::show("submit.button")
      }
    })
  ######### Expanet STEP1 ######
  expanet.st <- reactiveVal(0)
  expanet.st2 <- reactiveVal(0)
  expanet.fin <- reactiveVal(0)
  observeEvent(input$submit.button,{
    expanet.st(0)
    expanet.st2(0)
    shinyjs::show("status.button")
    shinyjs::show("score.button")
    #lb=c(input$label1,input$label2)
    
    future(exec1(isolate(tables$C.tm),isolate(tables$paths),isolate(input$label1),d1)
           )%...>%   #this part is not actually working
      expanet.st() %...!%  # Assign to data 
      (function(e) {
        expanet.st(0)
        warning(e)
        session$close()
      })
    future(exec1(isolate(tables$T.tm),isolate(tables$paths),isolate(input$label2),d2)
    )%...>%   #this part is not actually working
      expanet.st2() %...!%  # Assign to data 
      (function(e) {
        expanet.st2(0)
        warning(e)
        session$close()
      })
    # Hide the async operation from Shiny by not having the promise be
    # the last expression.
    NULL
  })
  ###### EXPANET STEP2 #######
  autoInvalidate <- reactiveTimer(10000)
  observe({
    # Invalidate and re-execute this reactive expression every time the
    # timer fires.
    autoInvalidate()
    
    if( file.exists(paste(d1,"/done.txt",sep = "")) & 
        file.exists(paste(d2,"/done.txt",sep = "")) & 
        file.exists(d3)==FALSE ){
      future(exec2(isolate(tables$C.adj),
                   isolate(tables$T.adj),
                   isolate(tables$paths)
                   )
      )%...>%   #this part is not actually working
        expanet.fin() %...!%  # Assign to data 
        (function(e) {
          expanet.fin(0)
          warning(e)
          session$close()
        })
    }
    NULL
  })
  ####### Check Status TAB  #######
  observeEvent(input$status.button,{
  #observe({
  #  autoInvalidate()
    output$header1<-renderText({
      paste("<h3>",isolate(input$label1),"</h3>")
    })
    output$header2<-renderText({
      paste("<h3>",isolate(input$label2),"</h3>")
    })
    output$controlProgress1 <- renderInfoBox({
      #print(d1)
      E.files <- list.files(d1, pattern = ".[.]E$", full.names = TRUE)
      infoBox(paste("Pathways Expanded"), length(E.files),
              icon = icon("bezier-curve"),
              color = "teal"
              )
      })
    output$controlProgress2 <- renderInfoBox({
      #print(d2)
      E.files <- list.files(d2, pattern = ".[.]E$", full.names = TRUE)
      infoBox(paste("Pathways Expanded"), length(E.files),
              icon = icon("bezier-curve"),
              color = "yellow"
      )
    })
    txt=vector()
    txt[1]<-"<h4>[1] Network Expansion has started.</h4>"
    if(file.exists(paste(d1,"/done.txt",sep = ""))){
      txt[2]<-paste("<h4>[2] Network Expansion for: [",isolate(input$label1),"] has been completed.</h4>")
    }
    if(file.exists(paste(d2,"/done.txt",sep = ""))){
      txt[3]<-paste("<h4>[3] Network Expansion for: [",isolate(input$label2),"] has been completed.</h4>")
    }
    if(file.exists(paste(tf,"/done.txt",sep = ""))){
      txt[4]<-paste("<h4>[4] Pathway Enrichment Analysis has been completed.</h4>")
    }
    output$statusmsg<- renderText({
      paste(txt,sep = "",collapse = " ")
    })
  })
  observeEvent(input$score.button,{
    if(file.exists(d3)){
      #### read score table
      score.table<-reactiveVal({
        d.score<-read.csv(paste(d3,"/scores.csv",sep = ""),header = TRUE,sep = ",")
        if(ncol(d.score)==1){
          d.score=t(d.score)
          res=map.path.names(d.score,tables$pnames)
          d.score=c(d.score[1:2],res,d.score[3])
        }else{
          res=map.path.names(d.score,tables$pnames)
          d.score=cbind(d.score[,1:2],res,d.score[,3])
          colnames(d.score)<-c("score","Pathway ID","Pathway Name","Nodes of interest")
        }
        
        d.score
      })
      ### Creat view for the score table
      output$score.table<-renderDataTable({
        score.table()
      })
      #### create download button for score table
      output$d.button1<-renderUI({
        downloadButton("downloadScoreTable", "Download")
      })
      # Handler: csv of selected dataset ----
      output$downloadScoreTable <- downloadHandler(
        filename = function() {
          paste(input$label1,"_VS_",input$label2, "_score.csv", sep = "")
        },
        content = function(file) {
          write.csv(score.table(), file, row.names = FALSE)
        }
      )
    }
  })
  ###### DROP DOWN GML GRAPHS - DOWNLOAD TAB ########
  observeEvent(input$gml.button,{
    if(file.exists(d3)){
      ### drop down gml for paths
      output$dropdown.gml.C<- renderUI({
        selectInput("dropdown.gml.C", "Choose a pathway:",
                    choices = list.files(paste(d1,"/graphs",sep = ""), 
                                         pattern = ".[.]gml$", 
                                         full.names = FALSE)
        )
      })
      ### drop down gml for paths
      output$dropdown.gml.T<- renderUI({
        selectInput("dropdown.gml.T", "Choose a pathway:",
                    choices = list.files(paste(d2,"/graphs",sep = ""), 
                                         pattern = ".[.]gml$", 
                                         full.names = FALSE)
        )
      })
    }
  })
  ###### DROP DOWN GML GRAPHS - PLOT TAB ########
  observeEvent(input$gmlplot.button,{
    if(file.exists(d3)){
      ### drop down gml for paths
      output$dropdown.gmlplot.C<- renderUI({
        selectInput("dropdown.gmlplot.C", paste(isolate(input$label1),": Choose a pathway:"),
                    choices = list.files(paste(d1,"/graphs",sep = ""), 
                                         pattern = ".[.]gml$", 
                                         full.names = FALSE)
        )
      })
      ### drop down gml for paths
      output$dropdown.gmlplot.T<- renderUI({
        selectInput("dropdown.gmlplot.T", paste(isolate(input$label2),": Choose a pathway:"),
                    choices = list.files(paste(d2,"/graphs",sep = ""), 
                                         pattern = ".[.]gml$", 
                                         full.names = FALSE)
                    )
        })
      }
  })
  
  ######### READ AND DOWNLOAD GRAPH TRIGGERING #######
  observeEvent(input$dropdown.gml.C,{
    gml.C<-reactiveVal({
      read_graph(paste(d1,"/graphs/",input$dropdown.gml.C,sep = ""), format = c("gml"))
    })
    ### download button for paths
    output$d.button2<-renderUI({
      downloadButton("downloadpath.C", "Download")
    })
    # Handler: csv of selected dataset ----
    output$downloadpath.C <- downloadHandler(
      filename = function() {
        paste(input$label1,"_",input$dropdown.gml.C,sep = "")
      },
      content = function(filename) {
        write_graph(gml.C(), filename, format = "gml")
      }
    )
  })
  observeEvent(input$dropdown.gml.T,{
    gml.T<-reactiveVal({
      read_graph(paste(d2,"/graphs/",input$dropdown.gml.T,sep = ""), format = c("gml"))
    })
    ### download button for paths
    output$d.button3<-renderUI({
      downloadButton("downloadpath.T", "Download")
    })
    # Handler: csv of selected dataset ----
    output$downloadpath.T <- downloadHandler(
      filename = function() {
        paste(input$label2,"_",input$dropdown.gml.T,sep = "")
      },
      content = function(filename) {
        write_graph(gml.T(), filename, format = "gml")
      }
    )
  })
  observeEvent(input$dropdown.gmlplot.C,{
    gmlplot.C<-reactiveVal({
      read_graph(paste(d1,"/graphs/",input$dropdown.gmlplot.C,sep = ""), format = c("gml"))
    })
    ###### GRAPHS VIS  #####
    observeEvent({input$layout
                  gmlplot.C()},{
                    output$graph.C<-net.plot(gmlplot.C(),input$layout)
                    })
    })
  observeEvent(input$dropdown.gmlplot.T,{
    gmlplot.T<-reactiveVal({
      read_graph(paste(d2,"/graphs/",input$dropdown.gmlplot.T,sep = ""), format = c("gml"))
    })
    ###### GRAPHS VIS  #####
    observeEvent({input$layout
                  gmlplot.T()},{
                    output$graph.T<-net.plot(gmlplot.T(),input$layout)
                    })
    })
})
