# Reporte Mensual de Monitoreo y Alertamiento

**Mes:** Abril 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Presentar el avance mensual de abril de 2026 del esquema de monitoreo y alertamiento para bases de datos, APIs y pipelines, incluyendo métricas definidas, umbrales, alertas, procedimientos de atención y evidencia de pruebas cuando aplique.

## 2. Alcance del Avance de Abril
Durante abril se definió un esquema base de observabilidad orientado al seguimiento operativo del proyecto Vida Saludable y sus componentes de soporte, con énfasis en métricas, logs, trazas y procedimientos iniciales de atención ante incidentes.

El análisis se sustentó en los componentes reales del repositorio `py-sep-descarga-vida-saludable`, particularmente en:
- `logging_utils.py`, que configura el registro estructurado a consola y archivo;
- `orchestrator.py`, que concentra el ciclo de vida del lote, el procesamiento concurrente de CURP, los reintentos y el registro de resultados;
- la tabla `BitacoraEvento`, utilizada para almacenar eventos por CURP procesada;
- la tabla `Lote`, utilizada para controlar ejecuciones activas, reanudaciones y cierres.

Con base en ello, abril se utilizó para delimitar el qué monitorear, cómo clasificar eventos y qué umbrales iniciales deben servir como base para mayo, cuando ya exista evidencia operativa más medible.

## 3. Contexto Técnico del Monitoreo
El proceso Vida Saludable tiene una naturaleza transaccional y concurrente. Esto implica que el monitoreo no puede limitarse a una sola capa, sino que debe cubrir al menos los siguientes dominios:

1. Estado del pipeline por lote.
2. Disponibilidad y estabilidad del servicio externo consultado.
3. Comportamiento de la base de datos durante lecturas y escrituras.
4. Trazabilidad individual por CURP procesada.
5. Persistencia de errores y capacidad de reproceso.

El esquema de abril se construyó con esta visión de extremo a extremo, de modo que cada incidencia relevante pueda vincularse con un lote, una CURP, un mensaje técnico y una acción de atención.

## 4. Componentes Cubiertos
- Bases de datos.
- APIs y servicios de exposición.
- Pipelines y procesos por lote.
- Descargas de archivos PDF.
- Reprocesos y manejo de fallos.

## 4. Superficies de Observabilidad Identificadas

### 4.1 Logs de aplicación
El módulo `logging_utils.py` configura un formateador con fecha, nivel, origen y mensaje. Además:
- envía salida informativa a consola;
- registra errores en archivo (`errors.log` por defecto);
- captura excepciones no controladas mediante `sys.excepthook`.

Esta base permite separar eventos operativos normales de errores críticos y constituye un primer nivel de alertamiento técnico.

### 4.2 Trazabilidad por lote
La tabla `Lote` y la lógica del orquestador permiten monitorear:
- inicio de ejecución por entidad;
- nombre del lote y criterio de agrupación;
- bandera `en_ejecucion` para detectar procesos activos o no cerrados;
- cierre correcto del lote al finalizar el procesamiento.

Esto convierte al lote en la unidad principal de seguimiento operativo.

### 4.3 Trazabilidad por CURP
La tabla `CurpProcesada` y la inserción de eventos en `BitacoraEvento` permiten rastrear:
- CURP procesada;
- lote que la ejecutó;
- ruta del PDF generado;
- estado de descarga (`EXITO` o `FALLO`);
- mensaje devuelto por el servicio o por la excepción capturada.

Esta superficie permite construir monitoreo detallado a nivel de registro individual, especialmente útil para análisis de fallos, reprocesos y calidad del flujo.

### 4.4 Reintentos y errores de red
El método `_process_single` incluye hasta tres intentos por CURP cuando ocurre una excepción de conexión. Durante esos intentos:
- se registran advertencias mientras aún hay posibilidad de recuperación;
- se registra error cuando se agotan los intentos;
- se conserva un mensaje final que puede insertarse en bitácora.

Este comportamiento es un insumo directo para definir métricas de estabilidad y alertas tempranas.

### 4.5 Salidas de archivos
El proceso genera PDFs bajo una estructura de carpetas por estado, CCT y ciclo escolar. Esta salida representa una evidencia operativa medible y también un punto de control para validar éxito del pipeline y completitud de ejecución.

## 5. Métricas Definidas

