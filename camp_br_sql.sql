CREATE TABLE brasileirao_tratado (
    ano_campeonato INT NOT NULL,
    data DATE NOT NULL,
    rodada INT NOT NULL,
    estadio VARCHAR(255) NOT NULL,
    arbitro VARCHAR(255) NOT NULL,
    publico INT,
    publico_max INT,
    time_mandante VARCHAR(255) NOT NULL,
    time_visitante VARCHAR(255) NOT NULL,
    tecnico_mandante VARCHAR(255) NOT NULL,
    tecnico_visitante VARCHAR(255) NOT NULL,
    colocacao_mandante INT,
    colocacao_visitante INT,
    valor_equipe_titular_mandante INT,
    valor_equipe_titular_visitante INT,
    idade_media_titular_mandante DECIMAL(5,2),
    idade_media_titular_visitante DECIMAL(5,2),
    gols_mandante INT,
    gols_visitante INT,
    gols_1_tempo_mandante INT,
    gols_1_tempo_visitante INT,
    escanteios_mandante INT,
    escanteios_visitante INT,
    faltas_mandante INT,
    faltas_visitante INT,
    chutes_bola_parada_mandante INT,
    chutes_bola_parada_visitante INT,
    defesas_mandante INT,
    defesas_visitante INT,
    impedimentos_mandante INT,
    impedimentos_visitante INT,
    chutes_mandante INT,
    chutes_visitante INT,
    chutes_fora_mandante INT,
    chutes_fora_visitante INT
);


-- #  IMPORTA OS DADOS OBTIDOS NO PROCESSO DE ETL
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/brasileirao_tratado.csv'
INTO TABLE brasileirao_tratado
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ano_campeonato, data, rodada, estadio, arbitro, publico, publico_max, time_mandante, time_visitante, 
 tecnico_mandante, tecnico_visitante, colocacao_mandante, colocacao_visitante, 
 valor_equipe_titular_mandante, valor_equipe_titular_visitante, idade_media_titular_mandante, 
 idade_media_titular_visitante, gols_mandante, gols_visitante, gols_1_tempo_mandante, 
 gols_1_tempo_visitante, escanteios_mandante, escanteios_visitante, faltas_mandante, 
 faltas_visitante, chutes_bola_parada_mandante, chutes_bola_parada_visitante, 
 defesas_mandante, defesas_visitante, impedimentos_mandante, impedimentos_visitante, 
 chutes_mandante, chutes_visitante, chutes_fora_mandante, chutes_fora_visitante);





-- ################## FILTRA OS DADOS APENAS PARA O INTERVALO DE TEMPO COM OS DADOS COMPLETOS #################
SELECT *
FROM brasileirao_tratado
WHERE data >= '2007-05-03';



-- ######################## Cria tabela alternativa com esse filtro ##############################
CREATE TABLE brasileirao_tratado_alt AS
SELECT *
FROM brasileirao_tratado
WHERE data >= '2007-05-03';



-- # verifica a aplicacao desse filtro
SELECT COUNT(*) AS total_linhas
FROM brasileirao_tratado_alt;
-- # tudo certo tabela com 6460 linhas




-- #################################################################
-- # ANALISE DAS ESTATISTICAS DO CAMPEONATO BRASILEIRO 2003 - 2023
-- #################################################################


-- # VERIFICANDO E VALIDANDO DADOS

SELECT * FROM brasileirao_tratado_alt WHERE gols_mandante < 0 OR gols_visitante < 0;

-- # Essa consulta nao retornou nenhum valor como esperado, dado que se espera que nao exista valores de gol negativo

-- # DETECTANDO DUPLICAÇÕES

SELECT coluna1, COUNT(*)
FROM brasileirao_tratado
GROUP BY coluna1
HAVING COUNT(*) > 1;
-- # creio que nao ha necessidade dada natureza dos dados


