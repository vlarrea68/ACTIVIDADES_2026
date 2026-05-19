# Marco Operativo del Contrato Abril-Junio 2026

**Periodo:** Abril a junio de 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Propósito
Documentar el alcance operativo, técnico y documental del nuevo contrato de trabajo correspondiente al periodo abril-junio de 2026, estableciendo la relación entre actividades, entregables, evidencias esperadas y periodicidad de reporte.

## 2. Alcance General
Durante abril, mayo y junio de 2026 se desarrollarán cinco líneas de trabajo complementarias:

1. Analizar y desarrollar el proceso completo del proyecto Vida Saludable, incluyendo preparación de insumos, validación de datos, inserción en base de datos, descarga de archivos PDF con informe de IMSS, generación de cartas, métricas, logs y trazas.
2. Analizar el rendimiento de bases de datos, revisando consultas, índices, planes de ejecución y parametrización para ejecutar optimizaciones medibles.
3. Desarrollar y recomendar un esquema de monitoreo y alertamiento para bases de datos, APIs y pipelines, con métricas, umbrales y procedimientos de atención.
4. Elaborar datasets para uso con inteligencia artificial, incluyendo features, embeddings cuando aplique y lineamientos básicos de calidad y gobernanza.
5. Desarrollar procesos de ingesta y transformación (ETL/ELT) para formatos CSV, XLSX, JSON y XML, incluyendo validaciones y depuración.

## 3. Referencia Técnica Principal
Como insumo operativo principal para esta etapa se utilizará el conocimiento técnico del proyecto `py-sep-descarga-vida-saludable`, particularmente en los siguientes componentes:

- Definición de esquema de base de datos en PostgreSQL.
- Proceso de orquestación de lotes y validación de archivos de entrada.
- Descarga y resguardo de archivos PDF asociados al proceso.
- Registros operativos, métricas, logs de ejecución y mecanismos de reproceso.
- Scripts de ejecución por lote, reintento y continuación de procesos.

## 4. Matriz de Actividades y Entregables

| Línea de trabajo | Actividad principal | Entregable asociado | Periodicidad |
|------------------|--------------------|---------------------|--------------|
| Vida Saludable | Desarrollo integral del flujo operativo y técnico | Reporte con especificaciones del desarrollo e implementación por etapas | Avance mensual abril-mayo y corte trimestral en junio |
| Rendimiento de BD | Análisis y optimización de consultas e índices | Informe mensual de optimización de rendimiento | Avance mensual abril-mayo y corte trimestral en junio |
| Monitoreo y alertamiento | Definición de métricas, umbrales y procedimientos | Reporte mensual de esquema de monitoreo y alertamiento | Avance mensual abril-mayo y corte trimestral en junio |
| Datos para IA | Curación de datos y lineamientos de calidad | Reporte mensual de preparación de datos para IA | Avance mensual abril-mayo y corte trimestral en junio |
| ETL/ELT | Procesos de ingesta, transformación, validación y depuración | Informe mensual con especificaciones de procesos ETL/ELT | Avance mensual abril-mayo y corte trimestral en junio |

## 5. Etapas del Proceso Vida Saludable
Para fines de documentación y seguimiento mensual, el proceso Vida Saludable se desglosa en las siguientes etapas:

1. Recepción y preparación de insumos.
2. Validación de estructura y calidad de archivos de entrada.
3. Inserción o registro de información en base de datos.
4. Ejecución de procesos de descarga de PDFs e informes relacionados con IMSS.
5. Generación de cartas y preparación para entrega.
6. Registro de métricas, logs, trazas y evidencias operativas.
7. Reproceso controlado de incidencias y cierre por lote.

## 6. Evidencias Esperadas por Mes

| Tipo de evidencia | Descripción mínima esperada |
|-------------------|-----------------------------|
| Bitácoras de ejecución | Fechas, lotes procesados, resultados, errores y acciones correctivas |
| Evidencia técnica | Scripts, configuraciones, layouts, consultas SQL, diagramas o matrices |
| Métricas | Tiempos de ejecución, volumen de registros, fallos, reprocesos, tasas de éxito |
| Validaciones | Reglas de negocio, revisión de formatos, consistencia de datos y controles de calidad |
| Comparativos | Antes/después de optimizaciones, ajustes de índices, mejoras de tiempos o reducción de errores |
| Recomendaciones | Siguientes pasos, riesgos, dependencias y decisiones técnicas |

## 7. Criterios de Documentación
- Los avances mensuales deberán registrarse dentro de `Reportes/YYYY-MM/`.
- Los documentos de soporte deberán resguardarse dentro de la carpeta `Entregables/` del periodo correspondiente, separados por subcarpetas mensuales como `2026-04/`, `2026-05/` o `2026-06/`.
- La documentación técnica deberá mantener trazabilidad entre actividad, evidencia y entregable mensual.
- Se evitará escribir información operativa fuera del repositorio `ACTIVIDADES_2026`.

## 8. Enfoque para Abril 2026
El mes de abril se considera de arranque formal del contrato, por lo que los entregables deben centrarse en:

- Levantamiento y análisis del proceso integral de Vida Saludable.
- Identificación de componentes reutilizables del repositorio auxiliar.
- Establecimiento de la línea base de rendimiento, monitoreo y calidad de datos.
- Definición de estructura documental para avances de abril, mayo y corte trimestral de junio.

---

**Comentarios adicionales:**

Este documento funciona como referencia base para la producción documental de abril-junio 2026. Su objetivo es asegurar consistencia entre las actividades del nuevo contrato, la evidencia técnica generada y los reportes mensuales que se entregarán durante el trimestre.