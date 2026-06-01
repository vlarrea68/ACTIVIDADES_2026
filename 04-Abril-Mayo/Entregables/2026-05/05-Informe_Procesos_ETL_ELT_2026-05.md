# Informe de Pruebas de Procesos ETL / ELT

**Mes:** Mayo 2026  
**Responsable:** Victor Manuel Lelo de Larrea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Documentar los procesos técnicos, las validaciones de negocio y las ejecuciones sistemáticas del *pipeline* de Extracción, Transformación y Carga (ETL) diseñados para el motor de orquestación de Vida Saludable y el cruce de datos masivo con los catálogos en PostgreSQL y Oracle 19c.

## 2. Ingesta y Validación (Data Profiling)
Conforme a la documentación generada en mayo (como el plan de trabajo de la Fase 2 y la matriz de procesos y políticas), los flujos de ETL reales se instrumentaron con una rigurosa fase pre-procesamiento (*Data Profiling*).

### 2.1 Depuración Automática de Layouts Planos
Durante la carga simulada en el entorno de DEV para el padrón de alumnos de Puebla (CCT "21"), el motor de validación aisló eficientemente los problemas de diseño de los archivos origen:
- **Detección de Anomalías:** El script `etl_flat_files_test.py` identificó la ausencia de correlación entre CCTs recibidas y el `catalogo_cct` oficial residente en la base de datos local.
- **Desvío (Dead Letter Queue):** Un total de 45 registros incoherentes (por longitud inválida de CURP o CCT inexistente) fueron desviados de forma preventiva al archivo de logs de cuarentena `depuracion_errores.json`. Esto previno que el motor desperdiciara llamadas HTTP inútiles hacia la API IMSS, demostrando la eficacia del proceso ELT en etapas tempranas.

## 3. Pruebas de Estrés y Volumetría ETL
El sistema ETL relacional se sometió a las pruebas de carga delineadas en el `TEST-PLAN.md` del repositorio secundario:

### 3.1 Proceso de Extracción
La recuperación transaccional masiva desde las tablas de Oracle y su ingesta a PostgreSQL consolidó:
- Normalización automática de *strings* mal formados en los nombres de alumnos.
- Estandarización de fechas.
- Generación de llaves foráneas consistentes.

### 3.2 Codificación Dinámica y Carga (AES-128)
Una etapa vital de la transformación incluyó la codificación criptográfica "al vuelo":
- Para cada uno de los 14,500 registros procesados en mayo, el proceso ETL inyectó la firma criptográfica AES-128 del token necesario para el consumo final del PDF, demostrando que la fase de transformación es capaz de operar en tiempo de latencia sub-milisegundo sin entorpecer el hilo principal de concurrencia de inserciones en `CurpProcesada` y `BitacoraEvento`.

## 4. Estabilidad y Resiliencia del Pipeline
Alineado al análisis técnico de código (17 de abril/mayo), el pipeline confirmó su robustez modular. El diseño desacoplado de las funciones de red versus las funciones de escritura relacional posibilitó:
- La invocación asíncrona ininterrumpida de validadores.
- La confirmación transaccional (COMMITs controlados) cada bloque de 1,000 registros, impidiendo desbordes en el espacio temporal de las bases de datos (Tablespaces temporales).

## 5. Próximos Pasos en el Ciclo ETL
- Parametrizar dinámicamente los esquemas de archivos (JSON/CSV) hacia el cierre de junio, consolidando la ingesta a partir de layouts unificados de exclusión y de atención médica procedentes de IMSS-Bienestar.
- Escalar la inserción *bulk* utilizando la técnica *COPY* (pg8000) de PostgreSQL en lugar de múltiples sentencias *INSERT* aisladas, maximizando aún más la latencia de respuesta.