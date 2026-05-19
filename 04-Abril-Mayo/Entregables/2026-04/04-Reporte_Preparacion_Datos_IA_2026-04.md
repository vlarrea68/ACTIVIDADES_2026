# Reporte Mensual de Preparación de Datos para Inteligencia Artificial

**Mes:** Abril 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Presentar el avance mensual de abril de 2026 sobre curación de datasets, definición de feature sets o embeddings cuando aplique, criterios de calidad y recomendaciones de uso para consumo con inteligencia artificial.

## 2. Alcance del Avance de Abril
Durante abril se realizó la identificación inicial de datos, atributos y criterios de calidad que pueden reutilizarse para fines analíticos o de inteligencia artificial dentro del contexto del proyecto Vida Saludable y sus procesos asociados.

El objetivo del mes fue determinar si la información operativa del proyecto puede evolucionar hacia datasets reutilizables para análisis avanzado, priorización de atención, clasificación de incidencias y apoyo a la toma de decisiones. Para ello se revisaron las entidades disponibles en el repositorio `py-sep-descarga-vida-saludable`, las tablas del esquema PostgreSQL y la lógica de extracción, procesamiento y registro de resultados.

En abril no se construyeron todavía datasets finales de entrenamiento o inferencia, pero sí se definieron:
- la superficie de datos útil para reutilización analítica;
- los atributos candidatos a convertirse en features;
- los criterios mínimos de calidad y trazabilidad;
- las restricciones de gobernanza para datos potencialmente sensibles.

## 3. Contexto de Datos del Proyecto Vida Saludable
El proyecto genera y consume información a lo largo de varias etapas operativas: preparación de insumos, consulta de registros por entidad, procesamiento por CURP, descarga de PDF, registro de resultados, bitácora de eventos y seguimiento histórico. Desde la perspectiva de datos para IA, esto permite distinguir tres grandes grupos de información:

1. Datos fuente de personas y centros de trabajo.
2. Datos transaccionales del procesamiento por lote.
3. Datos derivados de errores, trazas, resultados e históricos.

La preparación de datos para IA durante abril se enfocó en convertir esta estructura operativa en una propuesta de datasets con propósito claro, trazabilidad y controles de calidad.

## 4. Datasets Candidatos Identificados

| Dataset candidato | Descripción | Uso potencial |
|-------------------|-------------|---------------|
| Lotes procesados | Información de ejecución por lote | Seguimiento operativo y analítica histórica |
| Registros por CURP | Resultado individual por procesamiento | Análisis de incidencias y calidad |
| Logs y trazas | Eventos, errores y reintentos | Diagnóstico, clasificación y priorización |
| Descargas de PDF | Resultados y rutas de salida | Monitoreo operativo y trazabilidad |

## 5. Entidades y Atributos Relevantes Identificados

### 4.1 Entidades fuente
El análisis de abril identificó como entidades de mayor valor analítico las siguientes:

| Entidad | Fuente | Atributos relevantes |
|---------|--------|----------------------|
| Menor evaluado | `menor_evaluado` | `cve_curp`, `cve_escuela`, `id_turno`, `ref_telefono`, `ref_correo_responsable`, `id_ciclo_escolar`, `estatus_reporte` |
| Centro de trabajo | `catalogo_cct` | `cct`, `nombre`, `turno`, `estado`, `municipio`, `localidad` |
| Lote | `Lote` | `id_lote`, `nombre_lote`, `fecha_ejecucion`, `entidad_federativa`, `criterio_agrupado` |
| CURP procesada | `CurpProcesada` | `curp`, `id_lote`, `cct`, `ruta_pdf`, `estado_descarga` |
| Evento | `BitacoraEvento` | `fecha_evento`, `tipo_evento`, `mensaje`, `id_curp` |

### 4.2 Atributos con valor potencial para IA
Los atributos anteriores permiten construir variables de uso analítico o predictivo asociadas a comportamiento operativo, resultado de ejecución y clasificación de incidencias. En abril se delimitó que el valor no está solo en los datos personales o de identificación, sino especialmente en la combinación entre:
- características del lote;
- estado del procesamiento;
- historial de eventos;
- resultados de descarga;
- localización operativa por entidad, municipio, localidad y CCT.

## 6. Datasets Propuestos para Curación

### 5.1 Dataset operativo por lote
Concentraría información agregada de ejecución por corrida para responder preguntas como:
- cuántos registros fueron procesados;
- cuántos terminaron en éxito o fallo;
- cuántos requirieron reproceso;
- cómo se comporta la operación por entidad o ciclo escolar.