-- # CHECANDO VARIAVEIS PRESENTES NO BANCO DE DADOS
SELECT COLUMN_NAME AS Variáveis  -- # seleciona o nome das colunas da tabela dentro do banco de dados
FROM INFORMATION_SCHEMA.COLUMNS -- # tabela de sistema
WHERE TABLE_NAME = 'brasileirao_tratado' -- # indica de qual tabela vai trazer o resultado dos nomes
  AND TABLE_SCHEMA = 'brasileirao'; -- # indica qual o banco de dados


SHOW COLUMNS FROM brasileirao_tratado;

-- # Distribuicao da frequencia dos arbitros
-- # PODEMOS VERIFICAR O TOP 5 ARBITROS COM MAIS JOGOS APITADOS NOS ULTIMOS 20 ANOS
SELECT arbitro, COUNT(*) AS total
FROM brasileirao_tratado
GROUP BY arbitro
ORDER BY  total DESC;
-- ## O top 5 arbitros com mais partidas apitadas:
-- ## 1 - Leandro Pedro Vuaden - 284 jogos
-- ## 2 - Wilton Sampaio - 253 jogos
-- ## 3 - Marcelo de Lima Henrique - 251 jogos
-- ## 4 - Anderson Daronco - 224 jogos
-- ## 5 - Héber Lopes - 221 jogos


