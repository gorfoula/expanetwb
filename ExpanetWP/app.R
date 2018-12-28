#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#library(shiny)
source("global.R")
# Define UI for application that draws a histogram
title<-tags$a(href="www.google.gr",tags$img(src='Expanet_logo.png',height='40',width='160')) 
ui <- function(req) {
  dashboardPage(skin = "black",
                dashboardHeader(title = title, titleWidth = 200),
                dashboardSidebar(
                  #sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                  #                  label = "Search..."),
                  sidebarMenu(id = "sidebar",
                              ###### SIDE MENU ####
                              menuItem("Load your data", tabName = "dselection", icon = icon("database")),
                              menuItem("Results", tabName = "results", icon = icon("database")),
                              menuItem("About", tabName = "help_page", icon = icon("database")),
                              menuItem("Contact",tabName = "contact_page",icon = icon("address-card"))
                              #menuItemOutput("menu.quant"),
                  )
                ),
                dashboardBody(
                  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "app.css")),
                  tabItems(
                    tabItem(tabName = "dselection",
                            fluidRow(
                              ##### FILE SUBMISSION PROGRESS ####
                              column(width = 6,
                                     box(title = "File Submission Progress",status = "success",
                                         width = NULL,
                                         #p(strong("Goal Completion"), class = "text-center"),
                                         uiOutput(outputId = "progressOne"),
                                         uiOutput(outputId = "progressTwo")
                                         #uiOutput(outputId = "progressThree")
                                     )
                              ),
                              column(width = 6,
                                     box(title = "Submitted Files",status = "success",
                                         width = NULL,
                                         tableOutput("progresstable"),
                                         useShinyjs(),
                                         div(style="display: block;vertical-align:top;margin-top: 1px",
                                             actionButton(inputId = "submit.button"
                                                          , label = "Submit"),
                                             actionButton(inputId = "load.example",
                                                          label = "Load Example")
                                             )
                                         )
                                     )
                            ),
                            ####### STEP 1 ######
                            fluidRow(
                              column(width = 4,
                                     box(title = "STEP1: Control experiment",
                                         status = "primary",
                                         width = NULL,
                                         solidHeader = TRUE,
                                         collapsible = TRUE,
                                         helpText("Provide an experiment name."),
                                         textInput("label1", "Label",value = "Control"),
                                         # Control: Transition file load
                                         h3("Transition Matrix"),
                                         helpText("Provide square transition matrix."),
                                         fileInput("file1.tran", "Choose TAB delimited File",
                                                   multiple = FALSE,
                                                   accept = c("text/tab",
                                                              "text/tab-separated-values,text/plain",
                                                              ".tab")
                                         ),
                                         # add file button
                                         useShinyjs(),
                                         div(style="display: block;vertical-align:top;margin-top: 1px",
                                             actionButton(inputId = "add.button1.tran", label = "Add!")
                                         ),
                                         # Control: Adjacency file load
                                         h3("Adjacency Matrix"),
                                         helpText("Provide square adjacency matrix."),
                                         fileInput("file1.adj", "Choose TAB delimited File",
                                                   multiple = FALSE,
                                                   accept = c("text/tab",
                                                              "text/tab-separated-values,text/plain",
                                                              ".tab")
                                         ),
                                         # add file button
                                         useShinyjs(),
                                         div(style="display: block;vertical-align:top;margin-top: 1px",
                                             actionButton(inputId = "add.button1.adj", label = "Add!")
                                         )
                                     )
                              ),
                              ####### STEP 2 ######
                              column(width = 4,
                                     box(title = "STEP2: Treatment Experiment",
                                         status = "info",
                                         width = NULL,
                                         solidHeader = TRUE,collapsible = TRUE,
                                         helpText("Provide an experiment name."),
                                         textInput("label2", "Label",value = "Treatment"),
                                         # Treatment: Transition file load
                                         h3("Transition Matrix"),
                                         helpText("Provide square transition matrix."),
                                         fileInput("file2.tran", "Choose TAB delimited File",
                                                   multiple = FALSE,
                                                   accept = c("text/tab",
                                                              "text/tab-separated-values,text/plain",
                                                              ".tab")
                                         ),
                                         # add file button
                                         useShinyjs(),
                                         div(style="display: block;vertical-align:top;margin-top: 1px",
                                             actionButton(inputId = "add.button2.tran", label = "Add!")
                                             ),
                                         
                                         # Treatment: Adjacency file load
                                         h3("Adjacency Matrix"),
                                         helpText("Provide square adjacency matrix."),
                                         fileInput("file2.adj", "Choose TAB delimited File",
                                                   multiple = FALSE,
                                                   accept = c("text/tab",
                                                              "text/tab-separated-values,text/plain",
                                                              ".tab")
                                                   ),
                                         # add file button
                                         useShinyjs(),
                                         div(style="display: block;vertical-align:top;margin-top: 1px",
                                             actionButton(inputId = "add.button2.adj", label = "Add!")
                                             )
                                         )
                                     ),
                              ####### STEP 3 ######
                              column(width = 4,
                                     box(title = "STEP3: Gene Set",
                                         status = "warning",
                                         width = NULL,
                                         solidHeader = TRUE,collapsible = TRUE,
                                         helpText("Select Organism"),
                                         uiOutput("choose.organism"),
                                         htmlOutput("num.paths"),
                                         div(style="display: inline-block;vertical-align:top;margin-top: 1px",
                                             radioButtons("paths.radio", "Search against",
                                                          choices = c("All pathways" = 'A',
                                                                      "Single pathway" = "S"),
                                                          selected = "A")    
                                         ),
                                         uiOutput("dropdown.path.radio")
                                     ),
                                     box(title = "STEP4: Bookmark your job",
                                         width = NULL,
                                         solidHeader = TRUE,collapsible = TRUE,
                                         background = "teal",
                                         helpText("Expanet analysis may take days to complete. 
                                                  Press the Bookmark button and save the displayed URL. 
                                                  Access the results of your analysis through this URL."),
                                         div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;"
                                             ,bookmarkButton()
                                             )
                                         )
                                     )
                              )
                    ),
                    #### REFRESH STATUS #####
                    tabItem(tabName = "results",
                            fluidRow(
                              tabBox(
                                title = tagList(shiny::icon("table"), "Results"),
                                # The id lets us use input$tabset1 on the server to find the current tab
                                id = "tabset1", height = "400px",width = 12,
                                tabPanel("Status",height = "100%",
                                         fluidRow(
                                           column(width = 12,
                                                  helpText("The status refreshes automatically every 10 seconds.")
                                                  ),
                                           column(width = 6,
                                                  div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;",
                                                      htmlOutput("header1"),
                                                      infoBoxOutput("controlProgress1")
                                                      )
                                                  ),
                                           column(width = 6,
                                                  div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;",
                                                      htmlOutput("header2"),
                                                      infoBoxOutput("controlProgress2")
                                                      )
                                                  ),
                                           column(width = 12,
                                                  box(width=NULL,
                                                      div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;",
                                                          htmlOutput("statusmsg")
                                                          )
                                                      )
                                                  )
                                           )
                                         ),
                                ##### SCORE MATRIX ######
                                tabPanel("Enriched Pathways",
                                         box(title = "Score Table",status = "info"
                                             ,width=NULL,solidHeader = TRUE,
                                             useShinyjs(),
                                             div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;"
                                                 ,actionButton(inputId = "score.button"
                                                               , label = "Show Table")
                                             ),
                                             # Button
                                             uiOutput("d.button1"),
                                             DT::dataTableOutput("score.table")
                                         )
                                ),
                                ###### PLOT NETS ####
                                tabPanel("Networks",height = "100%",
                                         fluidRow(
                                           column(width = 12,
                                                  div(style="display: inline-block;vertical-align:top; margin-top: 8px;margin-bottom: 8px;width: 100%;"
                                                      ,actionButton(inputId = "gmlplot.button"
                                                                    , label = "Get the list of Pathways")
                                                  ),
                                                  uiOutput("layout")
                                                  ),
                                           column(width = 6,
                                                  uiOutput("graph.box1")
                                           ),
                                           column(width = 6,
                                                  uiOutput("graph.box2")
                                                  )
                                           )
                                         ),
                                ###### DOWNLOAD PANEL #####
                                tabPanel("Download",
                                         useShinyjs(),
                                         div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;"
                                             ,actionButton(inputId = "gml.button"
                                                           , label = "Get the list of Pathways")
                                         ),
                                         htmlOutput("lb1"),
                                         uiOutput("dropdown.gml.C"),
                                         uiOutput("d.button2"),
                                         #helpText("Download pathways in gml format."),
                                         htmlOutput("lb2"),
                                         uiOutput("dropdown.gml.T"),
                                         uiOutput("d.button3")
                                         #helpText("Download pathways in gml format.")
                                )
                              )
                            )
                    ),
                    ### ABOUT PAGE ####
                    tabItem(tabName = "help_page",
                            fluidRow(
                              box(width=12,
                                  tags$h3("Input Tables"),
                                  tags$p("Four matrices must be provided two for each experiment: the transition and the adjacency 
                                          matrices which must be square. Based on the Hidden Markov Model theory, every row of the 
                                          transition matrix must sum up to 1.
                                        "),
                                  tags$h3("Table Format"),
                                  tags$p("Tab delimited files must be provided (.txt or .tab). The tables must not contain 
                                          any non-numeric values whereas the first row and column should contain the proteins/gene names.
                                          For the format of the gene names refer to 'Gene Names' section.
                                          The Expanet web portal interface validates the input files and informs the user of 
                                          potential mistakes.
                                        "),
                                  tags$img(src='about_table_validate.png', align = "center",height="200px"),
                                  tags$h3("Gene Names"),
                                  tags$p("The suported gene names are the ones provided by KEGG. For example in the case of the human proteome (hsa),
                                          the genes/proteins must be repressented by their Entrez gene IDs (e.g. '5595' for MAPK3 protein).
                                          Another example is the Plasmodium proteome (pbe) where the genes/proteins are repressented by 
                                          their gene names (e.g. 'PBANKA_071490','PBANKA_082340'). Tip: use the KEGREST R package to retrieve
                                          the list of proteins names for a selected organism.
                                        "),
                                  tags$h3("Supported organisms and pathways"),
                                  tags$p("Currently only KEGG pathways are supported. The availiable organisms are listed in the table below:"),
                                  tableOutput("supported.organisms"),
                                  tags$h3("Job Submission"),
                                  tags$p("Submit jobs by folowing the step-by-step guide that can be accessed via
                                         the 'Load your data' menu item of the side menu. The steps for job submission are:"),
                                  tags$ol(tags$li("STEP1: Submission of the adjacency and transition matrices of the Control Experiment "),
                                          tags$li("STEP2: Submission of the adjacency and transition matrices of another condition/treatment"),
                                          tags$li("STEP3: Selection of the organism."),
                                          tags$li("STEP4: Bookmarking of the session. This step is required in long running job submissions.")
                                          ),
                                  tags$p("Submit this job by pressing the 'Submit' button on the top. Load an example dataset by pressing
                                         the 'Load Example' button."),
                                  tags$img(src='about_submit.png', align = "center",height="180px"),
                                  tags$p("Keep track of the file submission progress and the already submitted files names by
                                          the progress bars and the summary table on the top."),
                                  tags$img(src='about_progress.png', align = "center",height="150px")
                              )
                              
                            )
                    ),
                    tabItem(tabName = "contact_page",
                            fluidRow(
                              box(width=12,
                                  tags$h4(style="font-weight:bold","Associate Prof. Michalis Aivaliotis"),
                                  box(width=8,
                                      tags$p("Laboratory of Biological Chemistry, Faculty of Health Sciences, 
                                              School of Medicine, Aristotle University of Thessaloniki, Building 16a,
                                              3rd Floor, GR-54124, Thessaloniki, Greece
                                        "),
                                      tags$p("Center for Interdisciplinary Research and Innovation (CIRI-AUTH), 
                                              Balkan Center, Buildings A & B, Thessaloniki, 10th km Thessaloniki-Thermi
                                              Rd, P.O. Box 8318, GR 57001
                                        ")
                                      
                                      ),
                                  box(width=8,
                                      tags$p(style="font-weight:bold","Tel.: +30-2310-999170"),
                                      tags$p(style="font-weight:bold","e-mail: aivaliotis@auth.gr")
                                  ),
                                  box(width=8,
                                      tags$p("Institute of Molecular Biology and Biotechnology-Foundation for Research and 
                                              Technology, Nikolaou Plastira 100, GR-70013, Heraklion Crete, Greece
                                        ")
                                  ),
                                  box(width=8,
                                      tags$p(style="font-weight:bold","Tel.:  +30-2810-391063"),
                                      tags$p(style="font-weight:bold","e-mail: aivaliot@imbb.forth.gr")
                                  )
                                )
                              )
                            )
                    
                  ),
                  tags$style("#controlProgress1 {width:310px;}")
                  ,tags$style("#controlProgress2 {width:310px;}")
                )
  )
  
}

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  shinyjs::hide("submit.button")
  shinyjs::hide("add.button1.adj")
  shinyjs::hide("add.button1.tran")
  shinyjs::hide("add.button2.adj")
  shinyjs::hide("add.button2.tran")
  #kegg.files <- list.files(path = "orgs_gene_sets", pattern = ".[.]R$", full.names = TRUE)
  ######## Reactive Values
  tables <- reactiveValues(C.adj = NULL,T.adj=NULL,C.tm = NULL,T.tm=NULL,
                           paths=NULL,allpaths=NULL,pnames=NULL,
                           C.adj.n = NULL,T.adj.n = NULL,C.tm.n = NULL,T.tm.n = NULL)
  progressValue <- reactiveValues(one=0,two=0,three=0)
  smt<-matrix(nrow = 2,ncol = 2,"")
  colnames(smt)=c("Transition","Adjacency")
  row.names(smt)=c("Control","Treatment")
  progressTable<- reactiveVal(smt)
  ######### LOAD EXAMPLE  #######
  observeEvent(input$load.example,{
    tables$C.adj=load.file("data/control_adj.txt")
    tables$C.tm=load.file("data/control_tm.txt")
    tables$T.adj=load.file("data/N_adj.txt")
    tables$T.tm=load.file("data/N_tm.txt")
    tmp=progressTable()
    tmp[,]=rbind(c("control_tm.txt","control_adj.txt"),c("T_tm.txt","T_adj.txt"))
    progressTable(tmp)
    updateSelectInput(session, "organism",
                      selected = orgs.sel[3,2]
    )
    updateRadioButtons(session, "paths.radio",
                       selected = "S"
    )
    progressValue$one=100
    progressValue$two=100
    shinyjs::disable("paths.radio")
    shinyjs::disable("organism")
    shinyjs::show("submit.button")
  })
  ######### TABLE LOADING ##########
  # Control: Adjacency table
  data1.adj<-eventReactive(input$file1.adj,{
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.
    req(input$file1.adj)
    df=load.file(input$file1.adj$datapath)
    return(df)
  })
  # Control: Transition table
  data1.tran<-eventReactive(input$file1.tran,{
    req(input$file1.tran)
    df=load.file(input$file1.tran$datapath)
    return(df)
  })
  # Treatment: Adjacency table
  data2.adj<-eventReactive(input$file2.adj,{
    req(input$file2.adj)
    df=load.file(input$file2.adj$datapath)
    return(df)
  })
  # Treatment: Transition table
  data2.tran<-eventReactive(input$file2.tran,{
    req(input$file2.tran)
    df=load.file(input$file2.tran$datapath)
    return(df)
  })
  ###### ORGANISM DROP DOWN #####
  load(paste(kegg.folder,"/orgs.R",sep = ""))
  output$supported.organisms <- renderTable({
    orgs.sel
  })
  output$choose.organism <- renderUI({
    selectInput("organism", "Organism", as.list(orgs.sel[,2]))
    
  })
  observeEvent(input$organism,{
    found=which(orgs.sel[,2]==input$organism)
    load(paste(kegg.folder,"/",orgs.sel[found,1],"_names.R",sep = ""))
    load(paste(kegg.folder,"/",orgs.sel[found,1],".R",sep = ""))
    tables$pnames=paths.names
    tables$allpaths=gene.set
    tables$paths=gene.set
    
    output$dropdown.path.radio<- renderUI({
      selectInput("dropdown.path.radio", "Choose pathway:",
                  choices = names(paths.names)
      )
    })
    
    output$num.paths<- renderText({
      paste("<div id=paths>",length(gene.set)," pathways loaded.</div>",sep = "")
    })
  })
  observeEvent({input$paths.radio
                input$dropdown.path.radio},{
    if(input$paths.radio=="A"){
      tables$paths=tables$allpaths
    }else{
      sel.pth=which(   (names(tables$allpaths)== sub("path:","",input$dropdown.path.radio))  ==TRUE)
      tables$paths=tables$allpaths[sel.pth]
      #print(tables$paths)
    }
  })
  ###### VALIDATE INPUTS:STEP 1 ####
  observeEvent(data1.tran(),{
    shinyjs::hide("add.button1.tran")
    v1=valid.table(data1.tran())
    tables$C.tm.n=v1[3]
    valid.table.messages(v1,"[STEP1] Transition","add.button1.tran")
  })
  observeEvent(data1.adj(),{
    shinyjs::hide("add.button1.adj")
    v1=valid.table(data1.adj())
    tables$C.adj.n=v1[3]
    valid.table.messages(v1,"[STEP1] Adjacency","add.button1.adj")
  })
  ###### VALIDATE INPUTS:STEP 2  ####
  observeEvent(data2.tran(),{
    shinyjs::hide("add.button2.tran")
    v1=valid.table(data2.tran())
    tables$T.tm.n=v1[3]
    valid.table.messages(v1,"[STEP2] Transition","add.button2.tran")
  })
  observeEvent(data2.adj(),{
    shinyjs::hide("add.button2.adj")
    v1=valid.table(data2.adj())
    tables$T.adj.n=v1[3]
    valid.table.messages(v1,"[STEP2] Adjacency","add.button2.adj")
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
  ####### SUBMITTED FILES  ####
  output$progresstable<- renderTable({
    progressTable()
  },rownames = TRUE)
  ####### STEP1:ADD INPUT FILES ####
  observeEvent(input$add.button1.tran,{
    tmpt=progressTable()
    tmpt[1,1]=paste(isolate(input$file1.tran)$name,"\n(size: ",tables$C.tm.n,")",sep = "")
    txt="Transition"
    tables$C.tm=data1.tran()
    progressTable(tmpt)
    ####### Notify User
    showNotification(paste(Sys.time(),", [STEP1] ",txt," matrix successfully submitted")
                     , duration = 10,type="message")
    #### show organism selections
    shinyjs::enable("paths.radio")
    shinyjs::enable("organism")
    ###### Monitor submission level
    progressValue$one <- (1- ((is.null(tables$C.tm)+is.null(tables$C.adj))/2) )*100
  })
  observeEvent(input$add.button1.adj,{
    tmpt=progressTable()
    tmpt[1,2]=paste(isolate(input$file1.adj)$name,"\n(size: ",tables$C.adj.n,")",sep = "")
    txt="Adjacency"
    tables$C.adj=data1.adj()
    progressTable(tmpt)
    ####### Notify User
    showNotification(paste(Sys.time(),", [STEP1] ",txt," matrix successfully submitted")
                     , duration = 10,type="message")
    #### show organism selections
    shinyjs::enable("paths.radio")
    shinyjs::enable("organism")
    ###### Monitor submission level
    progressValue$one <- (1- ((is.null(tables$C.tm)+is.null(tables$C.adj))/2) )*100
  })
  ####### STEP2:ADD INPUT FILES ####
  observeEvent(input$add.button2.tran,{
    tmpt=progressTable()
    tmpt[2,1]=paste(isolate(input$file2.tran)$name,"\n(size: ",tables$T.tm.n,")",sep = "")
    txt="Transition"
    tables$T.tm=data2.tran()
    progressTable(tmpt)
    ####### Notify User
    showNotification(paste(Sys.time(),", [STEP2] ",txt," matrix successfully submitted")
                     , duration = 10,type="message")
    #### show organism selections
    shinyjs::enable("paths.radio")
    shinyjs::enable("organism")
    ###### Monitor submission level
    progressValue$two <- (1- ((is.null(tables$T.tm)+is.null(tables$T.adj))/2) )*100
  })
  observeEvent(input$add.button2.adj,{
    tmpt=progressTable()
    tmpt[2,2]=paste(isolate(input$file2.adj)$name,"\n(size: ",tables$T.adj.n,")",sep = "")
    txt="Adjacency"
    tables$T.adj=data2.adj()
    progressTable(tmpt)
    ####### Notify User
    showNotification(paste(Sys.time(),", [STEP2] ",txt," matrix successfully submitted")
                     , duration = 10,type="message")
    #### show organism selections
    shinyjs::enable("paths.radio")
    shinyjs::enable("organism")
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
  ######### EXPANET EXPANSION ######
  expanet.st <- reactiveVal(0)
  expanet.st2 <- reactiveVal(0)
  expanet.fin <- reactiveVal(0)
  observeEvent(input$submit.button,{
    ##### empty results folder
    delete.prev.files()
    write.table("final step started",paste(d1,"/started.txt",sep = ""),sep = "\t")
    showNotification(paste(Sys.time(),"Job successfully submitted!")
                   , duration = 10
                   ,type="message")
    future(exec1(isolate(tables$C.tm),isolate(tables$paths),"C",d1)
    )%...>%   #this part is not actually working
      expanet.st() %...!%  # Assign to data 
      (function(e) {
        expanet.st(0)
        print(e$message)
        write.table(as.character(e$message),file=paste(d1,"/errors.txt",sep = ""),sep = "\t")
        warning(e)
        session$close()
      })
    write.table("final step started",paste(d2,"/started.txt",sep = ""),sep = "\t")
    future(exec1(isolate(tables$T.tm),isolate(tables$paths),"T",d2)
    )%...>%   #this part is not actually working
      expanet.st2() %...!%  # Assign to data 
      (function(e) {
        expanet.st2(0)
        print(e$message)
        write.table(as.character(e$message),file=paste(d2,"/errors.txt",sep = ""),sep = "\t")
        warning(e)
        session$close()
      })
    # Hide the async operation from Shiny by not having the promise be
    # the last expression.
    NULL
  })
  ###### EXPANET ENRICHMENT #######
  autoInvalidate <- reactiveTimer(10000)
  observe({
    # Invalidate and re-execute this reactive expression every time the
    # timer fires.
    autoInvalidate()
    if( file.exists(paste(d1,"/done.txt",sep = "")) & 
        file.exists(paste(d2,"/done.txt",sep = "")) & 
        file.exists(d3)==FALSE &
        file.exists(paste(tf,"/started.txt",sep = ""))==FALSE &
        length(list.files(d1, pattern = ".[.]E$", full.names = TRUE))>0 &
        length(list.files(d2, pattern = ".[.]E$", full.names = TRUE))>0){
      write.table("final step started",paste(tf,"/started.txt",sep = ""),sep = "\t")
      future(exec2(isolate(tables$C.adj),
                   isolate(tables$T.adj),
                   isolate(tables$paths)
      )
      )%...>%   #this part is not actually working
        expanet.fin() %...!%  # Assign to data 
        (function(e) {
          expanet.fin(0)
          print(e$message)
          write.table(as.character(e$message),file=paste(d3,"/errors.txt",sep = ""),sep = "\t")
          warning(e)
          session$close()
        })
    }
    NULL
  })
  ####### REFRESH STATUS  #######
  output$header1<-renderText({
    paste("<h3>",input$label1,"</h3>")
  })
  output$header2<-renderText({
    paste("<h3>",input$label2,"</h3>")
  })
  autoRefreshStatus <- reactiveTimer(10000)
  observe({
    # Invalidate and re-execute this reactive expression every time the
    # timer fires.
    autoRefreshStatus()
    
    output$controlProgress1 <- renderInfoBox({
      E.files <- list.files(d1, pattern = ".[.]E$", full.names = TRUE)
      infoBox(paste("Pathways Expanded"), length(E.files),
              icon = icon("bezier-curve"),
              color = "aqua"
      )
    })
    output$controlProgress2 <- renderInfoBox({
      E.files <- list.files(d2, pattern = ".[.]E$", full.names = TRUE)
      infoBox(paste("Pathways Expanded"), length(E.files),
              icon = icon("bezier-curve"),
              color = "light-blue"
      )
    })
    ## Status message
    output$statusmsg<- renderText({
      paste("<ol>",update.status(isolate(input$label1),isolate(input$label2)),"</ol>",sep = "")
      })
    })
  ###### REACTIVE SCORE TABLE  #####
  observeEvent({input$score.button
               tables$pnames},{
    dirscore=paste(d3,"/scores.csv",sep = "")
    if(file.exists(dirscore)){
      #### read score table
      score.table<-reactiveVal({
        d.score<-read.csv(dirscore,header = TRUE,sep = ",")
        if(ncol(d.score)==1){
          d.score<-t(d.score)
          res=map.path.names(d.score,tables$pnames)
          d.score<-as.data.frame(c(d.score[1:2],res,d.score[3]))
          colnames(d.score)=c("Results")
          row.names(d.score)=c("score","Pathway ID","Pathway Name","Nodes of interest")
        }else{
          res=map.path.names(d.score,tables$pnames)
          d.score<-cbind(d.score[,1:2],res,d.score[,3])
          colnames(d.score)<-c("score","Pathway ID","Pathway Name","Nodes of interest")
        }
        as.data.frame(d.score)
        
      })
      ### Creat view for the score table
      output$score.table<- DT::renderDataTable({
        score.table()
      })
      #### create download button for score table
      output$d.button1<-renderUI({
        downloadButton("downloadScoreTable", "Download")
      })
      # Handler: csv of selected dataset 
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
      output$lb1<-renderText({
        paste(h3(isolate(input$label1)),sep="",collapse = " ")
      })
      output$lb2<-renderText({
        paste(h3(isolate(input$label2)),sep="",collapse = " ")
      })
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
      # box container 1
      output$graph.box1<-renderUI({
        box(title = isolate(input$label1),
            status = "primary",
            width = NULL,
            solidHeader = TRUE,collapsible = TRUE,
            uiOutput("dropdown.gmlplot.C"),
            plotOutput("graph.C")
        )
      })
      output$graph.box2<-renderUI({
        box(title = isolate(input$label2),
            status = "info",
            width = NULL,
            solidHeader = TRUE,collapsible = TRUE,
            #background = "olive",
            uiOutput("dropdown.gmlplot.T"),
            plotOutput("graph.T")
        )
      })
      ### dropdown layout
      output$layout<-renderUI({
        selectInput("layout", "Layout", 
                    c("auto","tree",
                      "Fruchterman-Reingold","Kamada-Kawai")
        )
      })
      
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
    # Handler: csv of selected dataset
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
    # Handler: csv of selected dataset
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
    ###### GRAPHS VIS CONTROL #####
    observeEvent({input$layout
      gmlplot.C()},{
        output$graph.C<-net.plot(gmlplot.C(),input$layout)
      })
  })
  observeEvent(input$dropdown.gmlplot.T,{
    gmlplot.T<-reactiveVal({
      read_graph(paste(d2,"/graphs/",input$dropdown.gmlplot.T,sep = ""), format = c("gml"))
    })
    ###### GRAPHS VIS TREATMENT #####
    observeEvent({input$layout
      gmlplot.T()},{
        output$graph.T<-net.plot(gmlplot.T(),input$layout)
      })
  })
  
   
}

# Run the application 
shinyApp(ui = ui, server = server,enableBookmarking = "server")

