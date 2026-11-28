# Decisiones

Qué decidimos y por qué. La sección 1 la acordamos los tres en el grupo de WhatsApp. Las secciones 2 y 3 van en la PR de cada notebook y quedan firmes cuando se aprueba. La sección 4 junta lo que falta definir.

## 1. Alcance, ingesta y entorno (acordadas en el grupo, 10 y 11/11)

- **Año 2025 completo.** ANAC tiene publicados los 12 meses.
- **Solo vuelos de pasajeros: tipo de línea N (nacional) e I (internacional).** C y G son vuelos de carga, y la puntualidad de un carguero no se mide igual. Vale para las cinco preguntas.
- **Horarios en hora de Brasília, aclarado en el informe.** Es la hora en que ANAC publica los horarios, según su diccionario oficial. En P3 no cambia el resultado: los 10 aeropuertos con más movimiento están en UTC-3, y el notebook 2 lo verifica.
- **La VM oficial es la de Jerónimo.** Ya tenía probado el circuito completo (NiFi, Hive, Spark, Hue y Superset) y la fase 1 quedó ahí.
- **Los CSV de ANAC entran por GitHub.** ANAC rechaza los pedidos automáticos de NiFi: devuelve una página de "Request Rejected" en vez del CSV. Los archivos se bajan desde el navegador sin modificarlos, se suben a `datos_respaldo/` y NiFi los toma de raw.githubusercontent.com. Un SHA-256 por archivo prueba que lo que llega a HDFS es idéntico a lo publicado. OurAirports se baja directo. Por eso el repo es público: NiFi lo lee sin credenciales.
- **Cada archivo se escribe dos veces.** En `/lnd` (landing, se reemplaza) y en `/raw` (respaldo, nunca se sobrescribe), en `<zona>/vuelos_brasil/<fuente>/ingesta=AAAAMMDD/` y con su nombre original.
- **Permisos abiertos en HDFS.** Hive y Spark escriben con usuarios distintos, así que antes de cargar tablas se corre `chmod -R 777` sobre `/rfn` y `/anl`.
- **El notebook 1 termina con las tablas de Hive creadas y probadas**, como se pidió en clase.

## 2. Notebook 1: reglas que salieron del año completo (PR #1)

Todas las reglas de limpieza están en la sección 4 del notebook 1. Estas son las que se sumaron al revisar los 12 meses:

- **Claves de vuelo repetidas.** 57 claves aparecen dos veces en el mismo archivo y rompían la PK de `fact_vuelo`. Queda el registro realizado y, entre esos, el de menor atraso.
- **Vuelos de 2026 afuera.** El archivo de diciembre trae 31 vuelos de enero de 2026.
- **Cancelados con tipo de línea "NA".** Toman el tipo que tiene el mismo vuelo en otras fechas: de 463, 304 entran como N o I. Si se excluyen, mayo pierde el 12% de sus cancelaciones de pasajeros, y eso pesa en P5.
- **Salidas adelantadas más de 60 minutos.** Pasan a atraso extremo: en el año, 553 vuelos de pasajeros realizados figuraban saliendo más de 1 hora antes de lo previsto (24 de ellos, más de 24 horas antes) y contaban como puntuales. Las adelantadas hasta 60 minutos siguen contando, con signo negativo.

Estas dos últimas son decisiones de criterio. Se propusieron en el grupo el 12/11 y quedaron aprobadas el 13/11. Van en commits aparte.

## 3. Notebook 2: criterios de cada pregunta

