
setwd("C:/Users/cgt/Documents/carlos/capes_R/export")
dir_export <- getwd()

prog <- read.csv2("../transform/programas/temp/df_prog_final.csv")
inst <- read.csv2("../transform/instituicoes/temp/df_institu_final.csv")

# TRATAMENTO DOS CAMPOS ANTES DO MERGE
# corrigindo o nome da entidade de ensino, nos anos inferiores a 2017 estão com um nome, em 2017, está com outro
prog$NM_ENTIDADE_ENSINO[prog$NM_ENTIDADE_ENSINO == "FUNDACAO OSWALDO CRUZ"] <- "FUNDACAO OSWALDO CRUZ (FIOCRUZ)"
# acrescentando as duas vairavei para o merge, ja que discentes não tem as variaveis como o nome capes.
colnames(prog)[colnames(prog) == "SG_ENTIDADE_ENSINO"] <- "SG_ENTIDADE_ENSINO_CAPES"
colnames(prog)[colnames(prog) == "NM_ENTIDADE_ENSINO"] <- "NM_ENTIDADE_ENSINO_CAPES"


# excluir as variaveis de instituicoes para não gerar duplicidade, ex: in_rede_x, in_rede_y
cols_not_use_inst <- c("AN_BASE", "DS_DEPENDENCIA_ADMINISTRATIVA", "CS_STATUS_JURIDICO")
inst <- inst[, !names(inst) %in% cols_not_use_inst, drop = F]

df_merged <- merge(x = prog, y = inst, by = c("SG_ENTIDADE_ENSINO_CAPES", "NM_ENTIDADE_ENSINO_CAPES"))
write.csv2(df_merged, "programas/programas.csv" ,row.names = FALSE)
