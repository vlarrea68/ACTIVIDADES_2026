# Informe Mensual de Actividades

**Mes:** Mayo 2026  
**Responsable:** Victor Manuel Lelo de Larrea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Resumen Ejecutivo
Durante mayo de 2026, el trabajo de la Coordinación de Proyectos de TI se enfocó en convertir las especificaciones técnicas y lineamientos de la línea base aprobada en abril en evidencia operativa verificable. Este informe resume el comportamiento medido y los resultados obtenidos en las cinco líneas de trabajo del contrato: el proyecto Vida Saludable (orquestador de descargas masivas), la optimización de rendimiento de bases de datos (Oracle y PostgreSQL), el monitoreo e incidentes de seguridad, la preparación de datasets desidentificados para inteligencia artificial, y las pruebas controladas del pipeline ETL.

Los principales hitos del mes incluyeron la definición de los esquemas (layouts) definitivos de la Fase 2, el procesamiento coordinado de **14,500 registros** a nivel de CURP en tres estados prioritarios (Veracruz, Puebla y el Estado de México), logrando una alta tasa final de descarga de PDFs del **98.82%** gracias al despliegue automático de reintentos (*circuit breakers*). 

Asimismo, se instrumentaron optimizaciones directas de índices compuestos en la base de datos de desarrollo, reduciendo los tiempos de extracción en un **94.3%**, y se enfrentó con éxito un incidente de seguridad (exposición de 128 mil registros CSV) validando la pronta respuesta y reescritura de los repositorios de código. 

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

## 3. Actividades Realizadas en Mayo (5 Entregables)

### 3.1 Operación del Proyecto Vida Saludable y Layouts (Fase 2)
Se ejecutaron corridas principales del orquestador correspondientes a alumnos de Veracruz, Puebla y la reanudación programada de lotes:
- **`LOTE-202605-01` (Veracruz):** 5,500 registros procesados, de los cuales 5,340 resultaron en descargas físicas exitosas.
- **`LOTE-202605-02` (Puebla):** 6,200 registros procesados, mitigando activamente una degradación en la API externa limitando a 10 hilos concurrentes.
- **`LOTE-202605-03_REPROCESO` (EdoMex/Coahuila):** 2,800 descargas completadas de manera automatizada.
- **Estandarización de Layouts:** Se consolidaron formalmente los esquemas en el documento `04-DEFINICION-LAYOUTS.md`, incluyendo los campos requeridos para las importaciones de "Alumnos Evaluados", "Sin Padecimientos", y los layouts clínicos "IMSS / IMSS-Bienestar".

### 3.2 Rendimiento y Optimización de Bases de Datos
Se evaluó el comportamiento de la base de datos frente al procesamiento concurrente masivo en los esquemas gestionados:
- **`SEP_MUSEMS_PU` (Oracle):** Se estableció formalmente el orden de limpieza relacional (`BEST_PRACTICES_DB_SCRIPTS.md`) evitando los bloqueos de foráneas durante las sentencias `simulation_ultra.sql`.
- **Vida Saludable (PostgreSQL):** La creación del índice compuesto `idx_menor_evaluado_cct_curp_ciclo` mejoró los tiempos de extracción de un promedio de **3.20 segundos** a **0.18 segundos**.
- **Análisis de hilos (`WORKERS`):** Pruebas de estrés mostraron que elevar la concurrencia a 20 hilos causa timeouts en el pool de conexiones `pg8000`. Se limitó a un rango de **12 a 15 hilos**.

### 3.3 Monitoreo y Alertamiento Técnico (Seguridad)
Se documentaron e instrumentaron resoluciones críticas derivadas de monitoreo preventivo:
- **Fuga de Datos Sensibles (LGPDPPSO):** El 17 de abril se detectó un commit accidental con 128,112 registros PII. Se aplicó una remediación drástica mediante limpieza del historial de Git (`git filter-repo`) y creación de un `pre-commit` hook preventivo.
- **Incidentes UI (Issue 45):** Se detectó y remedió un problema de *Information Leakage* en el Frontend del repositorio secundario mediante un rediseño del menú y protecciones de rutas (`ProtectedRoute`) avaladas contra los permisos de Oracle.

### 3.4 Preparación de Datasets para Inteligencia Artificial
Derivado de la contingencia de seguridad con CSVs expuestos, se aplicaron lineamientos rígidos de enmascaramiento:
- Ningún dataset predictivo almacenará CURP ni Nombres. Todo se ofuscó usando criptografía MD5 (`MD5_HASH(CURP + SALT)`).
- Se depuraron cuatro conjuntos de datos piloto (Rendimiento, Anonimizado, Incidencias, Descargas) para entrenar los algoritmos iniciales de distribución de tráfico e inferencia de fallos en llamadas HTTP.

### 3.5 Pipeline Ingesta, Validación y Carga (ETL)
Se validaron los flujos del proceso ELT aislando el pre-procesamiento de archivos en texto plano.
- Un total de **45 incoherencias de CURP** detectadas en los layouts del lote Puebla fueron desviadas automáticamente al archivo log `depuracion_errores.json`, evitando llamadas erróneas a la API y previendo la caída del pipeline.
- Las pruebas de carga confirmaron que la codificación AES-128 "al vuelo" del token de consulta operó con tiempos transaccionales óptimos bajo concurrencia.

---

## 4. Próximos Pasos (Cierre Trimestral Junio)
- Consolidar la entrega documental del semestre preparando el corte trimestral del 30 de junio de 2026.
- Extender las pruebas del proceso de generación de cartas de consentimiento a partir del script de fusión docx piloto.
- Presentar comparativas cuantitativas integrales de rendimiento técnico de base de datos post-índices compuestos.
- Vigilar la correcta operación de los hooks de seguridad de Git para imposibilitar nuevas vulneraciones de información personal.

---

**Comentarios adicionales:**
Este documento y sus entregables adjuntos asientan la evidencia del mes de mayo, superando los incidentes detectados y ratificando la estabilidad y robustez del código fuente en los entornos institucionales auditados.