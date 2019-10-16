
setwd("C:/Users/cgt/Documents/carlos/capes_R/downloads/discentes")
dir_discent <- getwd()

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

# plan2013 <- read.xlsx(list_folder_content[1], colNames = TRUE)
# plan2014 <- read.xlsx(list_folder_content[2], colNames = TRUE)
# plan2015 <- read.xlsx(list_folder_content[3], colNames = TRUE)
# plan2016 <- read.xlsx(list_folder_content[4], colNames = TRUE)
# plan2017 <- read.xlsx(list_folder_content[5], colNames = TRUE)

df_discent_ate_2016 <- data.frame()
# o ano de 2017 tem variaveis que nao estao presentes nos anos de 2013 a 2016: TP_RACA_DISCENTE, IN_DEFICIENCIA, NM_ORIENTADOR_PRINCIPAL 
df_discent_2017 <- data.frame() 

for (file in list_folder_content) {
  print(file)
  # para obter o ano, corta a string na posicao inicial 6 ate a final 9
  ano_capes <- substr(file, 6, 9)
  if ( ano_capes == "2017") {
    df_discent_2017 <- read.csv2(file)
    print(nrow(df_discent_2017))
    write.csv2(df_discent_2017, "../temp/df_2017.csv", row.names = FALSE)
    
  }else {
    df_loop <- read.csv2(file)
    print(nrow(df_loop))
    df_discent_ate_2016 <- rbind(df_discent_ate_2016, df_loop)
    # com rbind.fill, as colunas faltantes são preenchidas, pois, o ano de 2017 tem colunas q nao constam nos outros anos
    #df_discent_ate_2016 <- rbind.fill(df_discent_ate_2016, df_loop)
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

total_obs <- nrow(df_discent_ate_2016) + nrow(df_discent_2017)

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
write.csv2(df_discent_ate_2016, "../temp/df_ate_2016_concat.csv", row.names = FALSE)

require(ffbase) #Carrega o pacote, biblioteca otimizada para trabalhar com grandes bases
library("ff")
# para dar permissão de acesso a ffdf, pois, precisa gravar arqs temporarios
options(fftempdir = "C:/Users/cgt/Documents/carlos/capes_R/downloads/temp") 
#x <- read.csv.ffdf(file = "file.csv", header = TRUE, VERBOSE = TRUE, first.rows = 10000, next.rows = 50000, colClasses = NA)

# - lendo os arquivos gravados parcialmente, dessa forma, melhora a performance de excução do script
#df_discents <- read.csv2.ffdf(file = "../temp/df_ate-2016_concat.xlsx", sep = "|", first.rows = 1000000)
df_discents <- read.csv2.ffdf(file = "../temp/df_ate_2016_concat.csv", header = TRUE, VERBOSE = TRUE, first.rows = 5000, next.rows = 30000)
save.ffdf(df_discents, dir = "C:/Users/cgt/Documents/carlos/capes_R/downloads/temp/backup/df_discents", overwrite = TRUE)
load.ffdf(dir = "C:/Users/cgt/Documents/carlos/capes_R/downloads/temp/backup/df_discents" )
df_discent_2017 <- read.csv2.ffdf(file = "../temp/df_2017.csv", header = TRUE, VERBOSE = TRUE, first.rows = 5000, next.rows = 30000)
save.ffdf(df_discent_2017, dir = "C:/Users/cgt/Documents/carlos/capes_R/downloads/temp/backup/df_discent_2017", overwrite = TRUE)
load.ffdf(dir = "C:/Users/cgt/Documents/carlos/capes_R/downloads/temp/backup/df_discent_2017")

# --- diferenca entre os anos de 2017 e de 2013 a 2016 - pq houve uma atualizacao do banco de dados da capes
dif_ate_2016 <- setdiff(colnames(df_discents), colnames(df_discent_2017))
dif_2017 <- setdiff(colnames(df_discent_2017), colnames(df_discents))

#----- renomeando a coluna NM_ORIENTADOR que sofreu uma mudança de nome em 2017, NM_ORIENTADO_PRINCIPAL
#setnames(x, old, new)
names(df_discent_2017)[names(df_discent_2017) == "NM_ORIENTADOR_PRINCIPAL"] <- "NM_ORIENTADOR"
#setnames(df_discent_2017, "NM_ORIENTADOR_PRINCIPAL", "NM_ORIENTADOR")

# ------ acrescentando duas variaveis nos anos de 2013 a 2016, TP_RACA_DISCENTE e IN_DEFICIENCIA
df_discents$TP_RACA_DISCENTE <- as.ff(rep(NA, nrow(df_discents)))
df_discents$IN_DEFICIENCIA <- as.ff(rep(NA, nrow(df_discents)))

# convertendo os objetos ffdf em data frame para ordena-los
dis2016 <- as.data.frame(df_discents)
dis2017 <- as.data.frame(df_discent_2017)

# ordenando as colunas do data.frame para concatena-los
#df <- df[,order(colnames(df),decreasing=TRUE)]
dis2016 <- dis2016[, order(colnames(dis2016), decreasing = FALSE)]
names(dis2016)
dis2017 <- dis2017[, order(colnames(dis2017), decreasing = FALSE)]
names(dis2017)

# --- concatenando os anos de 2013-2016 e 2017
df_concat <- rbind(dis2016, dis2017)
str(df_concat)

# ----------- TRANSFORMANDOS OS DADOS ----------------------------------
df_select <- subset(df_concat, select = c("AN_BASE", "ID_PESSOA", "NM_SITUACAO_DISCENTE", "ST_INGRESSANTE", "DS_GRAU_ACADEMICO_DISCENTE",
                                                    "DT_SITUACAO_DISCENTE", "DT_MATRICULA_DISCENTE","QT_MES_TITULACAO", "TP_SEXO_DISCENTE",
                                                    "DS_FAIXA_ETARIA", "DS_TIPO_NACIONALIDADE_DISCENTE", "NM_PAIS_NACIONALIDADE_DISCENTE",
                                                    "SG_ENTIDADE_ENSINO", "NM_ENTIDADE_ENSINO", "CS_STATUS_JURIDICO", "DS_DEPENDENCIA_ADMINISTRATIVA",
                                                    "NM_REGIAO", "SG_UF_PROGRAMA", "NM_MUNICIPIO_PROGRAMA_IES", "CD_PROGRAMA_IES", "NM_PROGRAMA_IES",
                                                    "NM_GRANDE_AREA_CONHECIMENTO", "NM_AREA_AVALIACAO", "CD_CONCEITO_PROGRAMA", "CD_CONCEITO_CURSO",
                                                    "NM_MODALIDADE_PROGRAMA", "NM_GRAU_PROGRAMA", "NM_TESE_DISSERTACAO", "NM_ORIENTADOR"))


write.csv2(df_select, "C:/Users/cgt/Documents/carlos/capes_R/downloads/discentes/df_select_parcial.csv", row.names = FALSE)
df_select <- read.csv2("C:/Users/cgt/Documents/carlos/capes_R/downloads/discentes/df_select_parcial.csv", sep = ";", header = TRUE)

df_select$DT_SITUACAO_DISCENTE <- sapply(df_select$DT_SITUACAO_DISCENTE, convert_date)
df_select$DT_MATRICULA_DISCENTE <- sapply(df_select$DT_MATRICULA_DISCENTE, convert_date)

# como a conversao de data é muito demorada, gravamos novamente
write.csv2(df_select, "C:/Users/cgt/Documents/carlos/capes_R/transform/discentes/temp/df_discentes_final.csv", row.names = FALSE)
df_select <- read.csv2("C:/Users/cgt/Documents/carlos/capes_R/transform/discentes/temp/df_discentes_final.csv", sep = ";", header = TRUE)



for (i in 1:10) {
  cat("\014")        ## I clear the screen 
  cat(paste0('a',i)) ## progress message in the first coin of the console.
  Sys.sleep(0.5)
}
















