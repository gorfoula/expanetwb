library(expanet)
prgoressBar <- function(value = 0, label = FALSE, color = "aqua", size = NULL,
                        striped = FALSE, active = FALSE, vertical = FALSE) {
  stopifnot(is.numeric(value))
  if (value < 0 || value > 100)
    stop("'value' should be in the range from 0 to 100.", call. = FALSE)
  if (!(color %in% shinydashboard:::validColors || color %in% shinydashboard:::validStatuses))
    stop("'color' should be a valid status or color.", call. = FALSE)
  if (!is.null(size))
    size <- match.arg(size, c("sm", "xs", "xxs"))
  text_value <- paste0(value, "%")
  if (vertical)
    style <- htmltools::css(height = text_value, `min-height` = "2em")
  else
    style <- htmltools::css(width = text_value, `min-width` = "2em")
  tags$div(
    class = "progress",
    class = if (!is.null(size)) paste0("progress-", size),
    class = if (vertical) "vertical",
    class = if (active) "active",
    tags$div(
      class = "progress-bar",
      class = paste0("progress-bar-", color),
      class = if (striped) "progress-bar-striped",
      style = style,
      role = "progressbar",
      `aria-valuenow` = value,
      `aria-valuemin` = 0,
      `aria-valuemax` = 100,
      tags$span(class = if (!label) "sr-only", text_value)
    )
  )
}

progressGroup <- function(text, value, min = 0, max = value, color = "aqua") {
  stopifnot(is.character(text))
  stopifnot(is.numeric(value))
  if (value < min || value > max)
    stop(sprintf("'value' should be in the range from %d to %d.", min, max), call. = FALSE)
  tags$div(
    class = "progress-group",
    tags$span(class = "progress-text", text),
    tags$span(class = "progress-number", sprintf("%d / %d", value, max)),
    prgoressBar(round(value / max * 100), color = color, size = "sm")
  )
}
map.path.names<-function(score.table,pnames){
  npaths=nrow(score.table)
  res<-matrix(nrow = npaths,ncol = 1,"")
  if(is.null(pnames)==FALSE){
    for (k in 1:npaths) {
      cn=paste("path:",score.table[k,2],sep = "")
      res[k]<-pnames[cn]
    }
  }
  
  return(res)
  
}
load.file<-function(file){
  tryCatch(
    {
      #print(file)
      df <- read.delim(file,
                       header = TRUE,
                       sep = "\t",
                       quote = "")
    },
    error = function(e) {
      # return a safeError if a parsing error occurs
      stop(safeError(e))
    }
  )
  
  if(ncol(df)>2 & nrow(df)==length(unique(df[,1])) ){# unsolved problem with sigle column matrices
    row.names(df)=df[,1]
    df=df[,(2:ncol(df))]
  }
  return(df)
}
valid.table <- function(df) {
  d.size=dim(df)
  content.numeric<-sapply(df, is.numeric)
  indx=which(content.numeric==FALSE)
  res=c( (d.size[1]==d.size[2]),
         length(indx)==0,
         d.size[1],
         d.size[2],
         paste(indx,collapse=",")
  )
  return(res)
}
valid.tm.table <- function(df) {
  res=1
  s=rowSums(df)
  indx=which((s==1)==FALSE)
  if(length(indx)>0){res=0}
  return(res)
}
valid.table.messages <- function(v1,steptxt,btn) {
  c.msgs=c(paste("The table is not square. #Rows:",v1[3],
                 " #Columns: ",v1[4],".",sep = ""),
           paste("The table contains non numeric values at columns: ",
                 v1[5],".",sep = "")
  )
  if(v1[1]=="TRUE" & v1[2]=="TRUE"){
    showNotification(paste(Sys.time(),", ",steptxt," matrix looks ok!")
                     , duration = 10
                     ,type="message")
    shinyjs::show(btn)
  }else{
    c.msgs.string=paste(c.msgs[v1[1:2]=="FALSE"],
                        collapse=" ")
    showNotification(paste(Sys.time(),", ",steptxt," ",c.msgs.string)
                     , duration = 15
                     ,type="error")
    shinyjs::hide(btn)
  }
}

exec1 <- function(tm,gse,lbl,out.dir) {
  runExpanet( treatment.label = lbl,
              treatment.tm    = tm,
              results.dir     = out.dir,
              gsc             = gse,
              l.of.walk       = 50,
              verbose         = FALSE,
              n.cores         = 2,
              exeC            = "./expanet/Cexec/lkwalk"
  )
  write.table("done",paste(out.dir,"/done.txt",sep = ""),sep = "\t")
  return(1)
}
exec2 <- function(C.adj,T.adj,gse) {
  analyzeExpanet( data.dir = tf,
                  control.label = "C",
                  treatment.label = "T", 
                  control.adj = C.adj, 
                  treatment.adj = T.adj,
                  gene.set = gse,
                  threshold = 0.0001,
                  build.graphs = TRUE,
                  save.results = TRUE
  )
  write.table("done",paste(d3,"/done.txt",sep = ""),sep = "\t")
  return(1)
}

