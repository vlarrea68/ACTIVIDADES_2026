## Reportes Mensuales

Existe una carpeta `Reportes/` en la raíz del repositorio para almacenar los informes mensuales de actividades realizadas. Dentro de esta carpeta, se recomienda crear subcarpetas por mes (por ejemplo, `2026-01`, `2026-02`, etc.) y guardar ahí los reportes correspondientes. Esto facilita la consulta y el seguimiento histórico de los avances.

Ejemplo de estructura:

```
Reportes/
├── 2026-01/
│   └── Informe_Mensual_2026-01.md
├── 2026-02/
│   └── Informe_Mensual_2026-02.md
...
```
# Gestión de Actividades y Entregables - Primer Semestre 2026

## Propósito del Repositorio

Este repositorio centraliza la información, actividades, datos y entregables correspondientes al plan de trabajo de la Coordinación de Proyectos de TI para el primer semestre de 2026. El objetivo es mantener un registro organizado para la generación de reportes de avance mensuales.

Para reconstruir el flujo de generación de documentos y variantes Word en otra computadora, revisar también `GUIA_GENERACION_REPORTES_Y_DOCX.md` en la raíz del repositorio.


## Informes Mensuales

Es obligatorio generar **informes mensuales** de las actividades realizadas. Estos informes deben documentar el avance, los logros, los retos y los acuerdos relevantes de cada mes. La ubicación recomendada para los informes mensuales generales es `Reportes/YYYY-MM/`, usando nombres como `Informe_Mensual_YYYY-MM.md`.

Los entregables de soporte por periodo deben almacenarse dentro de la carpeta `Entregables/` correspondiente, separados por subcarpetas mensuales como `2026-04/`, `2026-05/` o `2026-06/`. Esta separación evita mezclar línea base, avances operativos y cierres trimestrales dentro de una misma carpeta.

## Estructura de Carpetas

El repositorio está organizado por períodos bimestrales para alinear el trabajo con las fechas de entrega de las actividades principales.

```
.
├── 01-Enero-Febrero/
│   ├── Actividades/
│   ├── Datos/
│   ├── Entregables/
│   └── Reuniones/
├── 02-Febrero-Marzo/
│   ├── Actividades/
│   ├── Datos/
│   ├── Entregables/
│   └── Reuniones/
├── 03-Marzo-Abril/
│   ├── Actividades/
│   ├── Datos/
│   ├── Entregables/
│   └── Reuniones/
├── 04-Abril-Mayo/
│   ├── Actividades/
│   ├── Datos/
│   ├── Entregables/
│   │   ├── 2026-04/
│   │   ├── 2026-05/
│   │   └── Marco_Operativo_Contrato_Abr-Jun_2026.md
│   └── Reuniones/
├── 05-Mayo-Junio/
│   ├── Actividades/
│   ├── Datos/
│   ├── Entregables/
│   │   └── 2026-06/
│   └── Reuniones/
├── Reportes/
│   ├── 2026-04/
│   ├── 2026-05/
│   └── 2026-06/
└── README.md
```

### Descripción de las Carpetas

*   **`Actividades/`**: Contiene documentos de trabajo, análisis, notas y cualquier archivo relacionado con la ejecución de las tareas del período.
*   **`Datos/`**: Almacena los datos brutos, scripts (SQL, Python, etc.), y resultados de análisis.
*   **`Entregables/`**: Guarda los documentos de soporte, borradores y versiones finales de entregables formales del periodo. Cuando un periodo cubre más de un mes, se recomienda separarlos en subcarpetas mensuales.
*   **`Reuniones/`**: Archiva las minutas, acuerdos y presentaciones de las reuniones de seguimiento de proyectos. Se recomienda nombrar los archivos con el formato `YYYY-MM-DD_Tema_de_la_Reunion.md`.

## Resumen de Actividades y Entregables

| Meses     | Actividades                                                  | Entregables                                               |
| :-------- | :----------------------------------------------------------- | :-------------------------------------------------------- |
| **Ene-Feb** | 1. Analizar diagnóstico inicial del ecosistema de datos.     | 1. (Reporte) Diagnóstico del ecosistema de datos.         |
|           | 2. Recomendar arquitectura de datos.                         | 2. (Documento) Propuesta de arquitectura de datos.        |
| **Feb-Mar** | 3. Desarrollar procesos de ingesta y transformación (ETL/ELT). | 3. (Bitácora / Evidencia) Pipelines ETL/ELT implementados.|
| **Mar-Abr** | 4. Desarrollar APIs de datos.                                | 4. (Documentación Técnica) Catálogo de APIs de datos.     |
| **Abr-Jun** | 5. Analizar y desarrollar el proceso completo del proyecto Vida Saludable. | 1. (Reporte con especificaciones) Desarrollo e implementación por etapas del proyecto Vida Saludable. |
|           | 6. Analizar rendimiento de bases de datos y ejecutar optimizaciones con evidencia antes/después. | 2. (Informe mensual) Optimización de rendimiento con hallazgos, impacto y capacity planning. |
|           | 7. Desarrollar y recomendar monitoreo y alertamiento para BD, APIs y pipelines. | 3. (Reporte mensual) Esquema de monitoreo y alertamiento con métricas, umbrales y evidencias. |
|           | 8. Elaborar datasets para uso con Inteligencia Artificial y lineamientos básicos de calidad y gobernanza. | 4. (Reporte mensual) Preparación de datos para IA con curación, criterios de calidad y recomendaciones. |
|           | 9. Desarrollar procesos de ingesta y transformación (ETL/ELT) para múltiples formatos. | 5. (Informe mensual) Procesos ETL/ELT con especificaciones, validaciones y depuración. |
| **Junio**   | Continuidad operativa y cierre trimestral de evidencias.     | Corte trimestral al 30 de junio de 2026 para las cinco líneas de trabajo. |

## Convención Actual de Organización

- Los informes mensuales generales se resguardan en `Reportes/YYYY-MM/`.
- Los entregables de soporte del periodo se resguardan en `Entregables/YYYY-MM/` dentro del bloque bimestral correspondiente.
- Abril debe conservar la línea base técnica y documental.
- Mayo debe concentrar evidencia operativa, validaciones y resultados del mes.
- Junio debe concentrar cierre trimestral, comparativos y conclusiones finales.
