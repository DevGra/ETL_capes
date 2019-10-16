diretorio_capes <- "C:/Users/cgt/Documents/carlos/capes_R"
setwd(diretorio_capes)
getwd()
source("capes_librarys.R", echo = FALSE, print.eval = FALSE)
# ------------------------- librarys utilizadas -------------------------------------------------


# -----------------------------------------------------------------------------------------------

## salvar o gráfico 1 na pasta Modelo_1
#jpeg("../grafico_1")

#Se você quiser ver todos os comandos e resultados use:
#source("regressao.r", echo=TRUE, print.eval=TRUE)

#example("apropos")
#demo("graphics")

args <- commandArgs(trailingOnly = TRUE)

collection <- function(name_collection) {
  comment(collection) <- "funcao que recebe o nome da collection para download. 
                          e chama a funcao especifica desta collection para isso"
  
  
  coll <- name_collection
  
  if (coll == "capes") {
    teste <- "Sim"
    teste
    source("/downloads/capes_discentes_download.R")
    
  }else{
    teste <- "Nao"
    teste
  }
  
}

tryCatch(
  
  {
    collection(args[1])
  },
  
  error = function(error_message) {
    message(error("----------------- ERRO ---------------------------------"))
    message("Passar o nome da collection. Ex: Rscript download.R inep")
    
  }
)

collection_escolhida <- readline(prompt = "DIGITE A COLLECTION QUE DESEJA BAIXAR: ") 
coll <- str_to_lower(as.character(collection_escolhida))
collection(coll)


