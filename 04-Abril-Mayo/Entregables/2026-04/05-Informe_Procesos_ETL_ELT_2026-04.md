# Informe Mensual de Procesos de Ingesta y Transformación (ETL/ELT)

**Mes:** Abril 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Presentar el avance mensual de abril de 2026 sobre el desarrollo y utilización de procesos de ingesta y transformación (ETL/ELT), incluyendo especificaciones para formatos CSV, XLSX, JSON y XML, así como validaciones y depuración.

## 2. Alcance del Avance de Abril
Durante abril se definió la estructura base de los procesos de ingesta y transformación necesarios para operar con múltiples formatos de archivo dentro del nuevo contrato, estableciendo reglas iniciales de validación, depuración y mapeo hacia estructuras de destino.

La revisión técnica realizada este mes permitió precisar que, dentro del proyecto Vida Saludable, el proceso actualmente identificado con mayor claridad no corresponde todavía a una plataforma ETL/ELT multiformato plenamente implementada, sino a un pipeline operativo con los siguientes componentes:
- extracción de registros desde PostgreSQL;
- transformación y enriquecimiento en memoria antes de la consulta externa;
- carga de resultados operativos en tablas de control;
- almacenamiento de evidencias documentales en archivos PDF;
- registro histórico de eventos y reprocesos.

Por lo tanto, el avance de abril consistió en documentar el flujo ETL/ELT efectivamente observable en el código y dejar como especificación contractual las reglas que deberán extenderse posteriormente a formatos CSV, XLSX, JSON y XML cuando esos insumos entren formalmente en operación.

## 3. Flujo ETL/ELT Real Identificado en Abril
El análisis del repositorio `py-sep-descarga-vida-saludable` permitió identificar un flujo operativo con comportamiento equivalente a un proceso ETL/ELT, aunque orientado a procesamiento institucional y descarga de reportes.

### 3.1 Extracción
La fase de extracción se localiza principalmente en `db.py`, donde se consulta PostgreSQL para recuperar registros de `menor_evaluado` y enriquecerlos con `catalogo_cct`. Esta extracción filtra por entidad y, cuando aplica, por ciclo escolar.

Los campos recuperados incluyen:
- `cve_escuela` como CCT;
- `id_turno`;
- `cve_curp`;
- correo y teléfono de referencia;
- `estatus_reporte`;
- `id_ciclo_escolar`;
- nombre de escuela, estado, municipio, localidad y turno desde el catálogo institucional.

### 3.2 Transformación
La transformación ocurre antes y durante el procesamiento individual de cada CURP. En esta etapa se realizan acciones como:
- normalización de parámetros de entrada;
- adición del identificador de ciclo escolar al nombre del lote;
- normalización de segmentos para rutas de salida;
- empaquetado de parámetros requeridos por el servicio IMSS;
- derivación del estado final de descarga y del mensaje operativo asociado.

### 3.3 Carga
La carga identificada no se limita a una tabla final. Abril permitió documentar tres destinos de carga:

1. Carga transaccional en la tabla `Lote`, donde se registra la ejecución del proceso.
2. Carga operacional en `CurpProcesada`, donde se persiste el resultado por CURP.
3. Carga de trazabilidad en `BitacoraEvento`, donde se almacenan mensajes, fecha y tipo de evento.

Adicionalmente, el flujo incluye carga a sistema de archivos mediante la escritura de PDF en una estructura jerárquica por estado, CCT y ciclo escolar.

### 3.4 Reproceso y reanudación
También se identificaron rutas operativas equivalentes a subprocesos ETL complementarios:
- `run_reproceso.py`, que vuelve a procesar registros con `estado_descarga = 'FALLO'`;
- `run_resume.py`, que recupera registros pendientes para un lote aún en ejecución.

Estas variantes son relevantes porque introducen reglas de depuración, continuidad operativa y control de cargas incompletas.

## 4. Origen, Transformación y Destino de Datos

