library(lubridate)
library(rvest)
library(tidyverse)

#' Carrega os dados referentes à precificação da soja
#' no Brasil entre o período mais recente e o ano anterior

load_data <- function() {
  
  final_date <- Sys.Date() %>% format("%d/%m/%Y")
  
  initial_interval <- dmy(final_date) - years(1)
  
  initial_date <- initial_interval %>% format("%d/%m/%Y")
  
  base_url <- "https://www.cepea.esalq.usp.br/br/consultas-ao-banco-de-dados-do-site.aspx?tabela_id=92&data_inicial={initial_date}&periodicidade=1&data_final={final_date}"
  
  page_url <- str_glue(base_url)
  
  download_file_url <- read_html(page_url) %>%
    html_element("body") %>%
    html_text2() %>%
    jsonlite::fromJSON(simplifyDataFrame = TRUE) %>%
    tidyr::as_tibble() %>%
    pull(arquivo) 
  
  temp_file <- tempfile()
  
  download_file_url %>% download.file(destfile = temp_file, method = "curl")
  
  return(temp_file)
}




