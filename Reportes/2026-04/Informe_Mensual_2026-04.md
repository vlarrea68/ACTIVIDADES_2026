# Informe Mensual de Actividades

**Mes:** Abril 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Resumen Ejecutivo
Durante abril de 2026 inició formalmente una nueva etapa contractual orientada al desarrollo técnico y documental de cinco líneas de trabajo: proceso integral del proyecto Vida Saludable, optimización de rendimiento de bases de datos, monitoreo y alertamiento, preparación de datos para inteligencia artificial, y procesos de ingesta y transformación ETL/ELT. El mes se concentró en construir una línea base técnica verificable a partir del repositorio de apoyo `py-sep-descarga-vida-saludable`, con énfasis en componentes ejecutables, modelo de datos, trazabilidad y dependencias operativas.

El principal resultado de abril fue delimitar con precisión el flujo actualmente observable del proyecto: extracción desde PostgreSQL sobre `menor_evaluado` y `catalogo_cct`, registro de lotes en `Lote`, procesamiento concurrente por CURP, consulta cifrada al servicio IMSS, persistencia de resultados en `CurpProcesada`, registro de eventos en `BitacoraEvento`, escritura de PDFs por estado/CCT/ciclo escolar y mecanismos complementarios de reproceso y reanudación. A partir de ese flujo se derivaron los cinco entregables técnicos del mes.

Como resultado, abril cerró no solo con una base documental, sino con una especificación técnica suficientemente consistente para que mayo se concentre en evidencia operativa, mediciones comparativas, calibración de umbrales, construcción de datasets piloto y formalización de procesos ETL/ELT sobre insumos controlados.

## 2. Actividades Realizadas

### 2.1 Análisis del proceso integral del proyecto Vida Saludable
Se realizó el levantamiento técnico del flujo operativo del proyecto Vida Saludable tomando como referencia principal el repositorio auxiliar incorporado al workspace. Las actividades incluyeron:
- Revisión del esquema de base de datos PostgreSQL y de su DDL principal.
- Análisis del orquestador de lotes y de los scripts de ejecución, reproceso y continuación.
- Revisión de las consultas de extracción por entidad y ciclo escolar, incluyendo el enriquecimiento con `catalogo_cct`.
- Revisión del flujo de descarga de archivos PDF y de la estructura de salida por estado, CCT y ciclo escolar.
- Delimitación de etapas para preparación de insumos, validación, registro en BD, descarga de informes IMSS, etapa posterior de cartas y trazabilidad operativa.

Como hallazgo central, abril permitió establecer que el flujo actualmente verificable es un proceso por lotes con soporte de concurrencia y control de estado, más que una secuencia documental aislada. El lote se registra con identificador único, se evita duplicidad de ejecución activa, se procesan CURP en paralelo mediante `ThreadPoolExecutor`, se realizan hasta tres intentos de consulta por registro y se persiste tanto el resultado final como el mensaje técnico asociado. También se identificó que la carpeta `sin-carta` refleja una etapa posterior aún no cerrada funcionalmente dentro de la evidencia revisada.

### 2.2 Análisis de rendimiento de bases de datos
Se inició la línea base para optimización de rendimiento considerando el comportamiento esperado del proceso Vida Saludable y sus dependencias de persistencia. Las acciones principales fueron:
- Revisión de tablas e índices definidos en la base de datos principal.
- Identificación de operaciones críticas asociadas a registro de lotes, seguimiento de ejecuciones y reprocesos.
- Definición de criterios para medir tiempos antes y después de ajustes.
- Preparación de una matriz de hallazgos para consultas, índices y parametrización.

Durante abril se identificó que los puntos más sensibles no se concentran en una sola consulta, sino en el conjunto de operaciones que sostienen el pipeline: extracción desde `menor_evaluado` con `JOIN` a `catalogo_cct`, selección de fallidos para reproceso, recuperación de pendientes por lote y escrituras concurrentes sobre `CurpProcesada` y `BitacoraEvento`. También quedaron delimitados como candidatos de análisis los índices sobre nombre y estado de ejecución de lotes, los accesos por `id_lote` y `curp`, y la explotación futura de vistas de indicadores e históricos.

| Componente analizado | Observación inicial | Acción siguiente |
|----------------------|---------------------|------------------|
| Registro de lotes | Punto crítico para trazabilidad operativa | Medir tiempos por inserción y consulta |
| Seguimiento de CURP procesadas | Requiere acceso eficiente a estados y reintentos | Revisar índices y filtros de estado |
| Salidas por entidad/CCT | Puede crecer en volumen por lote | Validar estrategia de almacenamiento y consulta |
| Logs de proceso | Relevantes para diagnóstico de fallos | Definir consultas de explotación y retención |

### 2.3 Diseño inicial de monitoreo y alertamiento
Se definió un esquema preliminar de observabilidad para bases de datos, APIs y pipelines, orientado a operación técnica y atención de incidentes. Las actividades incluyeron:
- Identificación de métricas clave de ejecución por lote.
- Definición inicial de umbrales para fallos, tiempos de respuesta y reprocesos.
- Revisión de logs y trazas disponibles en los scripts existentes.
- Propuesta inicial de procedimiento de atención para errores recurrentes.