-- # Renomeando os estádio para o nome popularmente conhecido
UPDATE brasileirao_tratado
SET estadio = CASE
    WHEN estadio = 'Estádio Jornalista Mário Filho' THEN 'Maracanã'
    WHEN estadio = 'Estádio Governador Magalhães Pinto' THEN 'Mineirão'
    WHEN estadio = 'Estádio Cícero Pompeu de Toledo' THEN 'Morumbi'
    WHEN estadio = 'Estádio Urbano Caldeira' THEN 'Vila Belmiro'
    WHEN estadio = 'Estádio Beira-Rio' THEN 'Beira-Rio'
    WHEN estadio = 'Allianz Parque' THEN 'Allianz Parque'
    WHEN estadio = 'Arena da Baixada' THEN 'Arena da Baixada'
    WHEN estadio = 'Estádio Raimundo Sampaio' THEN 'Independência'
    WHEN estadio = 'Estádio Olímpico Nilton Santos' THEN 'Engenhão'
    WHEN estadio = 'Estádio Governador Plácido Castelo' THEN 'Castelão'
    WHEN estadio = 'Estádio Major Antônio Couto Pereira' THEN 'Couto Pereira'
    WHEN estadio = 'Estádio São Januário' THEN 'São Januário'
    WHEN estadio = 'Neo Química Arena' THEN 'Arena Corinthians'
    WHEN estadio = 'Estádio Adelmar da Costa Carvalho' THEN 'Ilha do Retiro'
    WHEN estadio = 'Arena do Grêmio' THEN 'Arena do Grêmio'
    WHEN estadio = 'Estádio Municipal Paulo Machado de Carvalho' THEN 'Pacaembu'
    WHEN estadio = 'Estádio Serra Dourada' THEN 'Serra Dourada'
    WHEN estadio = 'Estádio Manoel Barradas' THEN 'Barradão'
    WHEN estadio = 'Arena Condá' THEN 'Arena Condá'
    WHEN estadio = 'Estádio Aderbal Ramos da Silva' THEN 'Ressacada'
    WHEN estadio = 'Estádio Orlando Scarpelli' THEN 'Orlando Scarpelli'
    WHEN estadio = 'Arena Fonte Nova' THEN 'Fonte Nova'
    WHEN estadio = 'Estádio Olímpico Monumental' THEN 'Olímpico'
    WHEN estadio = 'Estádio do Governo do Estado de Goiás' THEN 'Serra Dourada'
    WHEN estadio = 'Estádio Moisés Lucarelli' THEN 'Moisés Lucarelli'
    WHEN estadio = 'Estádio Eládio de Barros Carvalho' THEN 'Arruda'
    WHEN estadio = 'Estádio Nabi Abi Chedid' THEN 'Nabi Abi Chedid'
    WHEN estadio = 'Arena Pantanal' THEN 'Arena Pantanal'
    WHEN estadio = 'Estádio Governador Roberto Santos' THEN 'Pituaçu'
    WHEN estadio = 'Estádio Alfredo Jaconi' THEN 'Alfredo Jaconi'
    WHEN estadio = 'Estádio Durival Britto e Silva' THEN 'Vila Capanema'
    WHEN estadio = 'Estádio Doutor Osvaldo Texeira Duarte' THEN 'Estádio Osvaldo Teixeira Duarte'
    WHEN estadio = 'Estádio Antonio Accioly' THEN 'Antônio Accioly'
    WHEN estadio = 'Arena de Pernambuco' THEN 'Arena Pernambuco'
    WHEN estadio = 'Estádio Heriberto Hülse' THEN 'Heriberto Hülse'
    WHEN estadio = 'Estádio Nacional de Brasília Mané Garrincha' THEN 'Mané Garrincha'
    WHEN estadio = 'Arena Barueri' THEN 'Arena Barueri'
    WHEN estadio = 'Estádio General Sílvio Raulino de Oliveira' THEN 'Raulino de Oliveira'
    WHEN estadio = 'Arena Joinville' THEN 'Arena Joinville'
    WHEN estadio = 'Estádio Municipal João Lamego Netto' THEN 'Ipatingão'
    WHEN estadio = 'Estádio Brinco de Ouro da Princesa' THEN 'Brinco de Ouro'
    WHEN estadio = 'Estádio João Cláudio de Vasconcelos Machado' THEN 'Machadão'
    WHEN estadio = 'Estádio Luso Brasileiro' THEN 'Estádio dos Luso-Brasileiros'
    WHEN estadio = 'Estádio Municipal Eduardo José Farah' THEN 'Farah'
    WHEN estadio = 'Estádio Bruno José Daniel' THEN 'Bruno José Daniel'
    WHEN estadio = 'Ligga Arena' THEN 'Arena da Baixada'
    WHEN estadio = 'Estádio Rei Pelé' THEN 'Rei Pelé'
    WHEN estadio = 'Estádio José do Rego Maciel' THEN 'Arruda'
    WHEN estadio = 'Estádio Olímpico Pedro Ludovico Teixeira' THEN 'Estádio Olímpico'
    WHEN estadio = 'Estádio Francisco Stédile' THEN 'Centenário'
    WHEN estadio = 'Sem Informação' THEN 'Desconhecido'
    WHEN estadio = 'Estádio Cláudio Moacyr de Azevedo' THEN 'Moacyrzão'
    WHEN estadio = 'Arena MRV' THEN 'Arena MRV'
    WHEN estadio = 'Estádio General Sylvio Raulino de Oliveira' THEN 'Raulino de Oliveira'
    WHEN estadio = 'Estádio do Vale' THEN 'Estádio do Vale'
    WHEN estadio = 'Estádio Municipal Radialista Mário Helênio' THEN 'Helenão'
    WHEN estadio = 'Estádio Estadual Kléber José de Andrade' THEN 'Kléber Andrade'
    WHEN estadio = 'Estádio Alberto Oliveira' THEN 'Joia da Princesa'
    WHEN estadio = 'Estádio Giulite Coutinho' THEN 'Giulite Coutinho'
    WHEN estadio = 'Estádio Presidente Vargas' THEN 'PV'
    WHEN estadio = 'Estádio Joaquim Henrique Nogueira' THEN 'Arena Independência'
    WHEN estadio = 'Estádio Municipal Jacy Scaff' THEN 'Café'
    WHEN estadio = 'Estádio Municipal Parque do Sabiá' THEN 'Parque do Sabiá'
    WHEN estadio = 'Estádio Paulo Constantino' THEN 'Prudentão'
    WHEN estadio = 'Estádio Vail Chaves' THEN 'Vail Chaves'
    WHEN estadio = 'Estádio Municipal Doutor Novelli Júnior' THEN 'Novelli Júnior'
    WHEN estadio = 'Estádio Doutor Adhemar de Barros' THEN 'Adhemar de Barros'
    WHEN estadio = 'Campus Realzale Gazteak' THEN 'Campus Realzale Gazteak'
    WHEN estadio = 'Arena da Amazônia' THEN 'Arena da Amazônia'
    WHEN estadio = 'Estadio Parque Maracaná' THEN 'Parque Maracaná'
    WHEN estadio = 'Estádio Estadual Jornalista Edgar Augusto Proença' THEN 'Mangueirão'
    WHEN estadio = 'Estádio Governador João Castelo - Castelão' THEN 'Castelão'
    WHEN estadio = 'Estádio Elmo Serejo Farias' THEN 'Serejão'
    WHEN estadio = 'Estádio Valmir Campelo Bezerra' THEN 'Bezerrão'
    WHEN estadio = 'Arena das Dunas' THEN 'Arena das Dunas'
    WHEN estadio = 'Estádio de Hailé Pinheiro' THEN 'Estádio da Serrinha'
    WHEN estadio = 'Estádio Benedito Teixeira' THEN 'Teixeirão'
    WHEN estadio = 'Estádio Estadual Lourival Baptista' THEN 'Batistão'
    WHEN estadio = 'Estádio Érton Coelho de Queiroz' THEN 'Vila Olímpica'
    WHEN estadio = 'Estádio Universitário Pedro Pedrossian' THEN 'Morenão'
    ELSE estadio
