suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(rvest))
suppressPackageStartupMessages(library(rlist))

SOK1005 <-"https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1005-1&week=1-20&View=list"

SOK1006 <- "https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1006-1&week=1-20&View=list"

SOK1016 <- "https://timeplan.uit.no/emne_timeplan.php?sem=22v&module%5B%5D=SOK-1016-1&week=1-20&View=list"


url_liste <- list(SOK1005, SOK1006, SOK1016)


scrape <- function(url)
{
  page <- read_html(url)
  
  table <- html_nodes(page, 'table') 
  table <- html_table(table, fill=TRUE) 
  
  df <- list.stack(table)
  
  colnames(df) <- df[1,]
  
  df <- df %>% filter(!Dato=="Dato")
  df$Dato[df$Dato == " " ] <- NA
  df$Dato <- na.locf(dframe$Dato)
  df <- df %>% separate(Dato, 
                        into = c("Dag", "Dato"), 
                        sep = "(?<=[A-Za-z])(?=[0-9])")
  
  df$Dato <- as.Date(df$Dato, format="%d.%m.%Y")
  df$Uke <- strftime(df$Dato, format = "%V")
  df <- df %>% select(Dag,Dato,Uke,Tid,Rom)
  
return(df)
  
}


Timeplan <- map(url_liste, scrape)
Timeplan <- bind_rows(Timeplan)

Timeplan
