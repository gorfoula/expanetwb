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
load.file<-function(file){
  tryCatch(
    {
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
  if(ncol(df)>2){
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