| Categoría | Métrica | Propósito |
|-----------|---------|-----------|
| Pipeline | Tiempo total por lote | Detectar degradación de procesamiento |
| Pipeline | Porcentaje de CURP fallidas | Medir estabilidad operativa |
| Base de datos | Tiempo de respuesta de consultas críticas | Evaluar impacto de optimizaciones |
| Descargas | Tasa de éxito de PDFs | Verificar estabilidad del proceso de descarga |
| Reprocesos | Número de reintentos por corrida | Identificar errores recurrentes |
| Logs | Volumen de errores críticos | Priorizar atención y diagnóstico |

## 5. Métricas Operativas Consolidadas para Abril

### 5.1 Métricas de pipeline

| Métrica | Definición | Fuente principal |
|---------|------------|------------------|
| Tiempo total por lote | Tiempo desde registro del lote hasta su cierre | Logs + control de lote |
| CURP procesadas por lote | Número de registros intentados en la corrida | `CurpProcesada` |
| CURP exitosas | Registros con `estado_descarga = EXITO` | `CurpProcesada` |
| CURP fallidas | Registros con `estado_descarga = FALLO` | `CurpProcesada` |

### 5.2 Métricas de errores y reproceso

| Métrica | Definición | Fuente principal |
|---------|------------|------------------|
| Reintentos por CURP | Número de veces que una CURP requiere reconsulta en una ejecución | Logs de aplicación |
| Fallos por lote | Total de eventos fallidos en una corrida | `BitacoraEvento` + logs |
| Lotes reanudados | Número de lotes retomados con `run_resume.py` | `Lote` + ejecución de scripts |
| Lotes de reproceso | Corridas específicas iniciadas con `run_reproceso.py` | `Lote` |

### 5.3 Métricas de base de datos

| Métrica | Definición | Fuente principal |
|---------|------------|------------------|
| Tiempo de consulta fuente | Tiempo de extracción desde `menor_evaluado` y `catalogo_cct` | Medición operativa futura |
| Tiempo de inserción/actualización | Tiempo asociado a escritura de `CurpProcesada` y `BitacoraEvento` | Medición operativa futura |
| Lotes en ejecución abiertos | Número de lotes con bandera `en_ejecucion=1` | Tabla `Lote` |

### 5.4 Métricas de salida

| Métrica | Definición | Fuente principal |
|---------|------------|------------------|
| PDFs generados | Total de archivos escritos por corrida | Estructura de salida |
| Tasa de éxito de PDFs | Relación entre intentos y descargas exitosas | `CurpProcesada` + salida física |
| Rutas generadas por CCT | Cantidad de carpetas o agrupaciones creadas | `OUTPUT_DIR` |

## 6. Umbrales Iniciales

| Métrica | Umbral inicial | Acción esperada |
|---------|----------------|-----------------|
| CURP fallidas por corrida | Mayor a 5% | Revisar causa raíz y activar análisis |
| Tasa de éxito de PDFs | Menor a 95% | Verificar conectividad, fuente o validación |
| Reintentos por lote | Tendencia creciente | Revisar integridad de datos y estabilidad |
| Consultas críticas | Fuera de línea base | Analizar índices y planes de ejecución |

## 6. Umbrales Operativos Propuestos
Además de los umbrales base, abril dejó delimitados los siguientes criterios de observación:

| Evento | Condición de atención | Nivel sugerido |
|--------|-----------------------|----------------|
| Lote en ejecución no cerrado | `en_ejecucion=1` por encima del tiempo esperado | Preventivo/Critico |
| Error repetido de conexión | Múltiples advertencias sobre una misma CURP o lote | Preventivo |
| Fallo definitivo tras tres intentos | Se agotan reintentos y el estado final es `FALLO` | Crítico |
| Volumen anormal de eventos | Crecimiento súbito de `BitacoraEvento` | Preventivo |
| Ausencia de salida esperada | No se genera PDF en ruta esperada tras respuesta exitosa | Crítico |

## 7. Alertas y Procedimientos de Atención
- Clasificar eventos en informativos, preventivos y críticos.
- Escalar fallos recurrentes por lote a revisión técnica.
- Registrar toda incidencia relevante en bitácora operativa.
- Documentar causa, acción correctiva y estado final del incidente.

## 7. Esquema de Alertamiento Propuesto