| Etapa | Implementación observada en abril | Evidencia técnica |
|-------|-----------------------------------|-------------------|
| Extracción | Consulta a PostgreSQL sobre `menor_evaluado` y `catalogo_cct` | `fetch_alumnos`, `fetch_alumnos_fallidos`, `fetch_alumnos_pendientes` |
| Transformación | Normalización de parámetros, enriquecimiento por entidad/CCT, preparación de lotes y rutas | `register_batch`, `_normalize_segment`, `_build_output_dir` |
| Integración externa | Consulta cifrada al servicio IMSS | `_call_ws_imss` |
| Carga operativa | Inserción y actualización de `Lote`, `CurpProcesada` y `BitacoraEvento` | `register_batch`, `_process_single` |
| Carga documental | Escritura de PDF en estructura de carpetas | `_process_single` |
| Reproceso | Reejecución de fallos | `run_reproceso.py` |
| Reanudación | Recuperación de pendientes de un lote en ejecución | `run_resume.py` |

## 5. Formatos de Archivo Considerados

| Formato | Uso esperado | Estado en abril |
|---------|--------------|-----------------|
| CSV | Procesamiento masivo por lotes o exportación intermedia | Especificación base definida, sin flujo productivo documentado en abril |
| XLSX | Insumos administrativos o consolidados | Estructura objetivo identificada, pendiente de implementación |
| JSON | Intercambio estructurado con servicios o procesos intermedios | Uso parcial observado en respuestas del servicio IMSS |
| XML | Integración con formatos institucionales | Considerado como requerimiento contractual, sin evidencia operativa en abril |

En términos estrictos, abril solo permitió observar consumo directo de base de datos, respuestas del servicio en PDF o JSON y escritura de archivos PDF. Los demás formatos permanecen como parte de la especificación a implementar o formalizar en meses posteriores.

## 6. Validaciones Definidas
- Revisión de encabezados y columnas obligatorias.
- Verificación de tipos de dato y codificación.
- Detección de registros vacíos, incompletos o fuera de estructura.
- Control de consistencia entre identificadores y campos clave.

Además de las validaciones generales anteriores, el análisis de abril permitió definir validaciones concretas alineadas al flujo real:

### 6.1 Validaciones de extracción
- Confirmar correspondencia entre `cve_escuela` y `catalogo_cct.cct`.
- Verificar que `cve_curp`, `cve_escuela` e `id_ciclo_escolar` existan para cada registro.
- Validar el filtro por entidad y ciclo escolar antes de iniciar el procesamiento por lote.

### 6.2 Validaciones de transformación
- Verificar normalización de directorios para evitar rutas inválidas.
- Confirmar que los parámetros a cifrar para el servicio IMSS no queden vacíos cuando son requeridos.
- Controlar consistencia entre entidad consultada y estado operativo del registro.

### 6.3 Validaciones de carga
- Confirmar unicidad operativa del lote en ejecución.
- Verificar que `CurpProcesada` persista el resultado final esperado.
- Confirmar registro de evento asociado a cada intento significativo.
- Verificar integridad entre `estado_descarga`, `ruta_pdf` y existencia real del archivo generado cuando hubo éxito.

## 7. Depuración de Datos y Manejo de Incidencias
- Identificación de duplicados.
- Corrección o separación de registros inconsistentes.
- Trazabilidad de errores detectados y acciones correctivas.
- Preparación de bitácora técnica para reproceso de entradas defectuosas.

Durante abril se identificó que la depuración en este proyecto no es solamente limpieza previa de archivos, sino depuración operativa basada en resultado de proceso. Esto implica:
- distinguir entre registros fallidos, pendientes y exitosos;
- separar errores de conectividad, errores funcionales del servicio y registros sin documento válido;
- utilizar el reproceso como mecanismo de recuperación controlada;
- utilizar la bitácora de eventos como fuente de diagnóstico.

En consecuencia, el componente de depuración ETL/ELT quedó definido con dos dimensiones:

1. Depuración estructural de datos de entrada.
2. Depuración operativa posterior al procesamiento y carga.

## 8. Especificaciones Técnicas del Avance

| Etapa | Especificación definida en abril |
|-------|----------------------------------|
| Recepción | Identificación de origen desde PostgreSQL y parametrización por entidad/ciclo |
| Validación | Reglas mínimas sobre claves, filtros, unicidad y consistencia con catálogos |
| Transformación | Mapeo de columnas, enriquecimiento con catálogo CCT, normalización de parámetros y rutas |
| Integración externa | Cifrado de parámetros y consumo del servicio IMSS |
| Carga | Persistencia en `Lote`, `CurpProcesada`, `BitacoraEvento` y sistema de archivos |
| Error handling | Reintentos, registro de mensajes, reproceso y reanudación |