END
WHERE estadio IN (
    'Estádio Jornalista Mário Filho', 
    'Estádio Governador Magalhães Pinto', 
    'Estádio Cícero Pompeu de Toledo', 
    'Estádio Urbano Caldeira', 
    'Estádio Beira-Rio', 
    'Allianz Parque', 
    'Arena da Baixada', 
    'Estádio Raimundo Sampaio', 
    'Estádio Olímpico Nilton Santos', 
    'Estádio Governador Plácido Castelo', 
    'Estádio Major Antônio Couto Pereira', 
    'Estádio São Januário',
    'Neo Química Arena',
    'Estádio Adelmar da Costa Carvalho',
    'Arena do Grêmio',
    'Estádio Municipal Paulo Machado de Carvalho',
    'Estádio Serra Dourada',
    'Estádio Manoel Barradas',
    'Arena Condá',
    'Estádio Aderbal Ramos da Silva',
    'Estádio Orlando Scarpelli',
    'Arena Fonte Nova',
    'Estádio Olímpico Monumental',
    'Estádio do Governo do Estado de Goiás',
    'Estádio Moisés Lucarelli',
    'Estádio Eládio de Barros Carvalho',
    'Estádio Nabi Abi Chedid',
    'Arena Pantanal',
    'Estádio Governador Roberto Santos',
    'Estádio Alfredo Jaconi',
    'Estádio Durival Britto e Silva',
    'Estádio Doutor Osvaldo Texeira Duarte',
    'Estádio Antonio Accioly',
    'Arena de Pernambuco',
    'Estádio Heriberto Hülse',
    'Estádio Nacional de Brasília Mané Garrincha',
    'Arena Barueri',
    'Estádio General Sílvio Raulino de Oliveira',
    'Arena Joinville',
    'Estádio Municipal João Lamego Netto',
    'Estádio Brinco de Ouro da Princesa',
    'Estádio João Cláudio de Vasconcelos Machado',
    'Estádio Luso Brasileiro',
    'Estádio Municipal Eduardo José Farah',
    'Estádio Bruno José Daniel',
    'Ligga Arena',
    'Estádio Rei Pelé',
    'Estádio José do Rego Maciel',
    'Estádio Olímpico Pedro Ludovico Teixeira',
    'Estádio Francisco Stédile',
    'Sem Informação',
    'Estádio Cláudio Moacyr de Azevedo',
    'Arena MRV',
    'Estádio General Sylvio Raulino de Oliveira',
    'Estádio do Vale',
    'Estádio Municipal Radialista Mário Helênio',
    'Estádio Estadual Kléber José de Andrade',
    'Estádio Alberto Oliveira',
    'Estádio Giulite Coutinho',
    'Estádio Presidente Vargas',
    'Estádio Joaquim Henrique Nogueira',
    'Estádio Municipal Jacy Scaff',
    'Estádio Municipal Parque do Sabiá',
    'Estádio Paulo Constantino',
    'Estádio Vail Chaves',
    'Estádio Municipal Doutor Novelli Júnior',
    'Estádio Doutor Adhemar de Barros',
    'Campus Realzale Gazteak',
    'Arena da Amazônia',
    'Estadio Parque Maracaná',
    'Estádio Estadual Jornalista Edgar Augusto Proença',
    'Estádio Governador João Castelo - Castelão',
    'Estádio Elmo Serejo Farias',
    'Estádio Valmir Campelo Bezerra',
    'Arena das Dunas',
    'Estádio de Hailé Pinheiro',
    'Estádio Benedito Teixeira',
    'Estádio Estadual Lourival Baptista',
    'Estádio Érton Coelho de Queiroz',
    'Estádio Universitário Pedro Pedrossian'
END);

