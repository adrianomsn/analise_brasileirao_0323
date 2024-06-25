# Limpa o ambiente
rm(list = ls())

# Carrega/instala conjuto de pacotes que geralmente utilizo
pacotes = c(
  "tidyverse", "readxl", "dplyr", "stringr", "xgboost",
  "wooldridge", "lmtest", "faraway", "stargazer", "randomForest",
  "ggplot2", "tseries", "car", "corrplot", "PerformanceAnalytics", 
  "caret", "rmarkdown", "glmnet", "neuralnet", "e1071", "gbm", "rpart",
  "httr", "jsonlite", "data.table", "basedosdados"
)


# Instala pacotes que ainda não estão instalados
for (x in pacotes) {
  if (!x %in% installed.packages()) {
    install.packages(x, repos = "http://cran.us.r-project.org")
  }
}

# Carrega os pacotes
lapply(pacotes, require, character.only = TRUE)
rm(pacotes, x)


# --------------------------- Importando dados -------------------------------- #

# define o caminho da base em .csv
file_path <- "C:/Users/super/Downloads/brasileirao_serie_a.csv/brasileirao_serie_a.csv"

# Carrega a base em .csv
data <- fread(file_path)




# ----------------- tratanddo os dados para carregar no SQL ---------------------#


## tratando valores VAZIOS ##

# Função para substituir vazio por NA 
substitui_vazio <- function(coluna) {
  ifelse(trimws(coluna) == "", NA, coluna)
}

# Aplica a funcao para a base inteira
data <- data %>%
  mutate_if(names(.) != "data", substitui_vazio)

# Converte para data frame novamente
data <- as.data.frame(data)


# Substitui NA's conforme o tipo de dado da coluna
data <- data %>%
  mutate(across(where(is.character), ~replace_na(., 'Sem Informação')))# %>%
#  mutate(across(where(is.numeric), ~replace_na(., 0)))

# Troca 'NA' por NULL
data[is.na(data)] <- "NULL"

# Verifica se a alteracao foi corretamente
head(data)

# conta o valor de entradas nao nula na variavel
contagem <- sum(!is.na(data$tecnico_mandante) & data$tecnico_mandante != "")

# 8170 que é a quantidadde de observacoes da base entao tudo ok
summary( data)


# Checa a classe de cada variavel
sapply(data, class)

# Salvar o CSV processado
processed_file_path <- "C:/Users/super/Downloads/brasileirao_serie_a.csv/brasileirao_tratado.csv"
write_csv(data, processed_file_path)


#### pensando em rodar uma regressao para prever gols ou publico

# Passo 2: Verificar se Existem Valores NA, NaN ou Inf
summary(data)
sapply(data, function(x) sum(is.na(x)))

# Passo 3: Tratar os Valores NA
# Remover linhas com valores NA nas colunas relevantes
dados_selecionados <- subset(data, select = c(
  publico,
  ano_campeonato,
  rodada,
  time_mandante,
  time_visitante,
  colocacao_mandante,
  colocacao_visitante,
  valor_equipe_titular_mandante,
  valor_equipe_titular_visitante,
  idade_media_titular_mandante,
  idade_media_titular_visitante
))

# Remover linhas com valores NA nas variáveis selecionadas
dados_selecionados <- na.omit(dados_selecionados)

# Verificar se ainda existem valores NA
sapply(dados_selecionados, function(x) sum(is.na(x)))

# Passo 4: Criar o Modelo de Regressão Linear
modelo <- lm(publico ~ ano_campeonato + rodada + time_mandante + time_visitante + 
               colocacao_mandante + colocacao_visitante + 
               valor_equipe_titular_mandante + valor_equipe_titular_visitante + 
               idade_media_titular_mandante + idade_media_titular_visitante, 
             data = dados_selecionados)
# Passo 4: Avaliar o Modelo
summary(modelo)

# Visualizar os resultados do modelo
par(mfrow = c(2, 2))
plot(modelo)

# Plota os resultados em tabela
stargazer(modelo, title = "Resultados da Regressão", column.labels = "modelo", align = T, type = "text")


# Passo 5: Fazer Previsões
# Exemplo de novos dados para previsão
novos_dados <- data.frame(
  ano_campeonato = 2024,
  rodada = 38,
  estadio = "Estádio São Januário",
  arbitro = "Raphael Claus",
  time_mandante = "Vasco da Gama",
  time_visitante = "Flamengo",
  tecnico_mandante = "Ramón Díaz",
  tecnico_visitante = "Tite",
  colocacao_mandante = 15,
  colocacao_visitante = 1,
  valor_equipe_titular_mandante = 8470,
  valor_equipe_titular_visitante = 3760,
  idade_media_titular_mandante = 26.1,
  idade_media_titular_visitante = 26.2
)

# Fazer a previsão
previsao_publico <- predict(modelo, novos_dados)
print(previsao_publico)





