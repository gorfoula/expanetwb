library("shiny")
library(shinydashboard)
library(shinyjs)
library("promises")
#library("dplyr")
library("future")
library(igraph)
library(DT)
source("auxiliary_funcs.R")
# path containing all files, including ui.R and server.R
#setwd("/path/to/my/shiny/app/dir")   

plan(multiprocess)

kegg.folder<<-"orgs_gene_sets"
res.folder<<-"data/output"
temp.name<<-strsplit(tempfile("res", fileext = c("")),split = "/")[[1]][4]
tf<<-paste(res.folder,"/",temp.name,sep = "")
d1<<-paste(tf,"/C",sep = "")
d2<<-paste(tf,"/T",sep = "")
d3<<-paste(tf,"/CVST",sep = "")

print(tf)
print(d1)
print(d2)
print(d3)

dir.create(d1,recursive = TRUE)
dir.create(d2,recursive = TRUE)
Sys.chmod(tf,'777',F)
Sys.chmod(d1,'777',F)
Sys.chmod(d2,'777',F)

print(tf)

#enableBookmarking(store = "server")