-- # TOP 10 MAIORES PUBLICOS POR PARTIDA
SELECT ano_campeonato, data, rodada, estadio, time_mandante, time_visitante, publico
FROM brasileirao_tratado_alt
ORDER BY publico DESC
LIMIT 10;

-- # Top 10 maiores/menores médias de publico por rodada
SELECT rodada, AVG(publico) AS media_publico
FROM brasileirao_tratado_alt
GROUP BY rodada
ORDER BY media_publico DESC 
LIMIT 10;

-- # Média de publico por melhor colocacao
SELECT AVG(publico) AS media_publico
FROM brasileirao_tratado_alt
WHERE colocacao_mandante <= 5 OR colocacao_visitante <= 5;

-- # Média de publico por pior colocacao
SELECT AVG(publico) AS media_publico
FROM brasileirao_tratado_alt
WHERE colocacao_mandante >= 15 OR colocacao_visitante >= 15;

-- #
-- Média de público nos jogos em que o time é mandante
SELECT time_mandante AS time, AVG(publico) AS media_publico
FROM brasileirao_tratado_alt
GROUP BY time_mandante

UNION

-- Média de público nos jogos em que o time é visitante
SELECT time_visitante AS time, AVG(publico) AS media_publico
FROM brasileirao_tratado_alt
GROUP BY time_visitante

ORDER BY media_publico DESC
LIMIT 10;


SELECT 
    time,
    SUM(vitoria) AS vitorias,
    SUM(derrota) AS derrotas,
    SUM(empate) AS empates,
    AVG(CASE WHEN vitoria = 1 THEN publico END) AS media_publico_vitorias,
    AVG(CASE WHEN derrota = 1 THEN publico END) AS media_publico_derrotas,
    AVG(CASE WHEN empate = 1 THEN publico END) AS media_publico_empates
FROM (
    -- Calcular resultados e público para os mandantes
    SELECT 
        time_mandante AS time,
        publico,
        CASE 
            WHEN gols_mandante > gols_visitante THEN 1 
            ELSE 0 
        END AS vitoria,
        CASE 
            WHEN gols_mandante < gols_visitante THEN 1 
            ELSE 0 
        END AS derrota,
        CASE 
            WHEN gols_mandante = gols_visitante THEN 1 
            ELSE 0 
        END AS empate
    FROM brasileirao_tratado_alt

    UNION ALL

    -- Calcular resultados e público para os visitantes
    SELECT 
        time_visitante AS time,
        publico,
        CASE 
            WHEN gols_visitante > gols_mandante THEN 1 
            ELSE 0 
        END AS vitoria,
        CASE 
            WHEN gols_visitante < gols_mandante THEN 1 
            ELSE 0 
        END AS derrota,
        CASE 
            WHEN gols_visitante = gols_mandante THEN 1 
            ELSE 0 
        END AS empate
    FROM brasileirao_tratado_alt
) AS resultados
GROUP BY time
ORDER BY time;


-- # Calcula media de publico anualmente
SELECT ano_campeonato,
ROUND(AVG(publico),0) AS media_pub_anual
FROM brasileirao_tratado_alt
GROUP BY ano_campeonato
ORDER BY  media_pub_anual DESC;

