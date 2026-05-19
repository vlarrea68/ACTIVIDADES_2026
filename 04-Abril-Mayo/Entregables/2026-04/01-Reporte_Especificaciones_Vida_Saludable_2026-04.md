# Reporte Mensual de Especificaciones del Proyecto Vida Saludable

**Mes:** Abril 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Documentar el desarrollo y la implementación de etapas del proyecto Vida Saludable durante abril de 2026, incluyendo preparación de insumos, validación de información, inserción en la base de datos, descarga de archivos PDF con informe de IMSS, generación de cartas y entrega de cartas, así como métricas, logs y trazas asociadas al proceso.

## 2. Alcance del Avance Mensual de Abril
Durante abril de 2026 se realizó el análisis integral del proceso completo del proyecto Vida Saludable, tomando como base técnica el repositorio auxiliar `py-sep-descarga-vida-saludable`. El trabajo del mes se concentró en identificar la arquitectura operativa del flujo, revisar los componentes reutilizables, documentar la secuencia de procesamiento por lote y establecer la línea base documental y técnica para la implementación controlada del siguiente periodo.

En este avance se documentan las especificaciones funcionales y técnicas observadas en los scripts, en el modelo de datos y en la lógica de operación existente, distinguiendo entre:
- elementos ya definidos y verificables en el repositorio auxiliar;
- etapas que quedaron delimitadas a nivel técnico en abril; y
- actividades que deberán complementarse con evidencia operativa durante mayo y en el corte trimestral del 30 de junio de 2026.

## 3. Descripción General del Proceso Vida Saludable
El proceso identificado en abril responde a una operación por lotes orientada a consultar información asociada a personas evaluadas, descargar documentos PDF vinculados al servicio IMSS y registrar el resultado de cada procesamiento con trazabilidad suficiente para reintentos, seguimiento y auditoría técnica.

La secuencia general del proceso quedó delimitada de la siguiente forma:
1. Identificación del lote a ejecutar y su criterio de agrupación.
2. Consulta de registros fuente por entidad y, cuando aplica, por ciclo escolar.
3. Procesamiento concurrente por CURP para consulta al servicio correspondiente.
4. Descarga y almacenamiento de archivos PDF cuando la respuesta es exitosa.
5. Registro del resultado de cada CURP en tablas de control y bitácora.
6. Reproceso de fallos o continuación de lotes en ejecución cuando es necesario.
7. Cierre del lote para evitar duplicidad de operación.

## 4. Componentes Técnicos Analizados en Abril

### 4.1 Scripts principales de operación
Durante abril se revisaron los siguientes componentes del repositorio auxiliar como base del proceso:

| Archivo | Función principal | Relevancia para el entregable |
|---------|-------------------|-------------------------------|
| `src/orchestrator.py` | Orquesta la ejecución del lote, procesa CURP, descarga PDFs y registra resultados | Núcleo del flujo operativo |
| `src/db.py` | Define conexión a PostgreSQL y consultas de obtención de alumnos | Base de extracción y filtrado de insumos |
| `src/run_pipeline.py` | Registra un lote nuevo y ejecuta el proceso principal por entidad | Punto de arranque del proceso estándar |
| `src/run_reproceso.py` | Crea un lote de reproceso y vuelve a intentar descargas fallidas | Soporte para recuperación de errores |
| `src/run_resume.py` | Continúa un lote en ejecución con CURP pendientes | Control de continuidad operativa |
| `src/logging_utils.py` | Configura logs a consola y archivo de errores | Evidencia de trazabilidad técnica |
| `src/fetch_encrypt.py` | Utilería de descarga concurrente y cifrado AES de respuestas | Referencia de manejo seguro de archivos y concurrencia |

### 4.2 Variables de entorno identificadas
El análisis de abril permitió identificar los parámetros operativos mínimos para la ejecución del proceso:

| Variable | Uso dentro del proceso |
|----------|------------------------|
| `POSTGRES_DSN` | Cadena de conexión a PostgreSQL |
| `OUTPUT_DIR` | Directorio base de salida para PDFs generados |
| `WORKERS` | Número de hilos para procesamiento concurrente |
| `URL_IMSS` | URL base del servicio de consulta IMSS |
| `SECRET_IMSS` | Secreto utilizado para construir el token cifrado |
| `ID_CICLO_ESCOLAR` | Filtro adicional de procesamiento por ciclo escolar |

## 5. Etapas del Proceso Documentadas en Abril

### 5.1 Preparación de insumos
- Identificación de insumos de entrada por lote.
adelan- Revisión de insumos fuente y de la estructura mínima requerida para su procesamiento.
- Delimitación de campos críticos para procesamiento, particularmente `curp` y `cct`.

Como parte del análisis se identificó que el proceso puede operar con lotes asociados a una entidad federativa y que la consulta de insumos observada en abril se realiza desde base de datos, recuperando campos como CCT, CURP, teléfono, correo, estatus de reporte y ciclo escolar. También se observó la existencia de flujos auxiliares basados en lotes ya registrados, tanto para reproceso como para reanudación de ejecución. La referencia a layouts o archivos de entrada quedó documentada como parte del alcance funcional del contrato, pero no como flujo productivo ya evidenciado en el código revisado durante abril.

