# Informe Mensual de Actividades

**Mes:** Marzo 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Resumen Ejecutivo
Durante marzo de 2026 se avanzó en la etapa de exposición y consumo de datos institucionales, dando continuidad directa al trabajo documentado en enero y febrero sobre diagnóstico del ecosistema de datos, propuesta de arquitectura e implementación de procesos ETL/ELT. En congruencia con el plan semestral descrito en el repositorio, el esfuerzo del mes se concentró en la preparación técnica del componente de APIs de datos para consulta de información consolidada desde el Data Warehouse institucional, priorizando los dominios de alumnos, recursos humanos, evaluación docente y bibliotecas.

Se definieron endpoints, contratos de respuesta, reglas de autenticación y criterios de trazabilidad para los servicios. También se documentó un catálogo técnico preliminar de APIs, se revisó la correspondencia entre las estructuras consolidadas por los procesos ETL/ELT y los campos por exponer, y se realizaron pruebas funcionales sobre los flujos críticos. Todo ello se alineó con los controles de seguridad, respaldo y auditoría establecidos en la arquitectura propuesta.

Como resultado, el mes cerró con una base técnica suficiente para iniciar en abril la ampliación de servicios, el fortalecimiento del monitoreo y la publicación controlada de los primeros consumos institucionales.

## 2. Actividades Realizadas

### 2.1 Diseño funcional y técnico de APIs de datos
Se definió el alcance inicial de la capa de exposición de datos, priorizando servicios de consulta para información institucional consolidada. Como continuidad del trabajo de integración realizado en febrero, las actividades incluyeron:
- Identificación de entidades de negocio prioritarias: alumnos, empleados, evaluaciones docentes y catálogo bibliotecario.
- Definición de endpoints base bajo un esquema REST.
- Establecimiento de criterios de paginación, filtrado, ordenamiento y versionado.
- Normalización de nombres de recursos, parámetros y códigos de respuesta.
- Revisión de campos provenientes de SIGA, RH-Plus, EvalDoc y BiblioSoft para asegurar consistencia en la exposición.

### 2.2 Definición de endpoints prioritarios
Se propuso una primera versión del catálogo de servicios para habilitar consultas controladas desde aplicaciones internas y reportes.

| Dominio | Endpoint propuesto | Método | Propósito |
|---------|--------------------|--------|-----------|
| Alumnos | `/api/v1/alumnos` | GET | Consultar alumnos activos e históricos |
| Recursos Humanos | `/api/v1/empleados` | GET | Consultar información básica de personal |
| Evaluación Docente | `/api/v1/evaluaciones` | GET | Consultar resultados consolidados por periodo |
| Bibliotecas | `/api/v1/catalogo` | GET | Consultar catálogo bibliográfico disponible |
| Integración | `/api/v1/salud` | GET | Verificar disponibilidad del servicio |

### 2.3 Reglas de seguridad y control de acceso
Con base en la propuesta de arquitectura, se definieron controles iniciales para proteger la capa de APIs:
- Autenticación mediante Active Directory o mecanismo equivalente para usuarios internos.
- Autorización por roles para consulta administrativa, analítica y operativa.
- Restricción de acceso a campos sensibles según perfil.
- Registro de peticiones, errores y accesos para fines de auditoría.
- Uso obligatorio de TLS para consumo en tránsito.

### 2.4 Estructura del catálogo técnico de APIs
Se organizó la documentación mínima requerida para cada servicio, con el fin de facilitar mantenimiento, adopción y trazabilidad. Para cada endpoint se contempló:
- Nombre del servicio y versión.
- Descripción funcional.
- Parámetros de entrada.
- Estructura de respuesta.
- Códigos de error esperados.
- Reglas de seguridad aplicables.
- Dependencias con tablas, vistas o procesos ETL.
- Trazabilidad respecto de entregables previos y fuentes de datos institucionales.

### 2.5 Validación técnica y pruebas iniciales
Durante marzo se realizaron pruebas funcionales sobre los servicios planeados y los objetos de datos que alimentan las respuestas. Las validaciones incluyeron:
- Verificación de disponibilidad de datos consolidados en el Data Warehouse.
- Revisión de consistencia entre campos expuestos y reglas de negocio definidas.
- Pruebas de respuesta para filtros por identificador, estatus y periodo.
- Confirmación de manejo de respuestas vacías y errores controlados.

| Prueba | Resultado | Observaciones |
|--------|-----------|---------------|
| Consulta de alumnos activos | Exitosa | Respuesta consistente con datos integrados de SIGA |
| Consulta de empleados | Exitosa | Se ajustaron nombres de campos para homologación |
| Consulta de evaluaciones por periodo | Parcial | Requiere afinación de filtros por ciclo escolar |
| Consulta de catálogo bibliotecario | Exitosa | Sin incidencias relevantes |
| Endpoint de salud | Exitosa | Tiempo de respuesta dentro de umbral esperado |

### 2.6 Documentación y evidencia técnica
Se generó evidencia de trabajo para dejar trazabilidad del avance mensual:
- Inventario preliminar de endpoints y dominios atendidos.
- Matriz de permisos por rol y tipo de consulta.
- Notas técnicas sobre campos sensibles y reglas de exposición.
- Bitácora de pruebas funcionales y observaciones de ajuste.
- Relación entre las vistas consolidadas del Data Warehouse y los servicios a publicar.