La revisión permitió aterrizar el monitoreo sobre superficies realmente observables: `logging_utils.py` como punto de emisión estructurada de logs, `Lote` como unidad de control de ejecuciones, `CurpProcesada` como registro de éxito o fallo por CURP, `BitacoraEvento` como bitácora técnica y `OUTPUT_DIR` como evidencia física de resultados. A partir de ello se propusieron métricas y umbrales iniciales para tiempo por lote, porcentaje de fallos, tasa de éxito de PDFs, reintentos y lotes abiertos fuera del tiempo esperado.

| Categoría | Métrica propuesta | Umbral inicial | Uso operativo |
|-----------|-------------------|----------------|---------------|
| Pipeline | Tiempo total por lote | Revisar si supera línea base definida | Detectar degradación |
| Pipeline | Porcentaje de CURP fallidas | Mayor a 5% por corrida | Activar revisión técnica |
| Base de datos | Tiempo de respuesta de consultas críticas | Por definir con línea base | Evaluar optimización |
| Descargas | Tasa de éxito de PDFs | Menor a 95% | Revisar conectividad o fuente externa |
| Reprocesos | Volumen de reintentos | Crecimiento sostenido | Analizar causa raíz |

### 2.4 Preparación de datos para IA
Se establecieron criterios iniciales para preparar datasets reutilizables con fines de inteligencia artificial, sin perder trazabilidad ni controles básicos de calidad. Los avances del mes fueron:
- Identificación de entidades y atributos potenciales para conformar datasets analíticos.
- Definición preliminar de criterios de completitud, consistencia y trazabilidad.
- Clasificación inicial de variables útiles para análisis, priorización y apoyo a decisiones operativas.
- Delimitación de posibles conjuntos de features derivados de trazas operativas, incidencias y resultados por lote.

El análisis permitió aterrizar cuatro familias de datasets candidatos: operación por lote, detalle por CURP procesada, incidencias y trazas, y resultados de descarga. También se delimitaron features operativas, institucionales y derivadas de mensajes, así como criterios de gobernanza para reducir exposición de CURP, correo, teléfono, rutas de archivo y otros atributos sensibles. En abril no se implementaron embeddings, pero sí quedó definido que su uso solo tendría sentido sobre texto operativo y bajo un caso de uso explícito.

### 2.5 Procesos de ingesta y transformación ETL/ELT
Se estructuró la línea de trabajo para ingesta y transformación de archivos en múltiples formatos, alineada al nuevo contrato y al flujo operativo del proyecto. Las actividades incluyeron:
- Identificación del flujo real de extracción, transformación y carga actualmente observable en el proyecto.
- Definición de reglas base para formatos CSV, XLSX, JSON y XML como parte del alcance contractual.
- Identificación de puntos de depuración de datos antes y después del procesamiento.
- Mapeo preliminar entre insumos de origen, transformaciones y estructuras destino.

La principal precisión de abril fue distinguir entre el flujo ETL/ELT realmente identificado y el soporte multiformato aún no implementado. El proceso observable hoy se apoya en extracción desde PostgreSQL, transformación en memoria, integración externa con el servicio IMSS, carga en tablas operativas y escritura de PDFs, además de reproceso y reanudación. CSV, XLSX y XML quedaron como especificación contractual para etapas posteriores, mientras que JSON aparece parcialmente en las respuestas del servicio.

| Formato | Uso esperado | Validaciones iniciales |
|---------|--------------|------------------------|
| CSV | Cargas masivas o exportaciones intermedias previstas contractualmente | Orden de columnas, encabezados, CURP, CCT |
| XLSX | Insumos administrativos o consolidados previstos contractualmente | Hojas válidas, tipos de dato, celdas vacías |
| JSON | Intercambio entre servicios o evidencia estructurada, con uso parcial observado | Esquema, claves obligatorias, codificación |
| XML | Integración con formatos institucionales prevista contractualmente | Estructura, etiquetas obligatorias, consistencia |

### 2.6 Documentación generada durante abril
Durante el mes se dejó preparada la base documental para el seguimiento del nuevo contrato:
- Marco operativo del contrato abril-junio 2026.
- Informe mensual general de abril.
- Cinco entregables técnicos mensuales alineados con las líneas de trabajo del contrato.
- Matrices iniciales de actividades, entregables y evidencias.
- Definición de categorías de métricas, logs, trazas y riesgos a documentar.

## 3. Entregables Generados y Evidencias

### 3.1 Avance del reporte del proyecto Vida Saludable