### 5.2 Validación de información
- Revisión de reglas iniciales para validar estructura de archivos y consistencia de datos.
- Identificación de errores esperados en encabezados, columnas, registros vacíos y datos incompletos.
- Definición de criterios mínimos de aceptación para procesamiento.

El análisis del código mostró que la validación técnica no se limita a la forma del archivo, sino también a la disponibilidad de datos para consulta y al filtrado por entidad federativa y ciclo escolar. En particular, las consultas del módulo `db.py` se apoyan en tablas de negocio como `catalogo_cct` y `menor_evaluado`, lo que hace necesario validar consistencia entre CCT, CURP y atributos de contacto antes de la ejecución de descargas.

### 5.3 Inserción en la base de datos
- Revisión del modelo de base de datos PostgreSQL asociado al proyecto.
- Identificación de tablas y puntos de registro para lotes, ejecuciones y resultados.
- Delimitación de la lógica de inserción y trazabilidad operativa.

Durante abril se identificaron como estructuras clave para el proceso las siguientes tablas:

| Tabla | Propósito operativo |
|-------|---------------------|
| `catalogo_cct` | Catálogo de centros de trabajo y datos de ubicación |
| `menor_evaluado` | Fuente principal de registros a procesar |
| `Lote` | Registro de cada ejecución con identificador, fecha, entidad y criterio |
| `CurpProcesada` | Resultado por CURP procesada, lote, CCT, ruta de PDF y estado de descarga |
| `BitacoraEvento` | Registro puntual de eventos asociados a cada CURP |

En el flujo revisado, cada lote se registra con un `id_lote`, nombre, fecha de ejecución, entidad federativa y criterio de agrupación. Posteriormente, cada CURP procesada se registra o actualiza con su ruta de PDF, estado de descarga y referencia al lote que la procesó. Finalmente, se inserta un evento en bitácora para documentar el mensaje devuelto por la consulta o por el intento de procesamiento.

### 5.4 Descarga de archivos PDF con informe de IMSS
- Análisis del flujo de descarga concurrente de archivos PDF.
- Revisión de rutas de salida por entidad y CCT.
- Identificación de criterios para nombrado, reintentos y almacenamiento de archivos.

El análisis del módulo `orchestrator.py` permitió documentar una lógica de consulta al servicio IMSS con las siguientes características:
- Construcción de parámetros a partir de CURP, teléfono, correo y ciclo escolar.
- Cifrado AES en modo ECB del texto plano para construir un token hexadecimal de consulta.
- Invocación del servicio remoto con tiempo de espera de 30 segundos.
- Manejo de respuestas en formato PDF o JSON con PDF codificado en base64.
- Reintentos de conexión hasta tres veces antes de marcar el procesamiento como fallo.

Respecto al almacenamiento, abril permitió dejar especificada la estructura de salida de los PDFs bajo un esquema por estado, CCT y ciclo escolar. La ruta base observada sigue el patrón:

`OUTPUT_DIR/<estado>/<cct>/<ciclo>/sin-carta/`

El archivo generado se nombra con el patrón:

`<CCT>_<CURP>_<NoDescarga>.pdf`

Esta especificación es relevante porque deja trazabilidad tanto de la entidad de origen como del número de intento exitoso de descarga.

### 5.5 Generación y entrega de cartas
- Delimitación funcional de la etapa posterior a la descarga de informes.
- Identificación de dependencias para la generación de cartas y preparación de entregables.
- Definición preliminar de evidencias requeridas para documentar la entrega de cartas.

Durante abril no se identificó todavía una implementación cerrada de generación y entrega de cartas dentro del repositorio revisado, por lo que esta etapa quedó delimitada como una fase posterior al almacenamiento del PDF y al registro del resultado individual. La evidencia técnica sugiere que la carpeta `sin-carta` fue diseñada como referencia para una etapa posterior de enriquecimiento documental o distribución, lo que deberá formalizarse en mayo con reglas más precisas de negocio y evidencia de operación.

### 5.6 Métricas, logs y trazas
- Revisión de mecanismos existentes de logging en scripts del proyecto.
- Identificación de métricas operativas por lote, fallos y reprocesos.
- Propuesta de categorías de trazabilidad para seguimiento mensual.

Se identificó que la evidencia de trazabilidad puede integrarse desde dos niveles complementarios:
- `logging_utils.py`, que configura salida a consola y archivo de errores con marca temporal, nivel y origen del mensaje;
- `BitacoraEvento`, que registra por CURP la fecha del evento, el tipo de evento, el mensaje y la referencia del registro procesado.

Adicionalmente, el proceso permite derivar métricas a partir de:
- número total de CURP procesadas por lote;
- número de descargas exitosas;
- volumen de fallos y reintentos;
- rutas de salida generadas;
- tiempo estimado de ejecución por lote;
- cantidad de reprocesos o continuaciones necesarias.

