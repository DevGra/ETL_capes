library(stringr)
url <- "https://dadosabertos.capes.gov.br/dataset?groups=programas-pos-graduacao"
setwd('C:/Users/cgt/Documents/carlos/capes_R/downloads')
dir_current <- getwd()

#html <- read_html(url)

# classes <- html %>%
#   html_nodes('div') %>%
#   html_nodes("[class='list-download--two-columns-programs anchor__content']")
#   
#classes
# retitando apenas o atribute href dos links 
# data_anchor_cens_educ_sup <- classes[1] %>%
#   html_node(".list-download__content") %>%
#   html_node("ul") %>%
#   html_nodes("a") %>%
#   html_attr("href")

links_down <- c("https://dadosabertos.capes.gov.br/dataset/122620f6-47dc-4363-9d63-130c8a386af6/resource/7de14e9c-9739-43d9-8217-ba9bf837b411/download/br-capes-colsucup-prog-2013a2016-2017-12-02_2013.csv",
                "https://dadosabertos.capes.gov.br/dataset/122620f6-47dc-4363-9d63-130c8a386af6/resource/a0c1760a-4130-49b7-b1fd-849ca189417b/download/br-capes-colsucup-prog-2013a2016-2017-12-02_2014.csv",
                "https://dadosabertos.capes.gov.br/dataset/122620f6-47dc-4363-9d63-130c8a386af6/resource/3c16cfcf-0614-4497-a3d4-324c0788fe2e/download/br-capes-colsucup-prog-2013a2016-2017-12-02_2015.csv",
                "https://dadosabertos.capes.gov.br/dataset/122620f6-47dc-4363-9d63-130c8a386af6/resource/bc2fb7a9-8313-4959-abee-14764d812e8b/download/br-capes-colsucup-prog-2013a2016-2017-12-02_2016.csv",
                "https://dadosabertos.capes.gov.br/dataset/903b4215-ea91-4927-8975-d1484891374f/resource/8b3464e2-9108-4855-bc5b-2df474fdf152/download/br-capes-colsucup-prog-2017-2018-08-01.csv"
                )

length_list <- length(links_down)
dir_down <- ''
year_scrap <- ''
out_dir <- ''
i <- 1
while (i <= length_list) {
  
  year_scrap <- str_sub(str_sub(links_down[i], -9), 2, 5)
  #dir_down_for_inep <- sprintf("%s",paste(DOWNLOAD_DIR, 'inep_download',links$ano[i], 'inep.zip', sep='/'))
  #dir_down <- sprintf("%s",paste('capes_discentes', year_scrap, sep = '/'))
  
  if (i > 4) {
    year_scrap <- str_sub(str_sub(links_down[i], -20), 2, 5)
    #dir_down <- sprintf("%s",paste('capes_discentes', year_scrap, sep = '/'))
  }
  
  string_link <- links_down[i]
  
  if (identical(string_link[grep('prog', string_link)], character(0)) == FALSE) {
    dir_temp <- paste(dir_current, 'programas', sep = '/')
    out_dir <- file.path(dir_temp)
  }
  
  
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, showWarnings = TRUE, recursive = TRUE, mode = "0777")
  }
  
  name_file <- paste('prog',year_scrap,'.csv', sep = '')
  #download(links$link[i], dest = out_dir, mode = "wb")
  #download(links_down[i], dest = sprintf("%s",paste(out_dir, name_file, sep = '/')) , mode = "wb")
  download(links_down[i], dest = sprintf("%s",paste(out_dir, name_file, sep = '/')) , mode = "wb")
  
  # descompacta o zip 
  #unzip(zipfile = sprintf("%s",paste(out_dir,'capes.xlsx', sep = '/')), exdir = out_dir)
  
  # para remover o arquivo baixado
  #file_to_remove <- sprintf("%s",paste(out_dir,'capes.xlsx', sep = '/'))
  #unlink(file_to_remove)
  
  i <- i + 1
  
}
