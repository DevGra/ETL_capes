
setwd("C:/Users/cgt/Documents/carlos/capes_R/downloads/docentes")
dir_docente <- getwd()

library(magrittr)
library(stringr)
library(tibble)
library(lubridate)
library(dplyr)
library(plyr)
library(data.table)
library(openxlsx)

convert_date <- function(data) {
  data <- as.character(data) # 26MAR2010:00:00:00
  data <- strsplit(data, ":") # '26MAR2010' '00' '00' '00'
  data_extract <- data[[1]][1] # '26MAR2010'
  day_extract <- substr(data_extract, 1, 2)
  month_extract <- substr(data_extract, 3, 5)
  year_extract <- substr(data_extract, 6, 9)
  data_join <- c(day_extract, month_extract, year_extract) # '26' 'MAR' '2010'
  month <- c("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC")
  month_number <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")
  correct_date <- plyr::mapvalues(data_join, month, month_number, warn_missing = FALSE) # '26' '03' '2010'
  if (length(correct_date) == 3) {
    correct_date <- paste(correct_date[1],correct_date[2], correct_date[3], sep = "/") # '26/03/2010'
  }
  return(correct_date)
}

print(convert_date("25SEP2009:00:00:00"))


# percorre todo diretorio por arquivos xlsx e gera uma lista dos encontrados, recursive FALSE - le o diretorio atual,
# se recursive TRUE - percorre os subdiretorios tbm
#list_folder_content <- list.files(recursive = FALSE, pattern = "xlsx$")

list_folder_content <- list.files(recursive = FALSE, pattern = "csv$")

# plan2013 <- read.csv2(list_folder_content[1], header = TRUE, sep = ';')
# plan2014 <- read.csv2(list_folder_content[2], header = TRUE, sep = ';')
# plan2015 <- read.csv2(list_folder_content[3], header = TRUE, sep = ';')
# plan2016 <- read.csv2(list_folder_content[4], header = TRUE, sep = ';')
# plan2017 <- read.csv2(list_folder_content[5], header = TRUE, sep = ';')

df_docente_ate_2016 <- data.frame()
# o ano de 2017 tem variaveis que nao estao presentes nos anos de 2013 a 2016: TP_RACA_DISCENTE, IN_DEFICIENCIA, NM_ORIENTADOR_PRINCIPAL 
df_docente_2017 <- data.frame() 

for (file in list_folder_content) {
  print(file)
  # para obter o ano, corta a string na posicao inicial 6 ate a final 9
  ano_capes <- substr(file, 4, 7)
  if ( ano_capes == "2017") {
    df_docente_2017 <- read.csv2(file)
    print(nrow(df_docente_2017))
    
    dir_temp <- paste(dir_docente, 'temp', sep = '/')
    out_dir <- file.path(dir_temp)
    if (!dir.exists(out_dir)) {
      dir.create(out_dir, showWarnings = TRUE, recursive = TRUE, mode = "0777")
    }
    write.csv2(df_docente_2017, "temp/df_doc_2017.csv", row.names = FALSE)
    
  }else {
    df_loop <- read.csv2(file)
    print(nrow(df_loop))
    drop <- c("DS_CLIENTELA_QUADRIENAL_2017")
    df_loop = df_loop[,!(names(df_loop) %in% drop)]
    df_docente_ate_2016 <- rbind(df_docente_ate_2016, df_loop)
    # com rbind.fill, as colunas faltantes são preenchidas, pois, o ano de 2017 tem colunas q nao constam nos outros anos
    #df_docente_ate_2016 <- rbind.fill(df_docente_ate_2016, df_loop)
  }
  
}



# ----- numero de obaservaçoes em csv  = 1.555.738
# "capes2013.csv"
#300210
# "capes2014.csv"
#317846
# "capes2015.csv"
#204861
# "capes2016.csv"
#357353
# "capes2017.csv"
#375468

total_obs <- nrow(df_docente_ate_2016) + nrow(df_docente_2017)

# ----- numero de obaservaçoes em xlsx = 1.688.912
# "capes2013.xlsx"
#300210
# "capes2014.xlsx"
#317846
# "capes2015.xlsx"
#338035
# "capes2016.xlsx"
#357353
# "capes2017.xlsx"
#375468

