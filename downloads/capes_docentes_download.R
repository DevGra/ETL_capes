library(stringr)
url <- "https://dadosabertos.capes.gov.br/organization/a994a478-5aaf-4e09-8372-134a0af7c0e8?groups=docentes"
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

links_down <- c("https://dadosabertos.capes.gov.br/dataset/35eab2f8-5a64-4619-b3f1-63a2e6690cfa/resource/3f5c3276-ff3a-496c-9250-b2cf87879e1f/download/br-capes-colsucup-docente-2013a2016-2017-12-02_2013.csv",
                "https://dadosabertos.capes.gov.br/dataset/35eab2f8-5a64-4619-b3f1-63a2e6690cfa/resource/0bd87bca-8202-4404-8628-73c92f29721d/download/br-capes-colsucup-docente-2013a2016-2017-12-02_2014.csv",
                "https://dadosabertos.capes.gov.br/dataset/35eab2f8-5a64-4619-b3f1-63a2e6690cfa/resource/75eea9d5-1542-4cfd-8ed9-d540d3eef344/download/br-capes-colsucup-docente-2013a2016-2017-12-02_2015.csv",
                "https://dadosabertos.capes.gov.br/dataset/35eab2f8-5a64-4619-b3f1-63a2e6690cfa/resource/922bc0d1-90eb-4939-9167-03831f732f72/download/br-capes-colsucup-docente-2013a2016-2017-12-02_2016.csv",
                "https://dadosabertos.capes.gov.br/dataset/57f86b23-e751-4834-8537-e9d33bd608b6/resource/d918d02e-7180-4c7c-be73-980f9a8c09b5/download/br-capes-colsucup-docente-2017-2018-08-10.csv"
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
  
  if (identical(string_link[grep('docentes', string_link)], character(0)) == FALSE) {
    dir_temp <- paste(dir_current, 'docentes', sep = '/')
    out_dir <- file.path(dir_temp)
  }
  
  
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, showWarnings = TRUE, recursive = TRUE, mode = "0777")
  }
  
  name_file <- paste('doc',year_scrap,'.csv', sep = '')
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


