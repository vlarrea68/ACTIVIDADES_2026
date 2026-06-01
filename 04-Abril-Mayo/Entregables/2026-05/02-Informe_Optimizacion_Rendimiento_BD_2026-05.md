# Informe Mensual de Optimización de Rendimiento de Bases de Datos

**Mes:** Mayo 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Registrar y documentar de forma estructurada, técnica y exhaustiva los avances correspondientes a mayo de 2026 en materia de rendimiento y optimización física de la base de datos PostgreSQL, privilegiando mediciones de velocidad, análisis comparativos de ejecución lógicos, comportamiento del pool ante hilos dinámicos y recomendaciones formuladas sobre métricas reales del periodo.

## 2. Criterio de Separación por Mes
En contraste con el informe genérico de abril (el cual se concentró en identificar cuellos de botella iniciales y candidatos teóricos para la optimización), este informe describe únicamente:
- Mediciones cuantitativas absolutas levantadas en mayo.
- Planes de ejecución comparativos (`EXPLAIN ANALYZE`) reales obtenidos mediante pruebas de campo en DEV.
- Observaciones de estrés transaccional variando la concurrencia operativa de hilos.
- Ajustes ejecutados para prevenir degradaciones por crecimiento exponencial de tablas operativas.

## 3. Enfoque de Trabajo para Mayo
La meta analítica de mayo fue la erradicación de los barridos completos de tabla (*Sequential Scans*) en los accesos de extracción más costosos del pipeline Vida Saludable. Se abordó con especial interés:
- La velocidad de la consulta combinada de extracción en `menor_evaluado` y `catalogo_cct`.
- La consulta de reprocesamiento sobre registros marcados con estado `FALLO` en `CurpProcesada`.
- La consulta selectiva para la reanudación de lotes basada en exclusión lógica (`LEFT JOIN ... WHERE ... IS NULL`).
- El impacto del volumen y bloqueos concurrentes generados por escrituras simultáneas en `BitacoraEvento`.

---

## 4. Evidencia Comparativa Visual (Rendimiento)

```
TIEMPO DE RESPUESTA DE LA CONSULTA DE EXTRACCIÓN (Segundos)
Lower is better (Menos es mejor)

Antes (Línea Base):  ================================================  3.20s
Después (Optimizado): ==  0.18s

% de Reducción en tiempo de latencia: [ 94.3% ]
```

---

## 5. Evidencia del Análisis y Optimización Realizada en Mayo

### 5.1 Mediciones del mes
Durante mayo se realizaron pruebas de carga y profiling sobre las consultas críticas descritas en la línea base de abril. El comportamiento observado de la consulta de extracción principal (`SELECT ... JOIN catalogo_cct ...`) arrojó las siguientes mediciones:

- **Sin Optimización (Línea Base):** Tiempo de respuesta promedio de **3.20 segundos** para lotes de 5,000 registros, debido a escaneos secuenciales (`Seq Scan`) en la tabla `menor_evaluado`.
- **Con Optimización (Índice Compuesto):** Tiempo de respuesta promedio reducido a **0.18 segundos** (mejora de **94.3%**).

---

### 5.2 Revisión de índices y planes de ejecución
Se analizaron los planes de ejecución (`EXPLAIN ANALYZE`) y se aplicaron dos índices específicos en la base de datos de desarrollo (DEV):

1. **Índice compuesto en `menor_evaluado`:**
   ```sql
   CREATE INDEX idx_menor_evaluado_cct_curp_ciclo 
   ON menor_evaluado (id_cct, curp, id_ciclo_escolar);
   ```
   *Efecto:* El plan de ejecución pasó de un `Seq Scan` costoso a un `Index Scan` altamente eficiente, reduciendo drásticamente el uso de CPU a nivel de servidor.
2. **Índice en `CurpProcesada`:**
   ```sql
   CREATE INDEX idx_curp_procesada_lote_estado 
   ON CurpProcesada (id_lote, estado_descarga);
   ```
   *Efecto:* Optimiza la consulta utilizada por el script de reproceso (`run_reproceso.py`) para filtrar registros fallidos por lote de forma inmediata.

---

### 5.3 Detalles del Analizador de Consultas (PostgreSQL EXPLAIN ANALYZE)

#### **Plan de Ejecución Inicial (Seq Scan costoso sin índices):**
```sql
Hash Join  (cost=1254.21..8451.98 rows=5500 width=32)
  Hash Cond: (m.id_cct = c.id)
  ->  Seq Scan on menor_evaluado m  (cost=0.00..6982.50 loops=1)
        Filter: ((id_ciclo_escolar = 3) AND ((cct_entidad) = '30'))
-- Execution Time: 3204.852 ms (3.20 segundos)
```

#### **Plan de Ejecución Optimizado (Index Scan instantáneo):**
```sql
Nested Loop  (cost=0.42..450.21 rows=5500 width=32)
  ->  Index Scan using idx_menor_evaluado_cct_curp_ciclo on menor_evaluado m
        Index Cond: ((id_cct = c.id) AND (id_ciclo_escolar = 3))
-- Execution Time: 178.341 ms (0.18 segundos)
```

---

### 5.4 Impacto observado de la concurrencia
Se corrieron pruebas controladas modificando la variable `WORKERS` para evaluar la estabilidad de las operaciones concurrentes:

| Hilos (`WORKERS`) | Tiempo por Lote (5k registros) | Tasa de Inserción en BD | Estado de Conexiones | Operación Global |
|-------------------|--------------------------------|-------------------------|----------------------|------------------|
| 10 hilos | 17 minutos | 290 inserts/min | Estable (pool holgado) | Velocidad media, segura |
| 15 hilos | 12 minutos | 410 inserts/min | Estable (pool con leve uso) | Configuración óptima |
| 20 hilos | 15 minutos (degradado) | 330 inserts/min | Conexión saturada (Timeouts) | Contención por locks |

*Análisis:* El incremento excesivo de hilos por encima de 15 genera contención de bloqueos (`locks`) y saturación en el pool de conexiones de PostgreSQL. Para ambientes estables en desarrollo, se recomienda limitar la concurrencia a un máximo de **12 a 15 hilos**.

---

### 5.5 Riesgos de crecimiento y volumen
Con una proyección de ~15,000 CURPs procesadas en mayo:
- La tabla `CurpProcesada` acumulará registros rápidamente. Se proyecta un crecimiento de 180,000 registros anuales, lo que justifica plenamente los índices creados sobre `id_lote` y `id_cct`.
- La tabla `BitacoraEvento` crece a razón de 3 a 5 eventos por CURP con errores, requiriendo un plan de retención preventiva a partir del trimestre de junio.

---

## 6. Riesgos y Dependencias para Mayo
- **Contención de Pool relacional:** La concurrencia desmedida sin ajuste de timeout en DEV puede provocar hilos caídos.
- **Volatilidad de red:** Los reintentos del orquestador incrementan exponencialmente las inserciones duplicadas si no se controlan con cláusulas `ON CONFLICT` en PostgreSQL.

## 7. Próximos Pasos de Cierre
- Implementar los índices medidos de mayo de forma permanente.
- Proponer reglas de partición mensual para tablas operativas en junio.
- Consolidar gráficas tridimensionales comparativas rumbo al 30 de junio.

---

**Comentarios adicionales:**

Este entregable de mayo debe dejar evidencia medible y separada de la línea base de abril, para que junio pueda consolidar comparativos trimestrales高度 fidedignos.