# Informe Mensual de Actividades

**Mes:** Junio 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Resumen Ejecutivo
Durante junio de 2026, el trabajo se concentró en consolidar el cierre trimestral de las cinco líneas de trabajo del proyecto. Se ha concluido con la estabilización, el pase a producción y la entrega formal del proyecto principal **MUSEMS** (Plataforma de Inteligencia Analítica), alcanzando su estado *Release Candidate 1 (RC1)* el 18 de junio, integrado a la rama `main` y desplegado en QA.

Respecto al proyecto **Vida Saludable (Fase 2)**, su línea base quedó cerrada y validada en mayo tras la pausa declarada, manteniendo el estado de infraestructura y migración listos para cuando se decida su reinicio operativo. 

El presente informe consolida los resultados observados, las remediaciones de seguridad estructurales implementadas y el establecimiento de pipelines DevSecOps para la verificación técnica, asegurando el cumplimiento de los hitos trimestrales.

## 2. Consolidación del Trimestre (Abril - Junio)

### 2.1 Proyecto Vida Saludable
- **Cierre Trimestral:** El proyecto entró en pausa indefinida el 29 de abril de 2026 con un estado exitoso ("Migración Validada", "Documentación Completa", "Infraestructura Lista"). 
- **Resultados Consolidados:** La arquitectura backend (FastAPI + pg8000 + SFTP Key-based Auth) y el frontend (Angular 18) quedaron funcionales y testeados. El modelo de datos (DDL) en PostgreSQL 14 fue validado para los flujos de IMSS.
- **Recomendación Final:** Quedan preparadas las tareas para el reinicio: apertura formal de PR a `master`, y el Sprint 1 de Construcción para la validación funcional de layouts con área médica.

### 2.2 Rendimiento de bases de datos y backend
- **Cierre Trimestral:** En el proyecto MUSEMS, se optimizó radicalmente el ciclo de validación de identidad. Se erradicó la dependencia obsoleta `passlib` a favor de `bcrypt` nativo (Issue #55), resolviendo fallas de colección de pruebas y optimizando la carga asíncrona hacia la base Oracle 19c.
- **Riesgo Mitigado:** Se redujo drásticamente la exposición a ataques de denegación de servicio (DoS) por carga criptográfica excesiva durante el *login*.

### 2.3 Monitoreo y alertamiento (Rate Limiting)
- **Cierre Trimestral:** Ante el riesgo volumétrico, se adoptó y configuró la librería `slowapi` en la capa de FastAPI de MUSEMS (Issue #56) como un limitador estricto para rutas de autenticación.
- **Umbrales Aplicados:** Se configuró un máximo de 5 peticiones por minuto por IP origen en `/login` y `/forgot-password`, rechazando subsecuentes solicitudes con `HTTP 429 Too Many Requests` protegiendo así los recursos del sistema.

### 2.4 Preparación de datos para Inteligencia Analítica (MUSEMS)
- **Cierre Trimestral:** La plataforma MUSEMS fue entregada satisfactoriamente con la construcción de las *Vistas Analíticas* (e.g. `VW_BI_MUSEMS_REINSCRIPCIONES`) en Oracle. 
- **Protección PII:** Se consolidó la gobernanza de datos enmascarando de inicio la CURP de los estudiantes en la interfaz y registrando en una bitácora técnica de base de datos cualquier desenmascaramiento explícito. 

### 2.5 Integración Continua y Calidad (DevSecOps - ETL del CI)
- **Cierre Trimestral:** Se consolidó el ciclo de vida del desarrollo asegurado (Secure SDLC) en MUSEMS (Issue #57) con un pipeline de GitHub Actions (`security-ci.yml`) que actúa como barrera de código.
- **Herramientas Implementadas:** SAST (Static Application Security Testing) mediante `bandit` y `semgrep`; SCA (Software Composition Analysis) usando `pip-audit` y `npm audit`, asegurando de manera automatizada la resiliencia del software entregado.

## 3. Reuniones y Acuerdos del Mes
- **2026-06-18:** Entrega formal (Handover) de la Plataforma de Inteligencia Analítica MUSEMS a la Dirección de Inteligencia Analítica / Equipo de Ingeniería y QA de la SEP.

## 4. Dificultades y Retos Resueltos
- Transición ágil de un enfoque de revisión puramente manual de vulnerabilidades a un pipeline 100% estricto con bloqueos (`exit 1`) en PRs cuando ocurren fallas críticas, madurando la cultura DevOps del equipo sin detener la velocidad de entregas en MUSEMS.
- Manejo proactivo de falsos positivos en Rate Limiting (slowapi) considerando arquitecturas con Carrier-grade NAT.

## 5. Próximos Pasos Posteriores a Junio
- Reiniciar las actividades operativas del proyecto *Vida Saludable* en cuanto la dirección lo determine, ejecutando los Sprints 1 y 2 planificados.
- Mantener y dar soporte a los pases a producción de MUSEMS, monitoreando el comportamiento real de los *Rate Limiters* con usuarios concurrentes de la SEP.

---

**Comentarios adicionales:**

El periodo culmina de forma satisfactoria entregando componentes reales, testeados, y mitigando exitosamente las principales vulnerabilidades OWASP detectadas. El cumplimiento contractual por líneas de trabajo se encuentra 100% evidenciado a nivel técnico.