-- # Calcula tambem o percentual de cada estadio
SELECT estadio, 
COUNT(*) AS total_jogos,
ROUND((COUNT(*)*100.0/ (SELECT COUNT(*) FROM brasileirao_tratado_alt)),2)
AS Percentual
FROM brasileirao_tratado_alt
GROUP BY estadio
ORDER BY Percentual DESC;



-- # Calcula media de publico por estadio e ano
SELECT estadio, ano_campeonato,
ROUND(AVG(publico),2) AS media_publico
FROM brasileirao_tratado_alt
GROUP BY estadio, ano_campeonato
ORDER BY media_publico DESC;

SELECT ano_campeonato, AVG(publico) AS media_publico
FROM brasileirao_tratado_alt
GROUP BY ano_campeonato;


-- # Calcula o TOP 3 maiores medias de publico dos estadios por ano, alem do percentual da media em relacao ao maximo de pub

WITH media_por_estadio_ano AS (
    SELECT 
        estadio, ano_campeonato,
        MAX(publico_max) AS publico_max,
        ROUND(AVG(publico), 2) AS media_publico,
        ROUND((AVG(publico) / MAX(publico_max)) * 100, 2) AS percentual_media_max,
        ROW_NUMBER() OVER (PARTITION BY ano_campeonato ORDER BY AVG(publico) DESC) AS ranking
    FROM brasileirao_tratado
    GROUP BY estadio, ano_campeonato
)

SELECT estadio, ano_campeonato, media_publico, publico_max, percentual_media_max
FROM media_por_estadio_ano
WHERE ranking <= 3
ORDER BY ano_campeonato, media_publico DESC;

-- # Conta quantas vezes cada estadio apareceu dentre o top 3 maiores media de publico
WITH media_por_estadio_ano AS (
    SELECT 
        estadio, 
        ano_campeonato,
        MAX(publico_max) AS publico_max,
        ROUND(AVG(publico), 2) AS media_publico,
        ROUND((AVG(publico) / MAX(publico_max)) * 100, 2) AS percentual_media_max,
        ROW_NUMBER() OVER (PARTITION BY ano_campeonato ORDER BY AVG(publico) DESC) AS ranking
    FROM brasileirao_tratado_alt
    GROUP BY estadio, ano_campeonato
),

top3_est_ano AS (
SELECT estadio, ano_campeonato, media_publico, publico_max, percentual_media_max
FROM media_por_estadio_ano
WHERE ranking <= 3
)
SELECT
estadio,
COUNT(*) AS contagem_top3
FROM top3_est_ano
GROUP BY estadio
ORDER BY contagem_top3 DESC;

-- # Calcula publico total por estadio
SELECT 
    estadio, 
    SUM(publico) AS total_publico
FROM brasileirao_tratado_alt
GROUP BY estadio
ORDER BY total_publico DESC;




-- # calcula a media de gols por ano para times mandantes e visitantes
SELECT 
    ano_campeonato, 
    ROUND(AVG(gols_mandante), 2) AS media_gols_mandante, 
    ROUND(AVG(gols_visitante), 2) AS media_gols_visitante
FROM brasileirao_tratado_alt
GROUP BY ano_campeonato
ORDER BY ano_campeonato;


-- # POR ANO 
SELECT ano_campeonato, arbitro, COUNT(*) AS total
FROM brasileirao_tratado_alt
GROUP BY ano_campeonato, arbitro
ORDER BY ano_campeonato ASC, total DESC;

-- # Valores contidos na variavel
SELECT ano_campeonato, COUNT(*) AS frequencia
FROM brasileirao_tratado
GROUP BY ano_campeonato
ORDER BY frequencia DESC;


-- # Est descritv media, mediana, desv padrao
-- # MEDIA DE PUBLICO GERAL
SELECT ROUND(AVG(publico),0) 'Média de Público (MIL)', ROUND(STDDEV(publico),2) 'Desvio Padrão'
FROM brasileirao_tratado;
-- # A média geral de público das partidas do brasileirão série A é de 15.715 mil pessoas

-- # MEDIA DE PUBLICO POR ANO
SELECT ano_campeonato 'Ano', ROUND(AVG(publico),0) 'Média de Público (MIL)', ROUND(STDDEV(publico),2) "Desvio Padrão"
FROM brasileirao_tratado
GROUP BY ano_campeonato
ORDER BY ano_campeonato ASC;