net.plot <- function(g,lat) {
  
  #g<-read_graph("data/output/control/graphs/pbe04146_Peroxisome.gml", format = c("gml"))
  
  cls=rep("grey80",1,length(V(g)))
  soi=which(vertex_attr(g,"issoi")==1)
  cls[soi]="skyblue1"
  
  lbs_cols=rep("grey80",1,length(V(g)))
  lbs_cols[soi]="black"
  
  return(
    renderPlot({
      par(mar=c(0,0,0,0))
      switch(lat,
             "tree" = igraph::plot.igraph(g, layout=layout_as_tree,vertex.color = as.vector(cls),
                                          label.color="red", vertex.size=5, vertex.label.dist=1.5,
                                          vertex.label.family="Calibri",vertex.label.cex=0.8,
                                          vertex.label.color=lbs_cols,vertex.label.font=2),
             "auto" = igraph::plot.igraph(g, layout=layout_nicely,vertex.color = as.vector(cls),
                                          label.color="red", vertex.size=5, vertex.label.dist=1.5,
                                          vertex.label.family="Calibri",vertex.label.cex=0.8,
                                          vertex.label.color=lbs_cols,vertex.label.font=2),
             "Fruchterman-Reingold" = igraph::plot.igraph(g, layout=layout_with_fr,vertex.color = as.vector(cls),
                                                          label.color="red", vertex.size=5, vertex.label.dist=1.5,
                                                          vertex.label.family="Calibri",vertex.label.cex=0.8,
                                                          vertex.label.color=lbs_cols,vertex.label.font=2),
             "Kamada-Kawai"=igraph::plot.igraph(g, layout=layout_with_kk,vertex.color = as.vector(cls),
                                                label.color="red", vertex.size=5, vertex.label.dist=1.5,
                                                vertex.label.family="Calibri",vertex.label.cex=0.8,
                                                vertex.label.color=lbs_cols,vertex.label.font=2)
             )#
    })
  )
}

update.status <- function(lb1,lb2) {
  txt=vector()
  txt[1]<-status.expansion(d1,lb1)
  txt[2]<-status.expansion(d2,lb2)
  
  if(file.exists(paste(tf,"/started.txt",sep = ""))){
    txt[3]<-paste("<li><h4>Pathway Enrichment Analysis is <b>in progress</b>.</h4></li>")
    if(file.exists(paste(d3,"/done.txt",sep = ""))){
      txt[3]<-paste("<li><h4>Pathway Enrichment Analysis has been <b>completed</b>.</h4></li>")
    }else if(file.exists(paste(d3,"/errors.txt",sep = ""))){
      txt[3]<-paste("<li><h4>Pathway Enrichment Analysis: ",
                    "<font id=paths>errors</font> have occured during the analysis.</h4></li>")
    }
  }else{
    txt[3]<-paste("<li><h4>Pathway Enrichment Analysis has not started yet.</h4></li>")
  }
  return(paste(txt,sep = "",collapse = " "))
}
status.expansion <- function(d,lb) {
  if(file.exists(paste(d,"/started.txt",sep = ""))){
    if(file.exists(paste(d,"/done.txt",sep = ""))){
      txt<-paste("<li><h4>Network Expansion for: [",lb,"] has been <b>completed</b></h4></li>")
    }else{
      if(file.exists(paste(d,"/errors.txt",sep = ""))){
        txt<-paste("<li><h4>Network Expansion for: [",lb,
                   "] <font id=paths>errors</font> have occured during the analysis.</h4></li>")
      }else{
        txt<-paste("<li><h4>Network Expansion for: [",lb,"] is in progress.</h4></li>")
      }
    }
  }else{
    txt<-paste("<li><h4>Network Expansion for: [",lb,"] has not started yet.</h4></li>")
  }
  return(txt)
}

delete.prev.files <- function(variables) {
  if( file.exists(paste(d1,"/started.txt",sep = "")) ){
    system(paste("rm ",d1,"/*.*",sep=""))
    if(file.exists(paste(d1,"/graphs",sep = ""))){
      ### delete graphs
      system(paste("rm ",d1,"/graphs/*.*",sep=""))
    }
  }
  if( file.exists(paste(d2,"/started.txt",sep = "")) ){
    system(paste("rm ",d2,"/*.*",sep=""))
    if(file.exists(paste(d2,"/graphs",sep = ""))){
      ### delete graphs
      system(paste("rm ",d2,"/graphs/*.*",sep=""))
    }
  }
  if( file.exists(d3) ){
    system(paste("rm ",d3,"/*.*",sep=""))
  }
}