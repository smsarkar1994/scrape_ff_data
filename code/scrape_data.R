rm(list = ls())
library(tidyverse)
library(rvest)
library(httr)

#point_type is either Standard, Half-PPR, or PPR. If an invalid value, 
#it will automatically return Half-PPR data.
get_data <- function(week_start, week_end, year, point_type = "") {

  if (point_type == "Standard") {
    point_type = ""
    point_type_name = "Standard"
  } else if (point_type == "PPR") {
    point_type = "ppr.php"
    point_type_name = "PPR"
  } else {
    point_type = "half-ppr.php"
    point_type_name = "Half-PPR"
  }
  
  print(paste0("Scoring format = ", point_type_name))
  
  fantasy_data <- data.frame()
  for (i in week_start:week_end) {
    print(paste0("Scraping week ", i))
    week = i
    url <- glue::glue("https://www.fantasypros.com/nfl/reports/leaders/{point_type}?year={year}&start={week}&end={week}")
    
    tmp <- read_html(url) %>%
      html_table()
    tmp <- tmp[[1]]
    tmp$week = i
    
    fantasy_data <- bind_rows(fantasy_data, tmp)
    
    Sys.sleep(1)
  }
  
  
  return(fantasy_data)
}

test <- get_data(1, 2, 2021, "PPR")

