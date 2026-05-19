# Informe Mensual de Optimización de Rendimiento de Bases de Datos

**Mes:** Abril 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Presentar el avance mensual de abril de 2026 sobre análisis de rendimiento de bases de datos, incluyendo hallazgos, cambios a evaluar, impacto medido cuando aplique y recomendaciones de capacity planning, conforme al nuevo contrato de trabajo.

## 2. Alcance del Avance de Abril
Durante abril se estableció la línea base de análisis de rendimiento asociada al proyecto Vida Saludable, enfocándose en consultas, índices, planes de ejecución y parametrización potencialmente relevantes para el procesamiento por lotes, el seguimiento de ejecuciones, el manejo de reprocesos y la consulta de evidencias operativas.

El objetivo del mes no fue todavía ejecutar cambios estructurales en producción, sino delimitar con precisión:
- las tablas y consultas más sensibles al volumen y a la concurrencia;
- los índices ya existentes en el modelo;
- los puntos donde debe levantarse evidencia antes/después;
- las decisiones de parametrización que pueden afectar tiempos de respuesta y estabilidad operativa.

El análisis se apoyó en la definición DDL del repositorio `py-sep-descarga-vida-saludable`, así como en la revisión de los módulos `db.py`, `orchestrator.py`, `run_pipeline.py`, `run_reproceso.py` y `run_resume.py`.

## 3. Contexto Técnico de la Línea de Rendimiento
El proceso Vida Saludable utiliza PostgreSQL como motor principal de persistencia y se apoya en una combinación de tablas operativas, catálogos, históricos e indicadores. Desde la perspectiva de rendimiento, el comportamiento de la solución depende de tres capas de acceso a datos:

1. Recuperación de registros fuente desde `menor_evaluado` y `catalogo_cct`.
2. Registro y actualización de control operativo en `Lote`, `CurpProcesada` y `BitacoraEvento`.
3. Explotación de tablas e indicadores históricos para diagnóstico, seguimiento y evidencias.

El análisis de abril se centró en estas capas para preparar la medición comparativa de mayo.

## 4. Componentes Analizados

| Componente | Foco de análisis | Estado en abril |
|------------|------------------|-----------------|
| Registro de lotes | Inserciones y consultas de seguimiento | Revisado |
| Estado de procesamiento | Filtros por resultado y reintento | Revisado |
| Logs operativos | Consultas para diagnóstico | Revisado |
| Persistencia de resultados | Volumen y trazabilidad | Revisado |

## 4. Estructuras de Base de Datos Relevantes para Rendimiento

### 4.1 Tablas operativas clave

| Tabla | Función operativa | Implicación de rendimiento |
|-------|-------------------|----------------------------|
| `Lote` | Controla cada corrida por entidad, fecha y criterio | Impacta búsquedas de lotes en ejecución y cierres |
| `CurpProcesada` | Registra resultado por CURP, lote, CCT y ruta de PDF | Tabla crítica para seguimiento y reproceso |
| `BitacoraEvento` | Registra mensajes por CURP procesada | Puede crecer rápidamente y afectar diagnósticos |
| `menor_evaluado` | Fuente principal de registros a procesar | Impacta extracción por entidad, CURP y ciclo escolar |
| `catalogo_cct` | Catálogo de apoyo para enriquecer consulta fuente | Afecta `JOIN` recurrente en extracción |

### 4.2 Índices identificados en abril
El modelo revisado ya cuenta con índices relevantes que deben considerarse como línea base para cualquier optimización posterior:

| Tabla | Índice existente | Uso esperado |
|-------|------------------|--------------|
| `menor_evaluado` | `idx_menev_curp_escuela` | Búsqueda combinada por CURP y escuela |
| `menor_evaluado` | `idx_menev_cve_curp` | Consulta por CURP |
| `menor_evaluado` | `idx_menev_cve_escuela` | Consulta por escuela/CCT |
| `CurpProcesada` | `UQ_CurpProcesada_curp` | Garantiza unicidad y apoya actualización por CURP |
| `HistoricoDescargaReporte` | `iPersona_HistoricoDescargaReporte` | Consulta por persona histórica |
| `HistoricoSesiones` | `iPersona_HistoricoSesiones` | Consulta por persona y sesión |

