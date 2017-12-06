library(rvest)
library(dplyr)

GetImageURL <- function(name) {
  name <- gsub(" ", "+", name)
  url <- paste0("https://www.google.com/search?q=", name, "&tbm=isch")
  page <- read_html(url)
  node <- html_nodes(page, xpath = '//img')
  src <- html_attr(node[[1]], "src")
  return(src)
}