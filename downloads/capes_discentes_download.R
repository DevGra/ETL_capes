
url <- 'https://dadosabertos.capes.gov.br/group/avaliacao-da-pos-graduacao'
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

links_down <- c("https://dadosabertos.capes.gov.br/dataset/dc2568b7-20b0-4d92-980d-dcf2485b5517/resource/89bcb419-5a11-46a1-804e-e9df8e4e6097/download/br-capes-colsucup-discentes-2013a2016-2017-12-02_2013.csv",
                "https://dadosabertos.capes.gov.br/dataset/dc2568b7-20b0-4d92-980d-dcf2485b5517/resource/3aa223ba-9c60-421a-91af-48ed843a9a98/download/br-capes-colsucup-discentes-2013a2016-2017-12-02_2014.csv",
                "https://dadosabertos.capes.gov.br/dataset/dc2568b7-20b0-4d92-980d-dcf2485b5517/resource/08e7765f-cd76-4c7b-a29a-46e216dd79cf/download/br-capes-colsucup-discentes-2013a2016-2017-12-02_2015.csv",
                "https://dadosabertos.capes.gov.br/dataset/dc2568b7-20b0-4d92-980d-dcf2485b5517/resource/cfbcb060-d6af-4c34-baa7-16ef259273f7/download/br-capes-colsucup-discentes-2013a2016-2017-12-02_2016.csv",
                 "https://dadosabertos.capes.gov.br/dataset/b7003093-4fab-4b88-b0fa-b7d8df0bcb77/resource/2207af02-21f6-466e-a690-46f26a2804d6/download/ddi-br-capes-colsucup-discentes-2017-2018-07-01.csv")

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
  
  if (identical(string_link[grep('discentes', string_link)], character(0)) == FALSE) {
    dir_temp <- paste(dir_current, 'discentes', sep = '/')
    out_dir <- file.path(dir_temp)
  }
  

  if (!dir.exists(out_dir)) {
    dir.create(out_dir, showWarnings = TRUE, recursive = TRUE, mode = "0777")
  }
  
  name_file <- paste('capes',year_scrap,'.csv', sep = '')
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


