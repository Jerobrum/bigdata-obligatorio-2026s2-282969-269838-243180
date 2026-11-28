# Uso de inteligencia artificial

Se usó una sola herramienta de IA generativa: Claude, de Anthropic, en su versión de chat y en Claude Code.

| Parte del trabajo | Contexto de uso | Qué se revisó |
|---|---|---|
| Plan de trabajo | Generación de ideas: un plan por fases armado a partir de la letra, los apuntes y los prácticos | Lo leímos y lo discutimos los tres antes de repartir las tareas |
| Elección de los datos | Búsqueda de conjuntos de datos candidatos y redacción inicial de la propuesta | Bajamos cada archivo, contamos filas y columnas y confirmamos que las fuentes fueran oficiales. La propuesta la aprobaron los docentes |
| Notebooks 1 y 2 | Redacción inicial y revisión del código de Spark, y sugerencia de controles | Todo se corrió en la VM. Los conteos se compararon con valores contados a mano, y las reglas de criterio (atraso extremo, tipo de línea "NA") se discutieron y aprobaron en el grupo |
| Informe | Redacción inicial de secciones, corrección de estilo, formato del documento y armado de los diagramas | Los números se tomaron de las salidas de los notebooks corridos en la VM y del dashboard. Los diagramas se compararon con el flujo de NiFi, el DDL y las rutas de HDFS |
| Parte 2 | Generación de ideas para la arquitectura en AWS y descripción de cada servicio | Las fuentes y sus problemas de calidad salen de la exploración de los archivos del MTOP. Los servicios se compararon con lo visto en clase sobre AWS |

Todo lo que generó la herramienta se revisó antes de usarlo. Los resultados del informe salen de las corridas en la VM, no de la IA, y las decisiones de criterio están registradas en `decisiones.md`.
