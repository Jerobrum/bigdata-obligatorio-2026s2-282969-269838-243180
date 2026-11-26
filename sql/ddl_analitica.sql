-- Tablas de la zona analítica para Superset. Las genera e imprime el notebook 2 (sección 6).

CREATE DATABASE IF NOT EXISTS resumen_vuelos_brasil LOCATION 'hdfs://namenode:8020/user/hive/warehouse/resumen_vuelos_brasil.db';

CREATE EXTERNAL TABLE resumen_vuelos_brasil.p4_frecuencias (
  `pais` string,
  `iso_pais` string,
  `continente` string,
  `es_uruguay` boolean,
  `trimestre` int,
  `nacionalidad` string,
  `vuelos_realizados` bigint,
  `frecuencia_semanal` double
)
STORED AS PARQUET
LOCATION 'hdfs://namenode:8020/anl/vuelos_brasil/v1/p4_frecuencias';

CREATE EXTERNAL TABLE resumen_vuelos_brasil.p4_cambio_pais (
  `pais` string,
  `iso_pais` string,
  `continente` string,
  `es_uruguay` boolean,
  `frecuencia_t1` double,
  `frecuencia_t4` double,
  `diferencia` double,
  `participacion_br_t1` double,
  `participacion_br_t4` double
)
STORED AS PARQUET
LOCATION 'hdfs://namenode:8020/anl/vuelos_brasil/v1/p4_cambio_pais';

CREATE EXTERNAL TABLE resumen_vuelos_brasil.p5_tamano_mes (
  `tamano` string,
  `anio_mes` string,
  `trimestre` int,
  `programados` bigint,
  `realizados` bigint,
  `cancelados` bigint,
  `vuelos_medidos` bigint,
  `vuelos_puntuales` bigint,
  `tasa_puntualidad` double,
  `tasa_cancelacion` double
)
STORED AS PARQUET
LOCATION 'hdfs://namenode:8020/anl/vuelos_brasil/v1/p5_tamano_mes';

CREATE EXTERNAL TABLE resumen_vuelos_brasil.kpi_resumen (
  `anio_mes` string,
  `trimestre` int,
  `vuelos_programados` bigint,
  `vuelos_realizados` bigint,
  `vuelos_cancelados` bigint,
  `vuelos_medidos` bigint,
  `vuelos_puntuales` bigint,
  `tasa_puntualidad` double,
  `tasa_cancelacion` double,
  `paises_destino` bigint
)
STORED AS PARQUET
LOCATION 'hdfs://namenode:8020/anl/vuelos_brasil/v1/kpi_resumen';
