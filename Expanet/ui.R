#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

#library(shiny)
#library(shinydashboard)
#library(shinyjs)

# Define UI for application that draws a histogram
title<-tags$a(href="www.google.gr",tags$img(src='Expanet_logo.png',height='40',width='160')) 
shinyUI(
  
  dashboardPage(skin = "black",
    dashboardHeader(title = title, titleWidth = 200),
    dashboardSidebar(
      sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                        label = "Search..."),
      sidebarMenu(id = "sidebar",
                  ###### SIDE MENU ####
                  menuItem("Load your data", tabName = "dselection", icon = icon("database")),
                  menuItem("Results", tabName = "results", icon = icon("database")),
                  menuItem("About", tabName = "help_page", icon = icon("database")),
                  menuItem("Examples",tabName = "example_page",icon = icon("book"))
                  #menuItemOutput("menu.quant"),
      )
    ),
    dashboardBody(
      tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "app.css")),
      tabItems(
        tabItem(tabName = "dselection",
                fluidRow(
                  column(width = 6,
                         box(title = "File Submission",status = "success",
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
                             tableOutput("progresstable")
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
                             helpText("Provide square transition and adjacency matrices."),
                             fileInput("file1", "Choose CSV File",
                                       multiple = FALSE,
                                       accept = c("text/csv",
                                                  "text/comma-separated-values,text/plain",
                                                  ".csv")
                                       ),
                             helpText("Provide an experiment name."),
                             textInput("label1", "Label",value = "Control"),
                             helpText("Specify the type of matrix you want to submit"),
                             div(style="display: inline-block;vertical-align:top;margin-top: 1px",
                                 radioButtons("matrix.step1", "Matrix type",
                                              choices = c("Adjacency" = 'A',
                                                          "Transition" = "T"),
                                              selected = "A")    
                             ),
                             useShinyjs(),
                             div(style="display: block;vertical-align:top;margin-top: 1px",
                                 actionButton(inputId = "add.button1", label = "Add!")
                             )
                             
                         )
                  ),
                  ####### STEP 2 ######
                  column(width = 4,
                         box(title = "STEP2: Treatment Experiment",
                             status = "info",
                             width = NULL,
                             solidHeader = TRUE,collapsible = TRUE,
                             helpText("Provide square transition and adjacency matrices."),
                             fileInput("file2", "Choose CSV File",
                                       multiple = FALSE,
                                       accept = c("text/csv",
                                                  "text/comma-separated-values,text/plain",
                                                  ".csv")
                             ),
                             helpText("Provide an experiment name."),
                             textInput("label2", "Label",value = "Treated"),
                             helpText("Specify the type of matrix you want to submit"),
                             div(style="display: inline-block;vertical-align:top;margin-top: 1px",
                                 radioButtons("matrix.step2", "Matrix type",
                                              choices = c("Adjacency" = 'A',
                                                          "Transition" = "T"),
                                              selected = "A")   
                             ),
                             useShinyjs(),
                             div(style="display: block;vertical-align:top;margin-top: 1px",
                                 actionButton(inputId = "add.button2", label = "Add!")
                                 )
                             )
                         )
                  ,
                  ####### STEP 3 ######
                  column(width = 4,
                         box(title = "STEP3: Gene Set",
                             status = "warning",
                             width = NULL,
                             solidHeader = TRUE,collapsible = TRUE,
                             helpText("Select Organism"),
                             uiOutput("choose.organism"),
                             textOutput("num.paths")
                             ),
                         box(title = "STEP4: Submit your Job",
                             width = NULL,
                             solidHeader = TRUE,collapsible = TRUE,
                             background = "olive",
                             useShinyjs(),
                             div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;"
                                 ,actionButton(inputId = "submit.button"
                                               , label = "Submit")
                                 )
                             ),
                         box(title = "STEP5: Bookmark your job",
                             width = NULL,
                             solidHeader = TRUE,collapsible = TRUE,
                             background = "teal",
                             helpText("Expanet analysis might take days to complete. Press the Bookmark button and save the displayed url. Use this url to monitor the progress of the analysis."),
                             div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;"
                                 ,bookmarkButton()
                                 )
                             )
                         )
                  )
        ),
        #### RESULTS TAB#####
        tabItem(tabName = "results",
                fluidRow(
                  tabBox(
                    title = tagList(shiny::icon("table"), "Results"),
                    # The id lets us use input$tabset1 on the server to find the current tab
                    id = "tabset1", height = "400px",width = 12,
                    tabPanel("Status",
                             box(title = "Monitor the status of the analysis.",status = "info"
                                 ,width=NULL,solidHeader = TRUE,
                                 div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;"
                                     ,actionButton(inputId = "status.button"
                                                   , label = "Check Status")
                                     ),
                                 div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;"
                                     ,htmlOutput("header1"),
                                     infoBoxOutput("controlProgress1")
                                     ),
                                 div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;"
                                     ,htmlOutput("header2"),
                                     infoBoxOutput("controlProgress2")
                                 ),
                                 div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;"
                                     ,
                                     htmlOutput("statusmsg")
                                     )
                                 )
                             ),
                    ##### SCORE MATRIX #######s
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
                                 dataTableOutput("score.table")
                                 )
                             ),
                    ###### PLOT NETS ####
                    tabPanel("Networks",
                             div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;"
                                 ,actionButton(inputId = "gmlplot.button"
                                               , label = "Get the list of Pathways")
                             ),
                             selectInput("layout", "Layout", 
                                         c("auto","tree",
                                           "Fruchterman-Reingold","Kamada-Kawai")
                             ),
                             column(width = 6,
                                    box(title = "Control",
                                        status = "primary",
                                        width = NULL,
                                        solidHeader = TRUE,collapsible = TRUE,
                                        uiOutput("dropdown.gmlplot.C"),
                                        plotOutput("graph.C")
                                        )
                                    ),
                             column(width = 6,
                                    box(title = "Treatment",
                                        status = "info",
                                        width = NULL,
                                        solidHeader = TRUE,collapsible = TRUE,
                                        #background = "olive",
                                        uiOutput("dropdown.gmlplot.T"),
                                        plotOutput("graph.T")
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
                             uiOutput("d.button2"),
                             uiOutput("dropdown.gml.C"),
                             #helpText("Download pathways in gml format."),
                             uiOutput("d.button3"),
                             uiOutput("dropdown.gml.T")
                             #helpText("Download pathways in gml format.")
                             )
                    )
                  )
        ),
        tabItem(tabName = "help_page",
                fluidRow(
                  h2("About Expanet")
                  
                )
        ),
        tabItem(tabName = "example_page",
                fluidRow(
                  h2("Example Results")
                  
                )
        )
        
      ),tags$style("#controlProgress1 {width:350px;}")
      ,tags$style("#controlProgress2 {width:350px;}")
    )
  )

)