| Etapa | Estado en abril | Evidencia generada |
|-------|-----------------|--------------------|
| Preparación de insumos | Analizada | Identificación de extracción desde PostgreSQL por entidad y ciclo escolar |
| Validación de información | Definida a nivel técnico | Reglas sobre consistencia entre CURP, CCT, ciclo y catálogo |
| Registro en BD | Analizada | Revisión de `Lote`, `CurpProcesada` y `BitacoraEvento` |
| Descarga de PDF IMSS | Analizada | Revisión de cifrado, reintentos y rutas de salida |
| Generación de cartas | Delimitada | Identificación de dependencia funcional de la etapa `sin-carta` |
| Métricas, logs y trazas | Definidas a nivel base | Relación entre logs, eventos, estados y resultados físicos |

### 3.2 Avance del informe de optimización de rendimiento

| Rubro | Resultado de abril |
|-------|--------------------|
| Línea base | Definida de forma preliminar |
| Consultas críticas | Identificadas en extracción, reproceso, pendientes y control de lotes |
| Índices por revisar | Listados para validación técnica sobre lotes, CURP y estados de ejecución |
| Evidencia antes/después | Pendiente de consolidar en mayo |

### 3.3 Avance del reporte de monitoreo y alertamiento

| Elemento | Resultado de abril |
|----------|--------------------|
| Métricas | Identificadas por lote, CURP, base de datos, descargas y reprocesos |
| Umbrales | Propuestos a nivel inicial para fallos, PDFs, reintentos y lotes abiertos |
| Alertas | Pendientes de instrumentación, con niveles informativo, preventivo y crítico |
| Procedimiento de atención | Borrador definido para clasificación, diagnóstico y reproceso/reanudación |

### 3.4 Avance del reporte de preparación de datos para IA

| Elemento | Resultado de abril |
|----------|--------------------|
| Dataset candidatos | Identificados por lote, CURP, incidencias y descargas |
| Features iniciales | Delimitados por familias operativas, institucionales y de trazabilidad |
| Embeddings | Sujetos a evaluación por caso de uso sobre texto operativo |
| Lineamientos de calidad | Definidos con criterios de completitud, consistencia, duplicidad y linaje |

### 3.5 Avance del informe ETL/ELT

| Componente | Resultado de abril |
|------------|--------------------|
| Flujo real identificado | Extracción PostgreSQL, transformación operativa, integración IMSS, carga en BD y PDF |
| Formatos cubiertos | CSV, XLSX, JSON y XML como especificación contractual; JSON/PDF observados parcialmente |
| Validaciones | Definidas sobre claves, filtros, integridad y consistencia con catálogos |
| Depuración | Reglas base identificadas para estructura, fallos, pendientes y reprocesos |

## 4. Reuniones y Acuerdos
- 2026-04-08: Revisión inicial del nuevo alcance contractual. Acuerdo: estructurar la documentación mensual con cinco líneas de trabajo y corte trimestral al 30 de junio.
- 2026-04-15: Revisión técnica del repositorio auxiliar Vida Saludable. Acuerdo: utilizarlo como referencia de arquitectura, proceso y evidencias operativas.
- 2026-04-22: Definición de métricas y entregables mensuales. Acuerdo: establecer línea base en abril y profundizar implementación y medición en mayo.
- 2026-04-29: Cierre mensual de análisis. Acuerdo: consolidar en mayo las pruebas, comparativos de rendimiento y evidencias de operación por lote.

## 5. Dificultades y Retos
- El cambio de contrato implicó redefinir el enfoque documental respecto a los meses anteriores, por lo que abril se dedicó parcialmente a reestructurar la evidencia requerida.
- Algunas actividades requieren todavía validación funcional y operativa adicional para traducir el análisis técnico en resultados medibles antes/después.
- La etapa de cartas no quedó completamente implementada en la evidencia revisada y debe cerrarse con reglas de negocio más explícitas.
- La línea de datos para IA depende de la consolidación de trazas, catálogos y resultados operativos para asegurar utilidad analítica real.
- El monitoreo y alertamiento requieren integración progresiva con ejecución real para calibrar umbrales y procedimientos de atención.
- La línea ETL/ELT exige separar con claridad el pipeline actualmente observable del soporte multiformato aún pendiente de implementación.

## 6. Próximos Pasos
- Consolidar la implementación y evidencia operativa del proceso Vida Saludable en sus etapas críticas, incluyendo lotes, descargas, bitácora y etapa posterior a `sin-carta`.
- Ejecutar mediciones comparativas de rendimiento con evidencia antes/después sobre consultas, índices y concurrencia.
- Formalizar el esquema de monitoreo y alertamiento con pruebas controladas y calibración inicial de umbrales.
- Avanzar en la curación de datasets piloto y en criterios de gobernanza para uso con IA.
- Documentar procesos ETL/ELT sobre insumos controlados, diferenciando claramente lo ya implementado de lo contractual.

---

**Comentarios adicionales:**

Abril se considera un mes de arranque y estructuración del nuevo contrato, pero ya con una delimitación técnica más precisa del proceso operativo base, de sus superficies de datos y de sus dependencias de observabilidad, rendimiento, IA y ETL/ELT. La continuidad deberá centrarse en convertir esta línea base en resultados medibles, datasets controlados, pruebas documentadas y evidencia operativa verificable para mayo y para el corte trimestral de junio.