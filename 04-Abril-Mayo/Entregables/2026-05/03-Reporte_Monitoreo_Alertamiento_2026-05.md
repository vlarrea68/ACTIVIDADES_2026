# Reporte de Monitoreo, Alertamiento e Incidencias

**Mes:** Mayo 2026  
**Responsable:** Victor Manuel Lelo de Larrea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Documentar las políticas de alertamiento, trazabilidad de incidencias operativas y resoluciones de seguridad identificadas durante mayo. Este reporte detalla la madurez de los procesos de *Root Cause Analysis* (RCA) instrumentados sobre ambos frentes: la plataforma MUSEMS-PU y el orquestador de descargas de Vida Saludable.

## 2. Eventos y Mitigaciones de Seguridad (Vida Saludable)
El sistema de monitoreo humano y automático derivó en la identificación del incidente de seguridad crítico más relevante del mes, catalogado el 17 de abril/mayo y remediado íntegramente.

### 2.1 Identificación de Violación a LGPDPPSO
- **Detección:** El 17 de abril se detectó que un archivo temporal `MENORES_SIN_PADECIMIENTO.csv` (12.6 MB, con 128,112 registros) fue subido por error al historial de Git, conteniendo datos personales (CURPs y nombres completos).
- **Criticidad:** Riesgo legal de sanción administrativa por violación a los artículos 6, 11, 13 y 21 de la Ley de Protección de Datos.
- **Remediación Aplicada (RCA):**
  - **Fase 1 (Inmediata):** Eliminación del archivo, reemplazo por `examples/*.csv` sintéticos, actualización estricta del `.gitignore`.
  - **Fase 2 (Profunda):** Reescritura absoluta del historial de Git en las ramas `feature` y `master` empleando `git filter-repo`/`BFG Repo-Cleaner`, revocando cualquier clon viejo del repositorio.
- **Medidas Preventivas Post-Mortem:** Diseño de un script `pre-commit` hook local en Python (`.git/hooks/pre-commit`) que escanea preventivamente extensiones `*.csv` y detiene commits que incluyan la palabra `MENORES` o `CURP`, acoplando la seguridad desde el control de versiones.

## 3. Incidentes de Interfaz de Usuario (SEP_MUSEMS_PU - Issue #45)
A la par, se instrumentó un esquema de monitorización sobre el Frontend del proyecto secundario para diagnosticar problemas de permisos y *Information Leakage*.

### 3.1 Análisis de Causa Raíz (RCA) - Fugas de Metadatos
- **Síntoma Identificado:** Los logs de red y reportes de usuario indicaban que usuarios con permisos restringidos podían ver y presionar pestañas críticas (Incidencias Técnicas, Deserción Bajas), arrojando errores recurrentes 403 HTTP.
- **Diagnóstico (Issue #45):** El código en `App.tsx` poseía un acoplamiento incompleto de guardias de UI (`hasPermission(...)`). Se trataba de una falta de abstracción donde el menú imperativo permitía montajes de componentes por defecto.
- **Remediación Estructural:** Se refactorizó el menú hacia un arreglo de objetos (Data-driven menu) e implementó el componente `<ProtectedRoute>` para interceptar renders a nivel de React y validar contra la matriz de la tabla `CTMU064` de Oracle.

## 4. Trazas y Umbrales Técnicos del Orquestador
La instrumentación en el sistema de descargas del IMSS reportó latencias persistidas que permitieron reajustar los umbrales estáticos:

- **Circuit Breaker Activo:** Se validó empíricamente que el límite de Rate Limit de la API IMSS se rebasa al usar 20 hilos. Esto quedó marcado como una *Warning* proactiva y no como falla total de lote.
- **Umbrales Modificados:** El sistema ahora despacha alertas a los canales secundarios de soporte si el lote excede el 8% de *failures* (Nivel Crítico) o el 3% (Nivel Preventivo), disminuyendo la "fatiga de alertas" sobre los responsables operativos.

## 5. Próximos Pasos
- Consolidar las herramientas de monitoreo (como el hook pre-commit) en todos los flujos de trabajo de repositorios corporativos.
- Auditar regularmente los reportes del componente protegido de UI para evitar regresiones de visibilidad de módulos en Oracle.