# - gravando um arquivo csv parcial com as mudanças acima
write.csv2(df_docente_ate_2016, "temp/df_ate_2016_concat.csv", row.names = FALSE)

require(ffbase) #Carrega o pacote, biblioteca otimizada para trabalhar com grandes bases
library("ff")
# para dar permissão de acesso a ffdf, pois, precisa gravar arqs temporarios
options(fftempdir = "C:/Users/cgt/Documents/carlos/capes_R/downloads/temp") 
#x <- read.csv.ffdf(file = "file.csv", header = TRUE, VERBOSE = TRUE, first.rows = 10000, next.rows = 50000, colClasses = NA)

# - lendo os arquivos gravados parcialmente, dessa forma, melhora a performance de excução do script
#df_docentes <- read.csv2.ffdf(file = "../temp/df_ate-2016_concat.xlsx", sep = "|", first.rows = 1000000)
df_docentes <- read.csv2.ffdf(file = "temp/df_ate_2016_concat.csv", header = TRUE, VERBOSE = TRUE, first.rows = 5000, next.rows = 30000)
save.ffdf(df_docentes, dir = "temp/backup/df_docentes", overwrite = TRUE)
load.ffdf(dir = "temp/backup/df_docentes" )
df_docente_2017 <- read.csv2.ffdf(file = "temp/df_doc_2017.csv", header = TRUE, VERBOSE = TRUE, first.rows = 5000, next.rows = 30000)
save.ffdf(df_docente_2017, dir = "temp/backup/df_docente_2017", overwrite = TRUE)
load.ffdf(dir = "temp/backup/df_docente_2017")

# --- diferenca entre os anos de 2017 e de 2013 a 2016 - pq houve uma atualizacao do banco de dados da capes
setdiff(colnames(df_docentes), colnames(df_docente_2017))
setdiff(colnames(df_docente_2017), colnames(df_docentes))


# convertendo os objetos ffdf em data frame para ordena-los
dis2016 <- as.data.frame(df_docentes)
dis2017 <- as.data.frame(df_docente_2017)

# --- concatenando os anos de 2013-2016 e 2017
df_concat <- rbind(dis2016, dis2017)
str(df_concat)

# ----------- TRANSFORMANDOS OS DADOS ----------------------------------
df_select <- subset(df_concat, select = c("AN_BASE", "ID_PESSOA", "TP_SEXO_DOCENTE", "DS_FAIXA_ETARIA", "DS_TIPO_NACIONALIDADE_DOCENTE",
                                          "NM_PAIS_NACIONALIDADE_DOCENTE", "DS_CATEGORIA_DOCENTE", "IN_DOUTOR", "CD_CAT_BOLSA_PRODUTIVIDADE",
                                          "DS_TIPO_VINCULO_DOCENTE_IES", "DS_REGIME_TRABALHO", "NM_GRAU_TITULACAO", "CD_AREA_BASICA_TITULACAO",
                                          "NM_AREA_BASICA_TITULACAO", "SG_IES_TITULACAO", "NM_IES_TITULACAO", "NM_PAIS_IES_TITULACAO", "AN_TITULACAO",
                                          "SG_ENTIDADE_ENSINO", "NM_ENTIDADE_ENSINO", "CS_STATUS_JURIDICO", "DS_DEPENDENCIA_ADMINISTRATIVA", "NM_REGIAO",
                                          "SG_UF_PROGRAMA", "NM_MUNICIPIO_PROGRAMA_IES", "CD_PROGRAMA_IES", "NM_PROGRAMA_IES", "NM_GRANDE_AREA_CONHECIMENTO",
                                          "NM_AREA_CONHECIMENTO", "CD_AREA_AVALIACAO", "NM_AREA_AVALIACAO", "CD_CONCEITO_PROGRAMA", "NM_MODALIDADE_PROGRAMA",
                                          "NM_GRAU_PROGRAMA"
                                         ))


write.csv2(df_select, "C:/Users/cgt/Documents/carlos/capes_R/transform/docentes/temp/df_doc_final.csv", row.names = FALSE)
df_select <- read.csv2("C:/Users/cgt/Documents/carlos/capes_R/transform/docentes/temp/df_doc_final.csv", sep = ";", header = TRUE)