-- # Verifica todas as estatisticas por time
SELECT time_mandante, ano_campeonato, gols_1_tempo_mandante,
gols_mandante, faltas_mandante, escanteios_mandante
FROM brasileirao_tratado
WHERE time_mandante = 'Vasco da Gama'
ORDER BY ano_campeonato;

-- # ANALISE DE CORRELACAO
SELECT
    (SUM(publico * gols_mandante) - SUM(publico) * SUM(gols_mandante) / COUNT(*)) /
    (SQRT((SUM(publico * publico) - SUM(publico) * SUM(publico) / COUNT(*)) * 
          (SUM(gols_mandante * gols_mandante) - SUM(gols_mandante) * SUM(gols_mandante) / COUNT(*)))) AS correlacao
FROM brasileirao_tratado;

-- # VERIFICA OUTLIERS
-- # Dessa forma podemos encontrar jogos em quais os valores de publico foram muito fora da curva
SELECT *
FROM brasileirao_tratado
WHERE publico > (SELECT AVG(publico) + 3 * STDDEV(publico) FROM brasileirao_tratado)
   OR publico < (SELECT AVG(publico) - 3 * STDDEV(publico) FROM brasileirao_tratado);

-- # Aqui de maneira semelhante para gols como time mandante
SELECT *
FROM brasileirao_tratado
WHERE gols_mandante > (SELECT AVG(gols_mandante) + 3 * STDDEV(gols_mandante) FROM brasileirao_tratado)
   OR gols_mandante < (SELECT AVG(gols_mandante) - 3 * STDDEV(gols_mandante) FROM brasileirao_tratado);



-- #VERIFICA TENDÊNCIAS E PADRÕES
SELECT ano_campeonato, AVG(publico) AS media_publico
FROM brasileirao_tratado
GROUP BY ano_campeonato
ORDER BY ano_campeonato;

-- # RELATORIO SUMARIZADO
-- # Média de público por time e ano no brasileirão
SELECT time_mandante, ano_campeonato AS 'ano', COUNT(*) AS total_jogos, ROUND(AVG(publico),0) AS 'média de público (MIL)'
FROM brasileirao_tratado
WHERE publico IS NOT NULL
GROUP BY time_mandante, ano_campeonato
ORDER BY total_jogos DESC,
		ano_campeonato ASC;
        
-- #Posso falar as maiores medias de publicos por time e ano




-- # CALCULANDO A CORRELACAO entre colocacao do time mandante/visitante e a quantidade de gols dos respectivos times
SELECT 
    (SUM((rodada - avg_rodada) * (gols_mandante - avg_gols_mandante)) / 
    SQRT(SUM(POW(rodada - avg_rodada, 2)) * SUM(POW(gols_mandante - avg_gols_mandante, 2)))) AS cor_rodad_gols_mand,
    (SUM((rodada - avg_rodada) * (gols_visitante - avg_gols_visitante)) / 
    SQRT(SUM(POW(rodada - avg_rodada, 2)) * SUM(POW(gols_visitante - avg_gols_visitante, 2)))) AS cor_rodad_gols_vist
FROM (
    SELECT 
        rodada,
        gols_mandante,
        gols_visitante,
        AVG(rodada) OVER() AS avg_rodada,
        AVG(gols_mandante) OVER() AS avg_gols_mandante,
        AVG(gols_visitante) OVER() AS avg_gols_visitante
    FROM brasileirao_tratado
) subquery;
-- # apenas para fins de analise, verificamos os valores obtidos das correlacoes entre numero de rodadas e gols
-- # tanto para visitante quanto mandante, há correlações diferentes para cada analise
-- # correlação levemente positiva para n de rodadas e gols como mandante = uma singela tendencia do numero de gols do time mandante aumentarem com o passar das rodadas
-- # ja para n de rodadas e gols como visitante correlação levemente negativa = o que leva entender que a uma singela tendencia dos gols como time visitante de diminuirem com o passar das rodadas
-- # porem tendo em vista a magnitude da correlação, essas relações são de caráter muito fraco e provavelmente insignificantes




