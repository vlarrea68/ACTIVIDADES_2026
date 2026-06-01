# Reporte de Preparación y Anonimización de Datos (Datasets IA)

**Mes:** Mayo 2026  
**Responsable:** Victor Manuel Lelo de Larrea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Detallar el trabajo riguroso de diseño de arquitecturas de datos seguras, desidentificadas y curadas bajo protocolos criptográficos. El objetivo de este documento es validar la creación de *datasets* aptos para el entrenamiento e inferencia de modelos analíticos sin vulnerar en lo absoluto las disposiciones de la Ley General de Protección de Datos Personales (LGPDPPSO).

## 2. Lecciones Operativas del Incidente de Seguridad (Abril)
La preparación de datos de mayo estuvo fuertemente influenciada por la mitigación inmediata del incidente de exposición de datos (Issue reportado en repositorio). Al encontrarse en fase piloto, la manipulación de layouts de origen evidenció la fragilidad del manejo de CSVs crudos.

### 2.1 Refinamiento de Criterios de Anonimización
A raíz de lo anterior, se formalizó que **ningún dataset descriptivo, predictivo o analítico puede contener texto plano de los siguientes campos**:
- CURP del Menor o Tutor.
- Nombres Completos o Apellidos.
- Referencias telefónicas o correos electrónicos (PII Crítico).

Toda la evidencia de entrenamiento de IA se genera procesando los datos mediante la técnica:
`MD5_HASH(CURP_TEXTO_PLANO + 'SALT_INSTITUCIONAL')`

## 3. Preparación de Datasets Piloto para Inteligencia Artificial
Durante mayo, se generaron y depuraron de manera 100% ciega (sin PII) cuatro conjuntos de datos de prueba destinados a la parametrización de un potencial modelo predictivo de fallos de red y carga dinámica.

### 3.1 `dataset_lote_piloto_202605.csv` (15 Registros Agregados)
Contiene las características consolidadas del comportamiento del pool por corrida:
- **Variables Predictivas:** `estado_origen`, `horas_del_dia`, `num_workers` asignados, `tamanio_batch`.
- **Variable Objetivo (Target):** `tasa_exito_descarga` y `ms_promedio_respuesta`.

### 3.2 `dataset_curp_anom_piloto_202605.csv` (1,000 Registros)
Muestra representativa de alumnos (Veracruz y Puebla) utilizando un diseño estricto de columnas:
- `curp_hash`: Identificador trazable internamente pero inútil en el exterior.
- `cct_hash`: Clave del Centro de Trabajo ofuscada.
- `ciclo`, `turno`, `estatus_api`.

### 3.3 `dataset_incidencias_piloto_202605.csv` (120 Registros)
Extraído directamente de la tabla `BitacoraEvento` de PostgreSQL, este set servirá para clasificar anomalías en los patrones de respuesta HTTP devueltos por el IMSS.
- Clases incluidas: `RateLimitError` (HTTP 429), `ConnectionTimeout`, `InvalidFormatError`.

### 3.4 `dataset_descargas_pdf_piloto_202605.csv` (500 Registros)
Dataset que correlaciona el volumen en bytes del PDF resultante con el tiempo de descarga, para análisis de distribuciones de tráfico.

## 4. Pruebas y Validación (Test Plan)
Se sometieron los datasets generados a la validación estricta de la matriz de procesos:
1. **Verificación de Colisiones Hash:** Se analizó si dos CURPs distintas podían generar el mismo hash truncado, confirmando la robustez de MD5 con salt.
2. **Inspección de Fugas:** Se validaron los 4 archivos con regex heurísticas (`^\d{10}$` para teléfonos, `^.*@.*$` para emails), corroborando cero detecciones de PII en texto plano.

## 5. Próximos Pasos
- Suministrar estos 4 conjuntos de datos a la división de analítica de datos en junio para realizar las primeras iteraciones de agrupamiento (*clustering*) predictivo de errores.
- Evaluar el abandono progresivo de archivos CSV por la serialización Parquet, el cual preserva los tipos de dato (esquema) y ofrece compresión superior.