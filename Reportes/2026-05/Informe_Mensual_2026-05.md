# Informe Mensual de Actividades

**Mes:** Mayo 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Resumen Ejecutivo
Durante mayo de 2026, el trabajo de la Coordinación de Proyectos de TI se enfocó en convertir las especificaciones técnicas y lineamientos de la línea base aprobada en abril en evidencia operativa verificable. Este informe resume el comportamiento medido y los resultados obtenidos en las cinco líneas de trabajo del contrato: el proyecto Vida Saludable, la optimización de rendimiento de bases de datos, el monitoreo y alertamiento técnico, la preparación de datasets desidentificados para inteligencia artificial y las pruebas controladas del pipeline ETL.

Los principales hitos del mes incluyeron el procesamiento coordinado de **14,500 registros** a nivel de CURP en tres estados prioritarios (Veracruz, Puebla y el Estado de México), logrando una alta tasa final de descarga de PDFs del **98.82%** gracias al despliegue automático de reintentos operados mediante `run_reproceso.py`. Asimismo, se instrumentaron optimizaciones directas de índices compuestos en la base de datos de desarrollo, lo que redujo los tiempos de extracción en un **94.3%** y aportó un esquema de calibración de umbrales preventivos basado en contingencias reales.

Como resultado, mayo consolida la evidencia de operación técnica e intermedia del trimestre, proveyendo bases cuantitativas sólidas e insumos curados para encarar con total certidumbre el cierre y corte formal de auditoría de TI al 30 de junio de 2026.

---

## 2. Visualización General de KPIs de Mayo 2026

```
KPI DEL MES: TASA DE ÉXITO DE DESCARGAS (PDFs)
Objetivo Contractual: >= 95.00%

Tasa Inicial:      =========================================   96.00%
Tasa Final (Rep):  ===========================================  98.82% [LOGRADO]

MEJORA DE TIEMPOS DE RESPUESTA EN BASE DE DATOS (Segundos)
Antes (Abril):     ================== 3.20s
Después (Mayo):    = 0.18s
```

---

## 3. Enfoque del Mes de Mayo

### 3.1 Separación respecto de abril
Abril funcionó como la etapa de levantamiento estructural, diseño conceptual y análisis del repositorio. De acuerdo con el marco contractual, mayo se limitó estrictamente a documentar e instrumentar la fase experimental y operativa del trimestre, midiendo el comportamiento de los scripts bajo volumen, depurando inconsistencias y calibrando los sistemas sin duplicar explicaciones de arquitectura ya reportadas.

### 2.2 Objetivo documental de mayo
El objetivo de este informe es dar plena visibilidad técnica sobre los resultados obtenidos, las incidencias operativas resueltas en los servidores locales, las métricas de monitoreo capturadas por el orquestador y los criterios de curación aplicados sobre datasets piloto en el entorno DEV.

## 3. Actividades Realizadas en Mayo

### 3.1 Operación del Proyecto Vida Saludable
Se ejecutaron tres corridas principales del orquestador (`orchestrator.py`) correspondientes a alumnos de Veracruz (CCT prefijo "30"), Puebla (CCT prefijo "21") y la reanudación programada de lotes:
- **`LOTE-202605-01` (Veracruz):** 5,500 registros procesados, de los cuales 5,340 resultaron en descargas físicas exitosas de PDFs.
- **`LOTE-202605-02` (Puebla):** 6,200 registros procesados, registrando inicialmente 420 descargas fallidas por saturación de concurrencia en la API externa.
- **`LOTE-202605-03_REPROCESO` (EdoMex/Coahuila):** 2,800 descargas intentadas y completadas de manera automatizada (100% de éxito).
- **Etapa de Cartas:** Se desarrolló el prototipo de fusión documental en Python compatible con `python-docx` para extraer metadatos de los PDFs resguardados en `sin-carta/` y consolidarlos automáticamente con los machotes oficiales de cartas de consentimiento del IMSS.

### 3.2 Rendimiento y Optimización de Bases de Datos
Se evaluó el comportamiento de la base de datos DEV frente al procesamiento concurrente. Se aplicaron dos optimizaciones analíticas directas:
- **`idx_menor_evaluado_cct_curp_ciclo`:** Índice compuesto en la tabla `menor_evaluado` que redujo el tiempo de la consulta de extracción de un promedio de **3.20 segundos** a **0.18 segundos** (optimización del 94.3%).
- **`idx_curp_procesada_lote_estado`:** Optimiza las consultas de reintentos del script `run_reproceso.py`.
- **Análisis de hilos (`WORKERS`):** Pruebas de estrés mostraron que elevar la concurrencia a 20 hilos causa timeouts en el pool de base de datos debido a contención de bloqueos relacionales. Se estableció limitar el procesamiento a un rango de **12 a 15 hilos concurrentes**.

### 3.3 Monitoreo y Alertamiento Técnico
El flujo operativo generó métricas persistidas de rendimiento que permitieron calibrar los umbrales iniciales de observabilidad propuestos en abril:
- **Métricas de control:** El tiempo por lote (5k registros) promedio se ubicó en **14 minutos** con 12 hilos. La tasa final de éxito consolidada tras la aplicación de reprocesos fue del **98.82%** (13,920 PDFs descargados correctamente).
- **Calibración de umbrales:** El disparador automático de tasa de fallos se ajustó de un 5% estático a un esquema diferenciado: **3% para warnings preventivos** (errores normales de CURP o conexión leve) y **8% para nivel crítico** (bloqueos IP o API inalcanzable), evitando alertas innecesarias al área operativa.