-- # PERGUNTAS A SE RESPONDER NA ANALISE

-- # 1. Qual é a média de público por rodada em diferentes estádios?
SELECT rodada, estadio, ROUND(AVG(publico),0) AS media_publico
FROM brasileirao_tratado
GROUP BY rodada, estadio
ORDER BY rodada, estadio;




-- # 2. Qual é a idade média dos titulares (mandante e visitante) e como ela varia ao longo dos anos?
SELECT ano_campeonato, 
       ROUND(AVG(idade_media_titular_mandante), 2) AS media_idade_titular_mandante, 
       ROUND(AVG(idade_media_titular_visitante), 2) AS media_idade_titular_visitante
FROM brasileirao_tratado
GROUP BY ano_campeonato
ORDER BY ano_campeonato;





-- # 3.  Qual é a média de gols por partida e como ela varia ao longo dos anos?
SELECT ano_campeonato, 
       ROUND(AVG(gols_mandante), 2) AS media_gols_mandante, 
       ROUND(AVG(gols_visitante), 2) AS media_gols_visitante
FROM brasileirao_tratado
GROUP BY ano_campeonato
ORDER BY ano_campeonato;





-- # 4. Qual é a distribuição de público máximo nas partidas e como isso varia ao longo dos anos?
SELECT ano_campeonato, ROUND(AVG(publico_max),0) AS media_publico_max
FROM brasileirao_tratado
GROUP BY ano_campeonato
ORDER BY ano_campeonato;




-- # 5. Quais são os árbitros mais frequentes e qual é a média de público nos jogos que eles arbitram?
SELECT arbitro, COUNT(*) AS total_jogos, ROUND(AVG(publico),0) AS media_publico
FROM brasileirao_tratado
GROUP BY arbitro
ORDER BY total_jogos DESC, media_publico DESC;




-- # 6. Como o número de faltas cometidas pelo time mandante e visitante influencia o resultado do jogo?
SELECT ano_campeonato, 
       ROUND(AVG(faltas_mandante), 2) AS media_faltas_mandante, 
       ROUND(AVG(faltas_visitante), 2) AS media_faltas_visitante
FROM brasileirao_tratado
WHERE faltas_mandante & faltas_visitante IS NOT NULL
GROUP BY ano_campeonato
ORDER BY ano_campeonato;





-- # 7. Qual é a média de escanteios por partida para os times mandante e visitante?
SELECT ROUND(AVG(escanteios_mandante), 2) AS media_escanteios_mandante, 
       ROUND(AVG(escanteios_visitante), 2) AS media_escanteios_visitante
FROM brasileirao_tratado;





-- # 8. Como a colocação do time (mandante e visitante) varia ao longo das rodadas?
SELECT rodada, 
       ROUND(AVG(colocacao_mandante), 2) AS media_colocacao_mandante, 
       ROUND(AVG(colocacao_visitante), 2) AS media_colocacao_visitante
FROM brasileirao_tratado
GROUP BY rodada
ORDER BY rodada;





-- # 9. Qual é a distribuição de gols marcados no primeiro tempo pelos times mandante e visitante?
SELECT 
    gols_1_tempo_mandante, 
    gols_1_tempo_visitante, 
    COUNT(*) AS total_partidas
FROM brasileirao_tratado
GROUP BY gols_1_tempo_mandante, gols_1_tempo_visitante
ORDER BY total_partidas DESC;





-- # 10. Como a performance dos técnicos (mandante e visitante) em termos de média de gols varia ao longo dos anos?
SELECT ano_campeonato, 
       tecnico_mandante, 
       tecnico_visitante, 
       ROUND(AVG(gols_mandante), 2) AS media_gols_mandante, 
       ROUND(AVG(gols_visitante), 2) AS media_gols_visitante
FROM brasileirao_tratado
GROUP BY ano_campeonato, tecnico_mandante, tecnico_visitante
ORDER BY ano_campeonato, media_gols_mandante DESC, media_gols_visitante DESC;

