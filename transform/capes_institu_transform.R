
setwd("C:/Users/cgt/Documents/carlos/capes_R/transform/instituicoes")
dir_institu <- getwd()


# percorre todo diretorio por arquivos xlsx e gera uma lista dos encontrados, recursive FALSE - le o diretorio atual,
# se recursive TRUE - percorre os subdiretorios tbm
#list_folder_content <- list.files(recursive = FALSE, pattern = "xlsx$")

instituicoes <- read.csv2("instituicoes.csv")
#outro <- read.xlsx("Cadastro_Instituicoes_Capes_2017.xlsx")

# corrigindo os valores em branco da variavel DS_ORGANIZACAO_ACADEMICA_CAPES
preenche_vazia <- c("NÃO INFORMADO")
levels(instituicoes$DS_ORGANIZACAO_ACADEMICA_CAPES)[1] <- preenche_vazia


write.csv2(instituicoes, "temp/df_institu_final.csv", row.names = FALSE)
df_select <- read.csv2("temp/df_institu_final.csv", sep = ";", header = TRUE)

# --------------------------  teste para verificar linhas em branco e extraí-las ------------------------
teste <- instituicoes
lv <- levels(factor(teste$DS_ORGANIZACAO_ACADEMICA_CAPES)) # verifica se existe linhas em branco
ex <- subset(teste, DS_ORGANIZACAO_ACADEMICA_CAPES == lv[1]) # seleciona as linhas que estão vazias
out <- subset(teste, DS_ORGANIZACAO_ACADEMICA_CAPES != lv[1]) # seleciona as linhas que não estão vazias
out <- subset(teste, DS_ORGANIZACAO_ACADEMICA_CAPES != "") # outra maneira de selecionar as linhas que não estão vazias
y[y == ""] <- "Não Aplicado" # atribuir um valor a um campo vazio, y <- c(10,"", 5, 10, "", 6)
x[is.na(x)] = mean(x,na.rm = TRUE) # substituir os NAS, df de teste, x <- c(10, 5, 5, 10, NA, NA) 

# ------------------------------------- fim teste --------------------------------------------------------