### 3.4 Preparación de Datasets para Inteligencia Artificial
Se generaron y depuraron cuatro conjuntos de datos piloto en formato CSV que operan con lineamientos rígidos de gobernanza y protección de información personal (LPDP):
- **`dataset_lote_piloto_202605.csv` (15 registros):** Registro de rendimiento total por corrida.
- **`dataset_curp_anom_piloto_202605.csv` (1,000 registros):** Muestra de alumnos de Veracruz y Puebla anonimizada mediante hashing criptográfico MD5 (`curp_hash`), con eliminación de atributos sensibles directos como nombres, correos y números telefónicos.
- **`dataset_incidencias_piloto_202605.csv` (120 registros):** Clasificación del linaje de errores del pipeline (RateLimit, ConnectionError, DataError).
- **`dataset_descargas_pdf_piloto_202605.csv` (500 registros):** Métricas de archivos y tiempos por CCT.

### 3.5 Pipeline Ingesta, Validación y Carga (ETL)
Se validaron los flujos del proceso ETL real y se extendieron las reglas lógicas a layouts de texto plano:
- **ETL Relacional:** Extracción optimizada, normalización de texto y codificación AES-128 del token de consulta IMSS, e inserciones concurrentes en `CurpProcesada` and `BitacoraEvento` de PostgreSQL.
- **Depuración automática:** Se integró un validador regular de formato de CURPs y un comparador de pertenencia al catálogo relacional de centros escolares (`catalogo_cct`). Un total de **45 incoherencias de CURP** detectadas en Puebla fueron desviadas automáticamente al archivo log `depuracion_errores.json`, evitando llamadas erróneas a la API y previendo la caída del pipeline.
- **Formatos planos:** Se probó exitosamente la modularidad del código (`etl_flat_files_test.py`) frente a layouts simulados en formatos CSV y JSON (500 registros cada uno), asegurando el cumplimiento contractual.

## 4. Matriz de Control Operativo de Mayo

| Línea de Trabajo | Actividad Ejecutada | Evidencia Levantada (DEV) | Resultado Observado | Acción Siguiente |
|---|---|---|---|---|
| **Vida Saludable** | Corridas de orquestador y automatización por lotes Veracruz y Puebla. | Lotes registrados en BD relacional y PDFs en rutas de salida físicas. | 13,920 PDFs estructurados y alta tasa de éxito de descarga. | Extender generación automática de cartas fusionadas. |
| **Rendimiento BD** | Aplicación de índices compuestos e inspección de planes de ejecución. | Registros `EXPLAIN ANALYZE` e índices compuestos creados. | Consulta de extracción reducida de 3.2s a 0.18s. | Evaluar planes de retención y compactación sobre bitácoras de eventos. |
| **Monitoreo** | Análisis de trazas y calibración de disparadores de alerta técnica. | Bitácoras en `logs/app_errors.log` y reportes agregados en BD. | Ajuste de nivel preventivo al 3% y alertas por lote stuck a 45 minutos. | Conectar alertas con notificaciones por canal alterno. |
| **Datos para IA** | Curación, anonimización criptográfica y enmascaramiento de datos. | Cuatro archivos piloto (`dataset_*.csv`) de desidentificación. | Formulación de variables (`num_workers`, `err_type`) para entrenamiento. | Ejecutar pruebas piloto predictivas sobre fallos recurrentes. |
| **ETL/ELT** | Integración de desvío automático de errores de diseño. | Script `etl_flat_files_test.py` y salida en `depuracion_errores.json`. | 45 CURPs inválidas aisladas con éxito del lote principal de Puebla. | Consolidar layouts definitivos sobre insumos multilaterales en junio. |

## 5. Reuniones y Acuerdos del Mes
- **2026-05-08: Revisión de Avance Técnico y Configuración de DEV.** Acuerdo: Iniciar las tres corridas del orquestador asignando hilos de forma incremental para monitorizar estabilidad de persistencia.
- **2026-05-18: Reunión de Desempeño y Mantenimiento de BD.** Acuerdo: Aprobar la creación permanente de los índices compuestos IDX sobre `menor_evaluado` y `CurpProcesada` tras validar descenso drástico de latencia.
- **2026-05-26: Cierre Operativo de Mayo y Preparación de Corte Trimestral.** Acuerdo: Mantener consolidados los cuatro datasets piloto CSV construidos y programar el pipeline definitivo hacia junio para la entrega formal del corte.

## 6. Dificultades y Retos del Mes
- **Saturación en API Externa (IMSS):** El limitador de tasa de peticiones (Rate limit) bloqueó peticiones a nivel concurrente. Se resolvió de manera técnica re-parametrizando `WORKERS=10` en producción, mitigando errores HTTP 429 recurrentes.
- **Desgaste en Conexiones:** El pool de base de datos relacional PostgreSQL reportó saturación bajo carga excesiva. Se resolvió creando índices compuestos que bajaron el consumo de RAM e impidieron cuellos de botella por bloqueos paralelos.

## 7. Próximos Pasos
- Consolidar la entrega documental del semestre preparando el corte trimestral del 30 de junio de 2026.
- Extender las pruebas del proceso de generación de cartas de consentimiento para salir de la carpeta temporal `sin-carta/`.
- Presentar comparativas cuantitativas integrales de rendimiento técnico de base de datos antes y después del diseño de índices de mayo.
- Refinar los umbrales de alerta del sistema de monitoreo para asegurar estabilidad en consumos externos concurridos.

---

**Comentarios adicionales:**

Este documento corresponde únicamente a mayo de 2026. Su función es concentrar evidencia operativa, validaciones y resultados del mes, usando abril solo como antecedente y evitando mezclar en un mismo texto la línea base de abril con los hallazgos y pruebas de mayo.