## 6. Especificaciones Técnicas Revisadas

| Componente | Especificación revisada en abril | Resultado del avance |
|------------|----------------------------------|----------------------|
| Insumos de entrada | Extracción desde PostgreSQL con referencia contractual a layouts futuros con `curp` y `cct` | Alcance delimitado |
| Orquestación | Registro, seguimiento y procesamiento por lote | Flujo analizado |
| Base de datos | PostgreSQL con DDL definido | Modelo revisado |
| Descarga de PDFs | Procesamiento concurrente y rutas por entidad/CCT | Operación documentada |
| Reprocesos | Reintentos para fallos | Mecanismo identificado |
| Logs y métricas | Registro de ejecuciones, errores y reintentos | Línea base definida |

## 7. Especificaciones Funcionales y Operativas Consolidadas

### 7.1 Registro de lotes
El proceso prevé la creación de un lote único por ejecución. Si existe un lote con el mismo nombre y con bandera de ejecución activa, el flujo debe impedir la duplicidad para evitar procesamiento simultáneo no controlado.

### 7.2 Procesamiento concurrente
El procesamiento de CURP se ejecuta con un `ThreadPoolExecutor`, cuyo número de hilos puede configurarse mediante la variable `WORKERS`. Esta especificación permite escalar la operación según volumen y recursos disponibles.

### 7.3 Reprocesos y reanudación
El flujo distingue tres modos de operación:
- ejecución estándar por entidad;
- reproceso de registros fallidos;
- reanudación de lotes en ejecución con CURP pendientes.

Esta separación es esencial para documentar continuidad operativa, manejo de incidencias y recuperación ante fallos.

### 7.4 Control de estados
El proceso utiliza estados de descarga como `EXITO` y `FALLO`, y complementa dicha información con mensajes provenientes del servicio o de las excepciones capturadas. Este patrón es la base para construir indicadores de tasa de éxito, fallos recurrentes y necesidades de reproceso.

### 7.5 Cifrado y seguridad técnica
Se identificó el uso de cifrado para construir el token de consulta al servicio IMSS y una utilidad adicional de descarga y cifrado AES de archivos externos en `fetch_encrypt.py`. Aunque responden a propósitos distintos, ambos elementos reflejan un enfoque de protección de información durante transferencia o almacenamiento temporal.

## 8. Evidencia del Avance de Abril
- Revisión del DDL principal y estructura general de persistencia.
- Análisis de scripts `orchestrator.py`, `run_pipeline.py`, `run_reproceso.py` y `run_resume.py`.
- Revisión de `db.py` para identificar consultas y filtros por entidad y ciclo escolar.
- Revisión del proceso de descarga, nombrado y almacenamiento de PDFs.
- Identificación de la función de cierre de lote y del mecanismo de bitácora de eventos.
- Delimitación documental de la etapa de generación y entrega de cartas como fase posterior al procesamiento base.

## 9. Hallazgos Relevantes
- El proyecto cuenta con una base técnica reutilizable para operación por lotes y reprocesos.
- La validación de insumos es crítica para evitar errores aguas abajo en descarga y registro.
- El registro de métricas, logs y trazas debe formalizarse como evidencia mensual del contrato.
- La trazabilidad por lote y por CURP ya tiene una base técnica clara en las tablas `Lote`, `CurpProcesada` y `BitacoraEvento`.
- La concurrencia configurable mediante `WORKERS` representa un punto relevante para futuras métricas de rendimiento y capacidad.
- La generación y entrega de cartas requiere un cierre documental más explícito en fases posteriores, ya que en abril se identificó su dependencia con la salida `sin-carta` y con los resultados individuales ya descargados.

## 10. Riesgos y Dependencias Identificados
- Dependencia del servicio externo IMSS y de su disponibilidad para obtener respuestas exitosas.
- Dependencia de variables de entorno críticas para conexión, cifrado y salida de archivos.
- Necesidad de consolidar reglas de negocio para la etapa de cartas y entrega final.
- Necesidad de medir el comportamiento real del procesamiento concurrente bajo carga operativa.

## 11. Próximos Pasos
- Ejecutar el flujo con evidencia operativa controlada.
- Formalizar bitácoras de validación, inserción, descarga y generación de cartas.
- Consolidar métricas y trazas por lote para el reporte de mayo.
- Documentar resultados de reproceso y de continuidad de lotes cuando se presenten incidencias.
- Traducir la etapa `sin-carta` a una especificación documental y operativa más completa.
- Preparar el corte trimestral del 30 de junio con evidencia acumulada.

---

**Comentarios adicionales:**

Este entregable corresponde al avance mensual de abril de 2026 y documenta de forma ampliada la arquitectura operativa identificada, las tablas de soporte, los scripts principales y la lógica de trazabilidad del proyecto Vida Saludable. Durante mayo deberá complementarse con evidencia operativa verificable, resultados por lote, mediciones y documentación formal de la fase de generación y entrega de cartas.