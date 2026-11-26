-- Modelo estrella en Hive. Lo genera e imprime el notebook 1 (sección 7) a partir del esquema de cada DataFrame.

CREATE DATABASE IF NOT EXISTS vuelos_brasil LOCATION 'hdfs://namenode:8020/user/hive/warehouse/vuelos_brasil.db';

CREATE EXTERNAL TABLE vuelos_brasil.dim_empresa (
  `icao_empresa` STRING,
  `iata_empresa` STRING,
  `nombre_empresa` STRING,
  `nacionalidad` STRING,
  `servico` STRING
)
STORED AS PARQUET
LOCATION 'hdfs://namenode:8020/rfn/vuelos_brasil/v1/modelo/dim_empresa';

CREATE EXTERNAL TABLE vuelos_brasil.dim_aeropuerto (
  `icao_aeropuerto` STRING,
  `nombre_aeropuerto` STRING,
  `tipo_ourairports` STRING,
  `tamano` STRING,
  `ciudad` STRING,
  `uf` STRING,
  `iso_pais` STRING,
  `huso_utc` INT,
  `latitud` DOUBLE,
  `longitud` DOUBLE,
  `iata_code` STRING
)
STORED AS PARQUET
LOCATION 'hdfs://namenode:8020/rfn/vuelos_brasil/v1/modelo/dim_aeropuerto';

CREATE EXTERNAL TABLE vuelos_brasil.dim_pais (
  `iso_pais` STRING,
  `nombre_pais` STRING,
  `continente` STRING
)
STORED AS PARQUET
LOCATION 'hdfs://namenode:8020/rfn/vuelos_brasil/v1/modelo/dim_pais';

CREATE EXTERNAL TABLE vuelos_brasil.dim_fecha (
  `fecha` DATE,
  `anio` INT,
  `mes` INT,
  `anio_mes` STRING,
  `trimestre` INT,
  `dia_semana_num` INT,
  `dia_semana` STRING,
  `semana_anio` INT,
  `es_fin_de_semana` BOOLEAN
)
STORED AS PARQUET
LOCATION 'hdfs://namenode:8020/rfn/vuelos_brasil/v1/modelo/dim_fecha';

CREATE EXTERNAL TABLE vuelos_brasil.fact_vuelo (
  `id_vuelo` STRING,
  `icao_empresa` STRING,
  `numero_voo` STRING,
  `codigo_di` STRING,
  `tipo_linha` STRING,
  `es_internacional` BOOLEAN,
  `icao_origem` STRING,
  `icao_destino` STRING,
  `fecha` DATE,
  `tiene_horario_previsto` BOOLEAN,
  `partida_prevista` TIMESTAMP,
  `partida_real` TIMESTAMP,
  `chegada_prevista` TIMESTAMP,
  `chegada_real` TIMESTAMP,
  `hora_prevista_brasilia` INT,
  `partida_prevista_local` TIMESTAMP,
  `hora_local` INT,
  `dia_semana_local` INT,
  `situacao_voo` STRING,
  `realizado` BOOLEAN,
  `cancelado` BOOLEAN,
  `informado` BOOLEAN,
  `atraso_partida_min` DOUBLE,
  `atraso_chegada_min` DOUBLE,
  `puntual` BOOLEAN,
  `atrasado_15` BOOLEAN,
  `atraso_extremo` BOOLEAN
)
PARTITIONED BY (`anio_mes` STRING)
STORED AS PARQUET
LOCATION 'hdfs://namenode:8020/rfn/vuelos_brasil/v1/modelo/fact_vuelo';

MSCK REPAIR TABLE vuelos_brasil.fact_vuelo;
