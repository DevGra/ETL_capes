
setwd("C:/Users/cgt/Documents/carlos/capes_R/export")
dir_export <- getwd()

disc <- read.csv2("../transform/discentes/temp/df_discentes_final.csv")
prog <- read.csv2("../transform/programas/temp/df_prog_final.csv")
inst <- read.csv2("../transform/instituicoes/temp/df_institu_final.csv")

# TRATAMENTO DOS CAMPOS ANTES DO MERGE
# corrigindo o nome da entidade de ensino, nos anos inferiores a 2017 estão com um nome, em 2017, está com outro
disc$NM_ENTIDADE_ENSINO[disc$NM_ENTIDADE_ENSINO == "FUNDACAO OSWALDO CRUZ"] <- "FUNDACAO OSWALDO CRUZ (FIOCRUZ)"
# acrescentando as duas vairavei para o merge, ja que discentes não tem as variaveis como o nome capes.
colnames(disc)[colnames(disc) == "SG_ENTIDADE_ENSINO"] <- "SG_ENTIDADE_ENSINO_CAPES"
colnames(disc)[colnames(disc) == "NM_ENTIDADE_ENSINO"] <- "NM_ENTIDADE_ENSINO_CAPES"

# excluir as variaveis de programas para não gerar duplicidade em discentes, ex: coluna_x, coluna_y
cols_not_use_prog <- c('NM_GRANDE_AREA_CONHECIMENTO','CD_AREA_AVALIACAO',
             'NM_AREA_AVALIACAO', 'SG_ENTIDADE_ENSINO', 'NM_ENTIDADE_ENSINO', 'CS_STATUS_JURIDICO',
             'DS_DEPENDENCIA_ADMINISTRATIVA','NM_REGIAO', 'NM_MUNICIPIO_PROGRAMA_IES', 'NM_MODALIDADE_PROGRAMA',
             'NM_PROGRAMA_IES', 'SG_UF_PROGRAMA', 'NM_GRAU_PROGRAMA', 'CD_CONCEITO_PROGRAMA')

prog <- prog[, !names(prog) %in% cols_not_use_prog, drop = F]

df_disc_prog <- merge(x = disc, y = prog, by = c("AN_BASE", "CD_PROGRAMA_IES"))

# normalizando os nomes das variaveis em instituiçoes
names(inst) <- c("AN_BASE","SG_ENTIDADE_ENSINO_CAPES", "NM_ENTIDADE_ENSINO_CAPES", "CD_INST_GEI", "SG_INST_GEI", "NM_INST_GEI",
                 "CD_TIPO_INSTITUICAO", "NM_TIPO_INSTITUICAO", "CS_STATUS_JURIDICO", "DS_DEPENDENCIA_ADMINISTRATIVA", "CD_NATUREZA_JURIDICA_GEI", 
                 "NM_NATUREZA_JURIDICA_GEI", "CD_ORGANIZACAO_ACADEMICA_GEI", "DS_ORGANIZACAO_ACADEMICA_GEI", "DS_ORGANIZACAO_ACADEMICA_CAPES", 
                 "CD_MANTENEDORA", "NM_MANTENEDORA")

# excluir as variaveis de instituicoes para não gerar duplicidade, ex: in_rede_x, in_rede_y
cols_not_use_inst <- c('AN_BASE', 'DS_DEPENDENCIA_ADMINISTRATIVA', 'CS_STATUS_JURIDICO')
inst <- inst[, !names(inst) %in% cols_not_use_inst, drop = F]

df_merged <- merge(x = df_disc_prog, y = inst, by = c("SG_ENTIDADE_ENSINO_CAPES", "NM_ENTIDADE_ENSINO_CAPES"))
write.csv2(df_merged, "discentes/discentes.csv" ,row.names = FALSE)
