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


## Informes Mensuales

Es obligatorio generar **informes mensuales** de las actividades realizadas. Estos informes deben documentar el avance, los logros, los retos y los acuerdos relevantes de cada mes. Se recomienda almacenar estos informes dentro de la carpeta `Entregables/` correspondiente a cada periodo, usando un formato de nombre como `Informe_Mensual_YYYY-MM.md`.

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
│   └── Reuniones/
├── 05-Mayo-Junio/
│   ├── Actividades/
│   ├── Datos/
│   ├── Entregables/
│   └── Reuniones/
└── README.md
```

### Descripción de las Carpetas

*   **`Actividades/`**: Contiene documentos de trabajo, análisis, notas y cualquier archivo relacionado con la ejecución de las tareas del período.
*   **`Datos/`**: Almacena los datos brutos, scripts (SQL, Python, etc.), y resultados de análisis.
*   **`Entregables/`**: Guarda los borradores y versiones finales de los reportes, documentos de arquitectura, y otros entregables formales.
*   **`Reuniones/`**: Archiva las minutas, acuerdos y presentaciones de las reuniones de seguimiento de proyectos. Se recomienda nombrar los archivos con el formato `YYYY-MM-DD_Tema_de_la_Reunion.md`.

## Resumen de Actividades y Entregables

| Meses     | Actividades                                                  | Entregables                                               |
| :-------- | :----------------------------------------------------------- | :-------------------------------------------------------- |
| **Ene-Feb** | 1. Analizar diagnóstico inicial del ecosistema de datos.     | 1. (Reporte) Diagnóstico del ecosistema de datos.         |
|           | 2. Recomendar arquitectura de datos.                         | 2. (Documento) Propuesta de arquitectura de datos.        |
| **Feb-Mar** | 3. Desarrollar procesos de ingesta y transformación (ETL/ELT). | 3. (Bitácora / Evidencia) Pipelines ETL/ELT implementados.|
| **Mar-Abr** | 4. Desarrollar APIs de datos.                                | 4. (Documentación Técnica) Catálogo de APIs de datos.     |
| **Abr-May** | 5. Analizar y optimizar rendimiento de bases de datos.       | 5. (Informe) Optimización de rendimiento.                 |
| **May-Jun** | 6. Desarrollar e implementar monitoreo y alertamiento.       | 6. (Tablero / Reporte) Esquema de monitoreo.              |
|           | 7. Elaborar datasets para uso con Inteligencia Artificial.   | 7. (Reporte) Preparación de datos para IA.                |
|           | 8. Verificar y consolidar el cierre documental 2026.         |                                                           |
| **Junio**   |                                                              | 8. (Memoria Documental) Expediente Anual.                 |