### 4.3 Estructuras de soporte analítico
Además de las tablas operativas, el DDL incluye estructuras orientadas a indicadores, como `v_descargas_por_dia`, `v_descargas_por_estado`, `v_indicadores`, `v_total_registradas_por_dia` y `v_total_personas_sesion_x_dia`. Aunque en abril no se ejecutó explotación intensiva de estas estructuras, quedaron identificadas como superficie importante para futuros reportes de capacidad y desempeño.

## 5. Consultas y Patrones de Acceso Identificados
El análisis del código permitió ubicar los patrones de acceso más relevantes para el rendimiento.

### 5.1 Consulta base de extracción
En `db.py` se identificó una consulta que obtiene los alumnos por entidad, uniendo `menor_evaluado` con `catalogo_cct` y aplicando filtros por estado y, cuando existe, por ciclo escolar. Esta consulta es candidata natural para revisión de plan de ejecución porque combina:
- `JOIN` entre tabla fuente y catálogo;
- filtros de selección por estado;
- filtros condicionales por ciclo escolar.

### 5.2 Consulta de fallidos para reproceso
También se identificó una consulta que une `menor_evaluado`, `catalogo_cct` y `CurpProcesada` para recuperar únicamente registros con `estado_descarga = 'FALLO'`. Esta operación es crítica porque será recurrente en escenarios de recuperación y depende de un acceso eficiente a `CurpProcesada`.

### 5.3 Consulta de pendientes para reanudación
El flujo de reanudación utiliza un `LEFT JOIN` entre `menor_evaluado` y `CurpProcesada` condicionado por `id_lote`, con la finalidad de recuperar únicamente las CURP aún no procesadas en un lote activo. Esta operación es sensible al crecimiento de la tabla de control operativo.

### 5.4 Consultas de control de lotes
Se identificaron además consultas de control sobre la tabla `Lote`, por ejemplo:
- validación de existencia de un lote con el mismo nombre y bandera `en_ejecucion=1`;
- búsqueda del lote más reciente por entidad con `en_ejecucion=1` para reanudación;
- actualización de cierre del lote al finalizar el procesamiento.

Estas operaciones, aunque ligeras en volumen al inicio, pueden degradarse si la tabla crece y no se cuenta con índices adecuados para criterios de ejecución y fecha.

## 6. Hallazgos Iniciales
- El rendimiento deberá evaluarse prioritariamente sobre operaciones de registro de lotes, seguimiento de estados y consultas por reproceso.
- La estrategia de índices debe revisarse con base en filtros por estado, fecha de ejecución, lote y CURP.
- El crecimiento de registros operativos y trazas puede impactar consultas diagnósticas si no se define una política de acceso y retención.
- Es necesario consolidar evidencia antes/después a partir de casos medibles durante mayo.

Adicionalmente, abril permitió identificar los siguientes hallazgos técnicos:
- La extracción de datos depende de `JOIN` repetidos sobre `menor_evaluado` y `catalogo_cct`, por lo que cualquier crecimiento de volumen deberá medirse con planes de ejecución reales.
- La lógica `ON CONFLICT (curp) DO UPDATE` utilizada al registrar `CurpProcesada` sugiere que el acceso por CURP es central para estabilidad y rendimiento.
- La tabla `BitacoraEvento` puede convertirse rápidamente en un punto de crecimiento importante, ya que registra al menos un evento por CURP procesada.
- La concurrencia configurada mediante `WORKERS` puede incrementar la presión sobre las operaciones de inserción y actualización en la base de datos, por lo que no basta revisar consultas aisladas; también debe observarse el comportamiento bajo carga.

## 7. Cambios Potenciales a Evaluar

| Tipo de cambio | Objetivo | Estado en abril |
|----------------|----------|-----------------|
| Revisión de índices | Reducir tiempos de consulta | Identificado |
| Ajuste de consultas | Mejorar filtros y acceso a estados | Identificado |
| Parametrización | Reducir sobrecarga en operaciones repetitivas | En análisis |
| Capacity planning | Anticipar crecimiento por lotes y trazas | En definición |

## 8. Cambios Técnicos Propuestos para la Siguiente Etapa

### 8.1 Índices por validar
Con base en el comportamiento observado, abril dejó identificados los siguientes candidatos de análisis para mayo:
- índice sobre `Lote(nombre_lote, en_ejecucion)` para acelerar validación de duplicidad de lotes en ejecución;
- índice sobre `Lote(entidad_federativa, en_ejecucion, fecha_ejecucion)` para acelerar reanudación de lotes por entidad;
- índice compuesto sobre `CurpProcesada(id_lote, curp)` o criterios equivalentes para apoyar recuperación de pendientes y seguimiento por lote;
- revisión de indexación adicional sobre `estado_descarga` si la explotación de fallidos incrementa su frecuencia.