### 7.1 Niveles de alerta
- Informativa: eventos normales del flujo, inicio y cierre de lotes, procesamiento sin anomalías relevantes.
- Preventiva: desviaciones que no detienen el proceso, pero sugieren degradación o tendencia anormal.
- Crítica: fallos que comprometen la continuidad del lote, la generación de evidencia o la integridad del resultado.

### 7.2 Canales y mecanismos sugeridos
Durante abril no se implementó todavía un tablero o canal automatizado formal, pero quedó definida la estructura mínima deseable:
- logs a consola para seguimiento operativo inmediato;
- archivo `errors.log` para revisión técnica de excepciones;
- consulta periódica de `BitacoraEvento` y `CurpProcesada` para diagnóstico por lote;
- generación posterior de métricas agregadas para tablero o reporte ejecutivo.

### 7.3 Procedimiento de atención propuesto
1. Detectar la anomalía por logs, bitácora o métricas del lote.
2. Clasificar el evento por severidad.
3. Confirmar si el problema es de datos, red, servicio externo, base de datos o concurrencia.
4. Determinar si procede reproceso (`run_reproceso.py`) o reanudación (`run_resume.py`).
5. Registrar la acción correctiva y el resultado final.

## 8. Evidencia Disponible en Abril
- Identificación de métricas clave por componente.
- Propuesta de umbrales iniciales para seguimiento.
- Delimitación del procedimiento base de atención.
- Relación inicial entre logs, trazas y métricas operativas.

## 9. Evidencia Técnica Específica del Avance
- Identificación del patrón de logging estructurado con fecha, nivel y origen.
- Revisión de la inserción de mensajes en `BitacoraEvento` por cada CURP procesada.
- Confirmación del uso de reintentos automáticos hasta tres veces en escenarios de falla.
- Identificación de la bandera `en_ejecucion` como punto de control operativo para lotes activos.
- Delimitación de `OUTPUT_DIR` como superficie de verificación de resultados exitosos.

## 10. Pruebas
Durante abril no se consolidó todavía evidencia formal de pruebas de alertamiento en ejecución real, debido a que el mes se utilizó para estructurar el esquema base. Las pruebas controladas deberán integrarse como parte del avance de mayo.

## 11. Estrategia de Pruebas para Mayo
Quedó definida una estrategia mínima para validar el esquema de monitoreo y alertamiento durante la siguiente etapa:
- ejecutar un lote controlado y medir inicio, cierre y volumen de registros;
- provocar o identificar un conjunto de fallos de red para validar advertencias y errores;
- revisar generación de eventos en `BitacoraEvento`;
- contrastar registros de `CurpProcesada` con PDFs realmente generados;
- documentar si un reproceso o reanudación resuelve correctamente el incidente original.

## 12. Riesgos y Dependencias
- Dependencia del servicio externo IMSS para observar comportamientos reales de error o éxito.
- Dependencia de datos suficientes para calibrar umbrales con valor operativo.
- Riesgo de crecimiento acelerado de eventos sin estrategia de explotación o retención.
- Riesgo de no distinguir entre error transitorio de red y error estructural de datos si la bitácora no se explota adecuadamente.

## 13. Próximos Pasos
- Implementar medición operativa real de métricas seleccionadas.
- Validar umbrales con datos de ejecución.
- Documentar evidencia de pruebas y atención de alertas.
- Consolidar el reporte de mayo con resultados observables y ajustes de umbrales.

Como continuación de lo anterior, abril dejó además estas acciones específicas para la siguiente etapa:
- Instrumentar consultas de explotación sobre `Lote`, `CurpProcesada` y `BitacoraEvento`.
- Vincular las métricas de monitoreo con el análisis de rendimiento de bases de datos.
- Consolidar evidencia de pruebas y de respuesta ante incidentes.
- Ajustar niveles de alerta y umbrales con base en comportamiento real.

---

**Comentarios adicionales:**

Este entregable corresponde al avance mensual de abril de 2026 y establece un esquema de monitoreo y alertamiento sustentado en los componentes reales del proyecto Vida Saludable: logs de aplicación, control de lotes, eventos por CURP, reintentos, salidas de archivos y trazabilidad de errores. Durante mayo deberá complementarse con pruebas controladas, calibración de umbrales y evidencia operativa de atención de incidentes.