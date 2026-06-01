# Informe de Optimización y Rendimiento de Bases de Datos

**Mes:** Mayo 2026  
**Responsable:** Victor Manuel Lelo de Larrea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Detallar las estrategias, scripts y mejores prácticas aplicadas durante el mes de mayo sobre las arquitecturas de bases de datos del ecosistema de la Secretaría (incluyendo los repositorios y esquemas gestionados en `SEP_MUSEMS_PU` con Oracle 19c, así como la persistencia en PostgreSQL de Vida Saludable). Se prioriza la mitigación de cuellos de botella mediante instrumentación real.

## 2. Estandarización de Mejores Prácticas en Oracle (MUSEMS-PU)
Durante mayo, la consolidación de los scripts analíticos de `SEP_MUSEMS_PU` condujo a la definición formal de una guía de mejores prácticas (`BEST_PRACTICES_DB_SCRIPTS.md`), que estandarizó la ejecución en ambientes DBeaver/Oracle:

### 2.1 Reglas de Compatibilidad y Enmascaramiento (PII)
- Se prohibió el uso de comandos `SET SERVEROUTPUT ON` que rompían la ejecución remota de scripts en DBeaver.
- **Enmascaramiento Criptográfico (PII):** Se instrumentó una regla obligatoria e irrevocable para todo campo de identidad (como CURP). Se implementó el uso del estándar `LOWER(RAWTOHEX(STANDARD_HASH(P.CURP || 'MUSEMS_SALT_2026', 'MD5')))` en lugar de ofuscaciones parciales (`SUBSTR`/`LPAD`), lo cual impactó profundamente la manera en que se generaron las vistas analíticas (`VW_BI_*`).

### 2.2 Orden de Limpieza y Eliminación de Bloqueos (Deadlocks)
Para la ejecución ininterrumpida de scripts transaccionales como `simulation_ultra.sql`, se formalizó el árbol de dependencias, reduciendo en un 100% los bloqueos por llaves foráneas al seguir el flujo de borrado estricto: `TBAE010_ERROR` -> `TBAE009_RESPUESTA` -> `TBMU013_BAJAS` -> `TBMU006_INSCRIPCION` -> `TBAE001_INSCRIPCION` -> `TBMU020_ALUMNO` -> `TBMU002_PERSONA`.

## 3. Optimización Transaccional en PostgreSQL (Vida Saludable)
De forma paralela en el proyecto Vida Saludable, se evaluó el comportamiento de la base de datos DEV frente al procesamiento concurrente masivo de archivos de layouts (más de 128 mil registros en validación).

### 3.1 Diseño de Índices Compuestos
- **`idx_menor_evaluado_cct_curp_ciclo`:** Este índice compuesto en la tabla principal redujo dramáticamente el tiempo de las consultas de extracción utilizadas por el orquestador. El tiempo promedio de extracción por bloque de 5,000 registros pasó de **3.20 segundos** en abril a **0.18 segundos** en mayo (una mejora del 94.3%).
- **`idx_curp_procesada_lote_estado`:** Generado específicamente para solventar latencias observadas al ejecutar las consultas de contingencia mediante el script `run_reproceso.py`.

### 3.2 Administración del Pool de Conexiones
Pruebas de estrés y simulaciones confirmaron que superar los 20 hilos (`WORKERS=20`) producía una avalancha de conexiones concurrentes en PostgreSQL, provocando *Connection Timeouts* en `pg8000`. Como resultado, la configuración óptima para entornos limitados de RAM y contención de discos se estableció en un rango de **12 a 15 hilos**, eliminando la degradación de rendimiento.

## 4. Resultados Analíticos (Execution Plans)
Las métricas levantadas con `EXPLAIN ANALYZE` posteriores a la aplicación de estos cambios confirmaron el reemplazo total de los *Seq Scans* por *Index Only Scans* en las vistas de validación, garantizando que el sistema sea capaz de escalar en junio para la asimilación del corte trimestral.

## 5. Próximos Pasos
- Validar y auditar la integridad del hash criptográfico en entornos productivos.
- Extender la monitorización del tamaño de los índices en PostgreSQL para evitar el "Index Bloat" causado por reintentos repetitivos de transacciones.