## 9. Mapeo Funcional del Proceso

| Origen | Transformación principal | Destino |
|--------|--------------------------|---------|
| `menor_evaluado` | Selección de CURP, contacto, escuela y ciclo escolar | Dataset de trabajo en memoria |
| `catalogo_cct` | Enriquecimiento territorial e institucional | Registro operativo enriquecido |
| Parámetros del registro | Construcción de request cifrado al servicio IMSS | Consulta externa |
| Respuesta IMSS | Interpretación de PDF, JSON o error textual | `CurpProcesada` y PDF en disco |
| Resultado del intento | Generación de mensaje y estado final | `BitacoraEvento` |
| Fallos o pendientes | Selección para reproceso o reanudación | Nueva ejecución controlada |

## 10. Especificación Contractual por Formato
Aunque el flujo realmente observado en abril se apoya en PostgreSQL, JSON y PDF, el entregable debía dejar establecidos lineamientos para formatos CSV, XLSX, JSON y XML. La especificación base quedó delimitada así:

### 10.1 CSV
- uso para cargas masivas con encabezados controlados;
- validación de delimitador, codificación, columnas obligatorias y duplicados;
- mapeo hacia estructuras equivalentes a `menor_evaluado` o catálogos auxiliares.

### 10.2 XLSX
- uso para insumos administrativos o concentrados institucionales;
- validación de hoja objetivo, nombres de columnas y tipos de dato;
- control de filas vacías, formatos mixtos y celdas combinadas no permitidas.

### 10.3 JSON
- uso para intercambio entre procesos o respuestas de servicios;
- validación de estructura, claves requeridas y codificación UTF-8;
- trazabilidad del documento recibido y reglas de transformación hacia tablas operativas.

### 10.4 XML
- uso previsto para interoperabilidad con sistemas institucionales que publiquen estructuras jerárquicas;
- validación contra estructura esperada, nodos obligatorios y consistencia semántica;
- transformación previa a modelo tabular o staging antes de su carga.

## 11. Evidencia del Avance de Abril
- Matriz de formatos y validaciones iniciales.
- Relación preliminar entre insumos de origen y transformaciones esperadas.
- Definición de bitácora técnica de errores y depuración.
- Delimitación de procesos ETL/ELT que deben probarse en mayo.

## 12. Evidencia Técnica Específica
- Identificación en `db.py` de las rutinas reales de extracción por entidad, fallidos y pendientes.
- Identificación en `orchestrator.py` del alta de lotes, el procesamiento concurrente y la persistencia de resultados.
- Identificación de la carga dual a base de datos y archivos PDF.
- Revisión de la lógica de reproceso y reanudación como parte del ciclo de vida del pipeline.
- Confirmación de que los formatos CSV, XLSX y XML permanecen como marco de especificación y no como flujo productivo ya implementado en abril.

## 13. Riesgos y Consideraciones
- Riesgo de documentar como ETL multiformato algo que en abril aún opera principalmente como pipeline basado en base de datos y servicio externo.
- Riesgo de inconsistencia entre estado registrado en base de datos y existencia física del PDF si no se aplican verificaciones de integridad.
- Riesgo de crecimiento de incidencias si no se formalizan tablas o zonas de staging para futuras cargas desde archivos.
- Riesgo de mezclar reglas de negocio operativas con transformaciones analíticas sin una capa de datos intermedia.

## 14. Próximos Pasos
- Implementar o documentar zonas de staging para cargas desde CSV, XLSX, JSON y XML cuando entren en uso.
- Consolidar mapeos explícitos entre origen, transformación y destino para cada tipo de insumo.
- Formalizar bitácoras de validación y catálogos de errores reutilizables.
- Preparar el avance de mayo con ejecución documentada de pruebas ETL/ELT sobre insumos controlados.

---

**Comentarios adicionales:**

Este entregable corresponde al avance mensual de abril de 2026 y deja mejor delimitado el proceso ETL/ELT realmente identificado en el proyecto: extracción desde PostgreSQL, transformación operativa, carga en tablas de control y archivos PDF, con soporte de reproceso y reanudación. Asimismo, establece como especificación contractual la futura incorporación controlada de insumos CSV, XLSX, JSON y XML para etapas posteriores.