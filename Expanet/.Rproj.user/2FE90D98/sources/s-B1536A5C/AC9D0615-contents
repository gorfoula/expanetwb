#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

#library(shiny)
library(shinydashboard)
library(shinyjs)

# Define UI for application that draws a histogram
title<-tags$a(href="www.google.gr",tags$img(src='Expanet_logo.png',height='40',width='160')) 
shinyUI(
  
  dashboardPage(skin = "black",
    dashboardHeader(title = title, titleWidth = 200),
    dashboardSidebar(
      sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                        label = "Search..."),
      sidebarMenu(id = "sidebar",
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
                         box(title = "PROGRESS",status = "success",
                             width = NULL,
                             #p(strong("Goal Completion"), class = "text-center"),
                             uiOutput(outputId = "progressOne"),
                             uiOutput(outputId = "progressTwo"),
                             uiOutput(outputId = "progressThree"),
                             useShinyjs(),
                             div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;"
                                 ,actionButton(inputId = "submit.button"
                                               , label = "Submit")
                             ),
                             div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;"
                                 ,bookmarkButton()
                             )
                             )
                         )
                  ),
                fluidRow(
                  column(width = 4,
                         box(title = "STEP1: control experiment",
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
                                              choices = c("Transition" = "T",
                                                          "Adjacency" = 'A'),
                                              selected = "T")   
                             ),
                             useShinyjs(),
                             div(style="display: block;vertical-align:top;margin-top: 1px",
                                 actionButton(inputId = "add.button1", label = "Add!")
                             )
                             
                         )
                  ),
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
                                              choices = c("Transition" = "T",
                                                          "Adjacency" = 'A'),
                                              selected = "T")   
                             ),
                             useShinyjs(),
                             div(style="display: block;vertical-align:top;margin-top: 1px",
                                 actionButton(inputId = "add.button2", label = "Add!")
                                 )
                             )
                         )
                  ,
                  column(width = 4,
                         box(title = "STEP3: Gene Set",
                             status = "warning",
                             width = NULL,
                             solidHeader = TRUE,collapsible = TRUE,
                             helpText("Provide a gene set matrix. Fist column the name of the pathway. Second column contains the list of genes names in a comma separated format."),
                             fileInput("file3", "Choose CSV File",
                                       multiple = FALSE,
                                       accept = c("text/csv",
                                                  "text/comma-separated-values,text/plain",
                                                  ".csv")
                             ),
                             useShinyjs(),
                             div(style="display: block;vertical-align:top;margin-top: 1px",
                                 actionButton(inputId = "add.button3", label = "Add!")
                                 )
                             )
                         )
                  )
        ),
        tabItem(tabName = "results",
                fluidRow(
                  box(title = "Results page",status = "info"
                      ,width=12,solidHeader = TRUE
                      
                  ),
                  box(title = "Sum",status = "success",width=12,solidHeader = TRUE
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
        
      )
    )
  )

)