Campos sugeridos para curación:
- `id_lote`
- `nombre_lote`
- `fecha_ejecucion`
- `entidad_federativa`
- `criterio_agrupado`
- total de CURP asociadas
- total de éxitos
- total de fallos
- total de eventos registrados

### 5.2 Dataset detallado por CURP procesada
Este dataset sería el más útil para modelos de clasificación o análisis de patrones operativos, ya que permite observar el resultado individual de cada registro procesado.

Campos sugeridos para curación:
- `curp` o identificador anonimizado equivalente
- `cct`
- `estado`
- `municipio`
- `localidad`
- `id_turno`
- `id_ciclo_escolar`
- `estatus_reporte`
- `estado_descarga`
- indicador de existencia de PDF
- número de eventos asociados

### 5.3 Dataset de incidencias y trazas
Concentraría la información de `BitacoraEvento` y de logs relevantes para clasificar errores, detectar recurrencias y priorizar revisión técnica.

Campos sugeridos para curación:
- `id_curp`
- `fecha_evento`
- `tipo_evento`
- `mensaje`
- categoría de error derivada
- severidad propuesta
- lote asociado

### 5.4 Dataset de resultados de descarga
Permitiría medir estabilidad del proceso y también alimentar modelos de predicción de riesgo de fallo o de necesidad de reproceso.

Campos sugeridos para curación:
- `curp`
- `estado_descarga`
- `ruta_pdf` o indicador anonimizado de existencia
- número de descarga
- estado/CCT/ciclo escolar
- resultado final de la corrida

## 7. Feature Sets Iniciales
- Estado de procesamiento por registro.
- Número de reintentos por CURP o lote.
- Tiempo de ejecución por lote.
- Tasa de éxito de descargas.
- Tipo y frecuencia de errores operativos.

Además de lo anterior, abril permitió definir familias de features más concretas:

### 6.1 Features operativas
- indicador binario de éxito/fallo de descarga;
- total de eventos por CURP;
- total de intentos por registro;
- participación del registro en lotes de reproceso;
- tiempo relativo de procesamiento dentro de una corrida, cuando la medición esté disponible.

### 6.2 Features de contexto institucional
- entidad federativa;
- municipio;
- localidad;
- turno;
- ciclo escolar;
- CCT o agrupación anonimizada por centro de trabajo.

### 6.3 Features derivadas de calidad y consistencia
- presencia o ausencia de correo;
- presencia o ausencia de teléfono;
- estatus de reporte;
- consistencia entre CCT y catálogo institucional;
- duplicidad o repetición histórica del mismo registro.

### 6.4 Features derivadas de trazas y mensajes
- clasificación del mensaje de error por tipo;
- frecuencia histórica de fallos por categoría;
- recurrencia de eventos por lote o entidad;
- agrupación de textos de error para análisis posterior.

## 8. Embeddings
Durante abril no se implementaron embeddings, pero se dejó definida la posibilidad de evaluarlos en fases posteriores cuando existan casos de uso concretos sobre textos, incidencias, clasificaciones o recomendaciones automáticas.

La revisión del repositorio sugiere que el uso más razonable de embeddings no estaría en datos tabulares tradicionales, sino en texto operativo, por ejemplo:
- mensajes devueltos por el servicio IMSS;
- mensajes de error capturados en bitácora;
- observaciones manuales de incidencias;
- clasificación semántica de causas de fallo.

Por lo tanto, abril dejó delimitado que los embeddings deben considerarse opcionales y solo cuando exista un caso de uso claro, como agrupación de incidentes, recomendación de atención o clasificación de errores por similitud semántica.

## 9. Criterios Básicos de Calidad
- Completitud de campos críticos.
- Consistencia de identificadores y catálogos.
- Trazabilidad entre origen, transformación y consumo.
- Eliminación o control de duplicados.
- Documentación del contexto de uso de cada dataset.

## 10. Criterios de Calidad Específicos para Abril

### 7.1 Completitud
Se identificó como obligatoria la revisión de presencia y completitud sobre campos clave como:
- CURP;
- CCT;
- ciclo escolar;
- estado de descarga;
- tipo y fecha del evento.

### 7.2 Consistencia
La consistencia debe evaluarse entre:
- `cve_escuela` y el catálogo `catalogo_cct`;
- `cve_curp` y los registros asociados en procesamiento;
- `id_lote` y sus resultados asociados;
- rutas de salida y estado de descarga registrado.