### 8.2 Ajustes de consultas
Las consultas de extracción y reproceso deben someterse a revisión de plan de ejecución para validar:
- uso efectivo de índices existentes;
- costo del `JOIN` con `catalogo_cct`;
- impacto del filtro por ciclo escolar;
- comportamiento del `LEFT JOIN` de pendientes cuando `CurpProcesada` crezca.

### 8.3 Parametrización operativa
Se identificó como parámetro sensible `WORKERS`, ya que controla el número de hilos concurrentes. En abril no se realizaron pruebas formales de variación, pero quedó establecido que cualquier ajuste deberá medirse en relación con:
- tiempo total por lote;
- número de errores de conexión;
- presión sobre la base de datos;
- estabilidad de las operaciones de escritura.

## 9. Evidencia Disponible en Abril
- Revisión de estructura DDL de la base de datos principal.
- Identificación de componentes con potencial impacto por volumen y concurrencia.
- Delimitación de las consultas y tablas que deben medirse en la siguiente etapa.

La evidencia específica levantada en abril incluye:
- existencia de índices explícitos sobre `menor_evaluado` y estructuras históricas;
- identificación de la unicidad por CURP en `CurpProcesada`;
- revisión de operaciones `SELECT`, `JOIN`, `LEFT JOIN`, `ORDER BY`, `UPDATE` y `ON CONFLICT` que deben evaluarse con mayor detalle;
- delimitación del papel de tablas operativas e históricas en el consumo de base de datos.

## 10. Impacto Medido
En abril no se consolidaron todavía mediciones comparativas antes/después, debido a que el mes se orientó a la construcción de la línea base y a la identificación de puntos críticos de análisis. La medición cuantitativa se programó como siguiente paso para mayo.

No obstante, abril sí dejó definido el marco de medición que deberá utilizarse en la siguiente etapa:
- tiempo de ejecución de consultas críticas;
- tiempo de inserción y actualización por lote;
- número de registros procesados por unidad de tiempo;
- crecimiento de tablas operativas e históricas;
- costo relativo de planes de ejecución antes y después de cambios.

## 11. Recomendaciones de Capacity Planning
- Estimar crecimiento de registros por lote, reintentos y resultados operativos.
- Separar métricas de operación y métricas de auditoría para facilitar explotación.
- Preparar monitoreo de consultas críticas y tiempos de respuesta desde mayo.
- Documentar evidencia comparativa para sustentar ajustes de índices y consultas.

Se agregan además las siguientes recomendaciones específicas:
- proyectar el crecimiento combinado de `CurpProcesada` y `BitacoraEvento` bajo escenarios de operación continua y reprocesos;
- estimar el costo de almacenamiento asociado a PDFs, rutas y tablas históricas;
- diferenciar necesidades de rendimiento para operación en línea versus explotación analítica;
- revisar políticas de retención, archivo o compactación de bitácoras si el volumen crece por encima del uso operativo esperado.

## 12. Riesgos y Dependencias
- El rendimiento observado en abril es todavía teórico y depende de ejecutar cargas reales o controladas.
- El comportamiento de la base puede variar significativamente según la cantidad de hilos definida en `WORKERS`.
- Las consultas históricas pueden degradarse si se mezclan en la misma superficie operativa sin una estrategia de explotación diferenciada.
- La ausencia de medición temprana puede retrasar la justificación técnica de optimizaciones ante el corte trimestral.

## 13. Próximos Pasos
- Ejecutar pruebas de rendimiento sobre consultas y operaciones críticas.
- Documentar tiempos antes y después de ajustes.
- Proponer cambios específicos de índices o consultas con evidencia medible.
- Levantar planes de ejecución de consultas base, fallidos y pendientes.
- Medir impacto de concurrencia sobre operaciones de lectura y escritura.
- Consolidar el informe de mayo con impacto cuantificado y recomendaciones operativas.

---

**Comentarios adicionales:**

Este entregable corresponde al avance mensual de abril de 2026 y establece una línea base técnica más precisa sobre consultas, índices y patrones de acceso a datos del proyecto Vida Saludable. La etapa de mayo deberá traducir esta línea base en evidencia comparativa antes/después, con mediciones, planes de ejecución y recomendaciones de optimización sustentadas en resultados observables.