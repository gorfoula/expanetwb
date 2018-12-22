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
                  column(width = 5,
                         box(title = "Load your data",status = "primary",
                             width = NULL,
                             solidHeader = TRUE,
                             collapsible = TRUE,
                             helpText("Provide square transition and adjacency matrices."),
                             fileInput("file1", "Choose CSV File",
                                       multiple = FALSE,
                                       accept = c("text/csv",
                                                  "text/comma-separated-values,text/plain",".csv")),
                             checkboxInput("header", "Header", TRUE),
                             # Input: Select separator ----
                             div(style="display: inline-block;vertical-align:top;margin-top: 1px;margin-right: 20px",
                                 radioButtons("sep", "Separator",
                                              choices = c(Comma = ",",
                                                          Semicolon = ";",
                                                          Tab = "\t"),
                                              selected = ",")
                             ),
                             div(style="display: inline-block;vertical-align:top;margin-top: 1px;",
                                 # Input: Select quotes ----
                                 radioButtons("quote", "Quote",
                                              choices = c(None = "",
                                                          "Double Quote" = '"',
                                                          "Single Quote" = "'"),
                                              selected = "")
                             ),
                             helpText("Provide an experiment name."),
                             textInput("label", "Label",value = "Control"),
                             helpText("Specify the type of experiment/matrix"),
                             div(style="display: inline-block;vertical-align:top;margin-top: 1px;margin-right: 30px",
                                 radioButtons("experiment", "Experiment type",
                                              choices = c("Control" = 'C',
                                                          "Treatment" = "T"),
                                              selected = "C")
                             ),
                             div(style="display: inline-block;vertical-align:top;margin-top: 1px",
                                 radioButtons("matrix", "Matrix type",
                                              choices = c("Transition" = "T",
                                                          "Adjacency" = 'A'),
                                              selected = "T")   
                             ),
                             useShinyjs(),
                             div(style="display: block;vertical-align:top;margin-top: 1px",
                                 actionButton(inputId = "add.button", label = "Add!")
                             )   
                         )
                  ),
                  column(width = 7,
                         box(title = "File Contents",status = "success",
                             width = NULL,
                             dataTableOutput(outputId = "contents")
                             #textOutput("msgerror")
                         ),
                         box(title = "Analyze data with Expanet"
                             ,status = "info",
                             width = NULL,
                             solidHeader = TRUE,collapsible = TRUE,
                             valueBoxOutput("approvalBox"),
                             useShinyjs(),
                             div(style="display: inline-block;vertical-align:top; margin-top: 8px;width: 100%;",actionButton(inputId = "submit.button", label = "Submit"))
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