### 7.3 Duplicidad
El repositorio ya contempla control de duplicados en ciertos procesos de importación y unicidad por CURP en `CurpProcesada`. Aun así, para uso con IA, abril dejó definido que debe analizarse la duplicidad desde dos perspectivas:
- duplicados reales no deseados;
- repeticiones históricas con valor analítico, por ejemplo registros que reaparecen por reproceso.

### 7.4 Trazabilidad
Todo dataset candidato deberá permitir identificar, al menos lógicamente:
- de qué tabla o flujo provino;
- qué transformación se aplicó;
- qué nivel de anonimización o reducción de sensibilidad recibió;
- qué propósito de consumo tendrá.

## 11. Lineamientos Iniciales de Gobernanza
- Definir propósito de uso para cada dataset.
- Resguardar datos sensibles y limitar exposición por perfil.
- Mantener bitácora de transformaciones y enriquecimientos.
- Documentar calidad, periodicidad y restricciones de consumo.

## 12. Lineamientos de Gobernanza Propuestos

### 8.1 Minimización de datos
No todo atributo operativo debe ser expuesto a procesos de IA. Abril dejó como criterio base que, cuando sea posible, los identificadores directos se sustituyan por claves técnicas o seudonimizadas para reducir riesgo de exposición innecesaria.

### 8.2 Separación entre datos operativos y datasets de consumo
Se definió como buena práctica no consumir directamente las tablas operativas del proceso para experimentación analítica. En su lugar, se propone construir datasets derivados y documentados, con propósito específico y reglas claras de actualización.

### 8.3 Control de sensibilidad
Campos como CURP, correo, teléfono, rutas de archivos y ciertos mensajes operativos requieren revisión antes de ser incluidos en datasets reutilizables. En abril se delimitó que cualquier uso para IA debe pasar por una evaluación mínima de sensibilidad y necesidad de negocio.

### 8.4 Versionamiento y linaje
Todo dataset para IA deberá conservar:
- fecha de corte;
- origen de datos;
- reglas de transformación;
- responsable de generación;
- restricciones de uso.

## 13. Evidencia del Avance de Abril
- Identificación inicial de entidades y atributos reutilizables.
- Delimitación de features potenciales para análisis.
- Definición preliminar de criterios de calidad y gobernanza.
- Relación de dependencias entre datos operativos y reutilización analítica.

## 14. Evidencia Técnica Específica del Avance
- Revisión de consultas en `db.py` que exponen atributos de alumnos, contacto, CCT, estado y ciclo escolar.
- Identificación de estructuras `CurpProcesada` y `BitacoraEvento` como fuentes de resultados y trazas.
- Revisión de campos operativos útiles para construir datasets de lotes, descargas y fallos.
- Identificación de prácticas de depuración y control de duplicados en procesos auxiliares de importación.

## 15. Casos de Uso Analíticos Delimitados
Durante abril se definieron casos de uso preliminares en los que la preparación de datos para IA tendría sentido:
- clasificación de incidencias por tipo de fallo;
- priorización de revisión de lotes o registros con mayor probabilidad de error;
- agrupación de mensajes operativos similares;
- análisis de patrones territoriales o institucionales de fallos y reprocesos;
- apoyo a tableros de seguimiento con variables derivadas de operación.

## 16. Riesgos y Restricciones
- Riesgo de utilizar datos sensibles sin propósito claramente delimitado.
- Riesgo de mezclar datos operativos en tiempo real con datasets experimentales sin control de linaje.
- Riesgo de que los mensajes de error no tengan suficiente estandarización para consumo analítico inmediato.
- Dependencia de mayor volumen de operación real para consolidar features útiles y estables.

Como línea de continuidad, abril dejó también identificadas estas acciones generales:
- Consolidar datasets de trabajo con trazabilidad documentada.
- Validar calidad y consistencia de los registros seleccionados.
- Definir casos de uso concretos para features y embeddings cuando aplique.
- Integrar recomendaciones de uso en el avance mensual de mayo.

## 17. Próximos Pasos
- Definir un primer corte controlado de dataset operativo anonimizado.
- Construir diccionario de datos para lotes, CURP procesadas y eventos.
- Clasificar mensajes y tipos de fallo para una primera taxonomía analítica.
- Evaluar si existen condiciones suficientes para preparar features y, en su caso, embeddings en mayo.

---

**Comentarios adicionales:**

Este entregable corresponde al avance mensual de abril de 2026 y deja definido un marco más concreto para la curación de datasets, la selección de features, la evaluación eventual de embeddings y la gobernanza básica de datos dentro del proyecto Vida Saludable. Durante mayo deberá complementarse con datasets piloto, diccionario de datos, mayor evidencia de calidad y recomendaciones más específicas de uso para consumo con inteligencia artificial.