- **Dónde se responde cada pregunta.** P1, P2 y P3 en el notebook, con pandas y dos gráficos cada una. P4 y P5 en Superset, con tablas en la zona analítica. Es el reparto del plan.
- **Definiciones comunes.** Vuelo programado: tiene horario previsto y terminó realizado o cancelado. Tasa de cancelación: cancelados sobre programados. Vuelo medido: realizado y con atraso de salida calculado, sin los no programados (los que no tienen horario previsto) ni los de atraso extremo. Tasa de puntualidad: vuelos medidos con 15 minutos de atraso o menos, sobre vuelos medidos.
- **P1.** La mejora es la puntualidad del cuarto trimestre menos la del primero, en puntos porcentuales. Nacionales e internacionales van por separado. Entran las empresas con 100 vuelos medidos o más en cada uno de los 12 meses.
- **P1, control del registro.** Para las seis que más mejoran en cada segmento, el notebook muestra el porcentaje de salidas adelantadas mes a mes. En JetSMART (JAT y JES) pasa de entre 1 % y 12 % en el primer trimestre a entre 70 % y 84 % en abril, y eso pone a sus dos empresas primeras entre las internacionales. El mismo salto aparece en Copa (de 17 % a 59 % en julio), Iberia (de 1 % a 30 % en julio) y Flybondi (de 14 % a 35 % en julio y 48 % en agosto). Apunta a un cambio en cómo se registra la hora de salida más que a una mejora real. Por eso la respuesta de P1 toma como mayor mejora creíble la de American Airlines (+13,8 puntos), que mantiene esa proporción estable todo el año (entre 42 % y 63 %).
- **P2.** La ruta es el par de aeropuertos, sin importar el sentido, y entran las que tienen 100 programados o más. Solo cuentan las rutas que tocan Brasil: hay rutas entre dos aeropuertos extranjeros, como Buenos Aires a Madrid, con todos sus vuelos cancelados, que llenarían el ranking. La concentración es la parte de las cancelaciones de la ruta que aportan la primera aerolínea y las dos primeras.
- **P3.** Los 10 aeropuertos son los de más movimiento (salidas más llegadas realizadas). Se promedia el atraso de salida, y los adelantos restan. Las combinaciones con menos de 30 vuelos quedan afuera.
- **P4.** La frecuencia semanal son las salidas realizadas desde Brasil hacia el país, sobre las semanas del trimestre. Se cuenta un solo sentido porque una frecuencia es una ida y vuelta. La participación brasileña son los vuelos de empresas brasileñas sobre el total hacia ese país.
- **P5.** El tamaño es el de OurAirports (grande, mediano y chico), tomado del aeropuerto de origen porque la puntualidad se mide en la salida. Solo aeropuertos de Brasil: los extranjeros tienen solo vuelos internacionales y casi todos son grandes.
- **Zona analítica.** Base aparte, `resumen_vuelos_brasil`, con tablas externas en parquet en `/anl/vuelos_brasil/v1/`, cargadas con `INSERT OVERWRITE`, como se vio en clase el 10/11. Cada tabla guarda los conteos además de las tasas, para que Superset recalcule bien las tasas al filtrar.
- **Indicadores del dashboard.** Los indicadores del dashboard (`kpi_resumen`) cuentan solo vuelos que tocan Brasil, igual que P2. Los vuelos entre dos aeropuertos extranjeros que figuran en los datos (5.032 programados, 64 % cancelados) quedan afuera.

## 4. Abiertas

- **Nombres de las zonas (supuesto, sin confirmar con los docentes).** Se dejan `/lnd`, `/raw`, `/rfn` y `/anl`. Son las cuatro zonas que pide la letra y que se nombraron en clase el 20/10: landing, raw de respaldo, refined y analítica. Así quedó en el informe.
- **Dónde va el modelo (supuesto, sin confirmar con los docentes).** Queda en `/rfn/vuelos_brasil/v1/modelo/`, una carpeta propia dentro de la zona refinada, como "nueva ubicación". En clase se dijo que las tablas de Hive del modelo apuntan a refined y las del dashboard a la zona analítica. Así quedó en el informe.
- **Rutas que no tocan Brasil.** Se filtran en P2 y en los indicadores del dashboard. P1 no las filtra, pero no cambian su resultado: las empresas que encabezan el ranking no tienen ningún vuelo medido de ese tipo (control en el notebook 2). Se podrían sacar en el notebook 1, como regla del modelo.
