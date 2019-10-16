
setwd("C:/Users/cgt/Documents/carlos/capes_R/downloads/programas")
dir_prog <- getwd()

# executa as librarys em capes_librarys.R

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

df_prog_ate_2016 <- data.frame()
# o ano de 2017 tem variaveis que nao estao presentes nos anos de 2013 a 2016: TP_RACA_DISCENTE, IN_DEFICIENCIA, NM_ORIENTADOR_PRINCIPAL 
df_prog_2017 <- data.frame() 

for (file in list_folder_content) {
  print(file)
  # para obter o ano, corta a string na posicao inicial 6 ate a final 9
  ano_prog <- substr(file, 5, 8)
  if ( ano_prog == "2017") {
    df_prog_2017 <- read.csv2(file)
    drop <- c("NM_AREA_BASICA") # exclui do ano de 2017 por não corresponder aos anos anteriores e não ser usado.
    df_prog_2017 = df_prog_2017[,!(names(df_prog_2017) %in% drop)]
    print(nrow(df_prog_2017))
    print(ncol(df_prog_2017))
    
    dir_temp <- paste(dir_prog, 'temp', sep = '/')
    out_dir <- file.path(dir_temp)
    if (!dir.exists(out_dir)) {
      dir.create(out_dir, showWarnings = TRUE, recursive = TRUE, mode = "0777")
    }
    write.csv2(df_prog_2017, "temp/df_prog_2017.csv", row.names = FALSE)
    
  }else {
    df_loop <- read.csv2(file)
    drop <- c("DS_CLIENTELA_QUADRIENAL_2017") # excluido por não corresponder e não ser usado
    df_loop = df_loop[,!(names(df_loop) %in% drop)]
    
    df_prog_ate_2016 <- rbind(df_prog_ate_2016, df_loop)
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

total_obs <- nrow(df_prog_ate_2016) + nrow(df_prog_2017)

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
write.csv2(df_prog_ate_2016, "temp/df_ate_2016_concat.csv", row.names = FALSE)

require(ffbase) #Carrega o pacote, biblioteca otimizada para trabalhar com grandes bases
library("ff")
# para dar permissão de acesso a ffdf, pois, precisa gravar arqs temporarios
options(fftempdir = "C:/Users/cgt/Documents/carlos/capes_R/downloads/temp") 
#x <- read.csv.ffdf(file = "file.csv", header = TRUE, VERBOSE = TRUE, first.rows = 10000, next.rows = 50000, colClasses = NA)

# - lendo os arquivos gravados parcialmente, dessa forma, melhora a performance de excução do script
#df_docentes <- read.csv2.ffdf(file = "../temp/df_ate-2016_concat.xlsx", sep = "|", first.rows = 1000000)
df_prog <- read.csv2.ffdf(file = "temp/df_ate_2016_concat.csv", header = TRUE, VERBOSE = TRUE, first.rows = 5000, next.rows = 30000)
save.ffdf(df_prog, dir = "temp/backup/df_prog", overwrite = TRUE)
load.ffdf(dir = "temp/backup/df_prog" )
df_prog_2017 <- read.csv2.ffdf(file = "temp/df_prog_2017.csv", header = TRUE, VERBOSE = TRUE, first.rows = 5000, next.rows = 30000)
save.ffdf(df_prog_2017, dir = "temp/backup/df_prog_2017", overwrite = TRUE)
load.ffdf(dir = "temp/backup/df_prog_2017")

# --- diferenca entre os anos de 2017 e de 2013 a 2016 - pq houve uma atualizacao do banco de dados da capes
setdiff(colnames(df_prog), colnames(df_prog_2017))
setdiff(colnames(df_prog_2017), colnames(df_prog))


# convertendo os objetos ffdf em data frame para ordena-los
dis2016 <- as.data.frame(df_prog)
dis2017 <- as.data.frame(df_prog_2017)

# --- concatenando os anos de 2013-2016 e 2017
df_concat <- rbind(dis2016, dis2017)
str(df_concat)

# ----------- TRANSFORMANDOS OS DADOS ----------------------------------
df_select <- subset(df_concat, select = c("AN_BASE", "CD_PROGRAMA_IES", "NM_PROGRAMA_IES", "NM_PROGRAMA_IDIOMA", "DS_SITUACAO_PROGRAMA", "DT_SITUACAO_PROGRAMA", 
                                          "NM_MODALIDADE_PROGRAMA", "NM_GRAU_PROGRAMA", "IN_REDE", "SG_ENTIDADE_ENSINO_REDE", "ANO_INICIO_PROGRAMA", "AN_INICIO_CURSO", 
                                          "CD_AREA_AVALIACAO", "NM_AREA_AVALIACAO", "CD_CONCEITO_PROGRAMA", "NM_GRANDE_AREA_CONHECIMENTO", "NM_AREA_CONHECIMENTO", 
                                          "NM_SUBAREA_CONHECIMENTO","NM_ESPECIALIDADE", "SG_ENTIDADE_ENSINO", "NM_ENTIDADE_ENSINO", "CS_STATUS_JURIDICO", 
                                          "DS_DEPENDENCIA_ADMINISTRATIVA", "DS_ORGANIZACAO_ACADEMICA", "NM_REGIAO", "SG_UF_PROGRAMA", "NM_MUNICIPIO_PROGRAMA_IES"
                                          ))
view(df_select)

df_select['DT_SITUACAO_PROGRAMA'] <- sapply(df_select$DT_SITUACAO_PROGRAMA, convert_date)

write.csv2(df_select, "C:/Users/cgt/Documents/carlos/capes_R/transform/programas/temp/df_prog_final.csv", row.names = FALSE)
df_select <- read.csv2("C:/Users/cgt/Documents/carlos/capes_R/transform/programas/temp/df_prog_final.csv", sep = ";", header = TRUE)