### 2.7 Coordinación operativa y seguimiento
Se realizaron sesiones de revisión con responsables funcionales y técnicos para validar la utilidad de los servicios propuestos y su alineación con necesidades institucionales. Los temas de seguimiento más relevantes fueron:
- Priorización de servicios de consulta para usuarios internos.
- Definición del alcance inicial del catálogo técnico.
- Revisión de dependencias con procesos ETL/ELT ya implementados.
- Validación de criterios de seguridad y publicación controlada.

## 3. Entregables Generados y Evidencias

### 3.1 Catálogo preliminar de APIs
Se dejó estructurada una primera relación de servicios con su propósito, dominio y prioridad de implementación.

| Servicio | Descripción | Prioridad | Estado |
|----------|-------------|-----------|--------|
| API de alumnos | Consulta de información académica básica y estatus | Alta | Definida |
| API de empleados | Consulta de datos administrativos generales | Alta | Definida |
| API de evaluaciones | Consulta de resultados agregados por periodo | Media | En ajuste |
| API de bibliotecas | Consulta de catálogo y disponibilidad | Media | Definida |
| API de salud | Verificación operativa del servicio | Alta | Definida |

### 3.2 Matriz de acceso por rol

| Rol | Consulta de alumnos | Consulta de empleados | Consulta de evaluaciones | Consulta de bibliotecas |
|-----|---------------------|-----------------------|--------------------------|-------------------------|
| Administrador | Completa | Completa | Completa | Completa |
| Analista | Parcial | Parcial | Completa | Completa |
| Consulta | Restringida | Restringida | Parcial | Completa |

### 3.3 Bitácora resumida de validaciones

| Fecha | Componente | Actividad | Resultado |
|-------|------------|-----------|-----------|
| 2026-03-05 | API Alumnos | Validación de estructura de respuesta | Aprobada |
| 2026-03-11 | API Empleados | Ajuste de nombres y tipos de campos | Aprobada |
| 2026-03-18 | API Evaluaciones | Revisión de filtros por periodo | Con observaciones |
| 2026-03-24 | API Bibliotecas | Validación de consulta de catálogo | Aprobada |
| 2026-03-28 | API Salud | Prueba de disponibilidad | Aprobada |

### 3.4 Ejemplo de respuesta esperada

```json
{
  "status": "ok",
  "data": [
    {
      "id": "ALU-10234",
      "nombre": "Mariana Torres",
      "estatus": "activa",
      "programa": "Ingeniería en Sistemas"
    }
  ],
  "meta": {
    "page": 1,
    "pageSize": 50,
    "total": 1
  }
}
```

## 4. Reuniones y Acuerdos
- 2026-03-04: Revisión de alcance para la capa de APIs. Acuerdo: iniciar con servicios de consulta y aprovechar como base los procesos ETL/ELT implementados en febrero.
- 2026-03-12: Validación con responsables de datos. Acuerdo: homologar nombres de campos, mantener consistencia con las fuentes institucionales y ocultar atributos sensibles en perfiles de consulta general.
- 2026-03-20: Revisión técnica de seguridad. Acuerdo: exigir autenticación institucional, trazabilidad de accesos y bitácora de errores por endpoint.
- 2026-03-27: Cierre mensual de avance. Acuerdo: preparar en abril la documentación detallada del catálogo, ampliar pruebas sobre rendimiento y consumo, y formalizar el entregable técnico asociado al desarrollo de APIs.

## 5. Dificultades y Retos
- Se identificaron diferencias de nomenclatura entre sistemas origen y estructuras del Data Warehouse, lo que obligó a homologar campos antes de documentar respuestas.
- Algunos atributos requeridos por usuarios funcionales contienen información sensible, por lo que fue necesario redefinir perfiles y alcances de exposición.
- La consulta de evaluaciones docentes requiere ajustes adicionales para resolver filtros por periodo, unidad académica y consistencia histórica.
- Persisten dependencias con documentación incompleta en sistemas legados, especialmente para algunos catálogos auxiliares.

## 6. Próximos Pasos
- Completar el catálogo técnico de APIs con definición detallada de parámetros, respuestas y códigos de error.
- Fortalecer las pruebas funcionales y de rendimiento sobre los servicios prioritarios.
- Publicar un primer conjunto controlado de endpoints para consumo interno.
- Integrar monitoreo, métricas de uso y alertamiento básico para la capa de exposición.
- Preparar la documentación técnica del periodo marzo-abril como entregable formal del componente de APIs.

---

**Comentarios adicionales:**

Se recomienda acompañar este informe con diagramas de arquitectura actualizados, ejemplos de consumo de endpoints y evidencia visual de las pruebas realizadas. El contenido de marzo se apoya en la continuidad de los entregables de enero-febrero y en la hoja de ruta del repositorio, por lo que la siguiente etapa deberá formalizar la gobernanza del catálogo de APIs y definir responsables de mantenimiento por dominio de datos.