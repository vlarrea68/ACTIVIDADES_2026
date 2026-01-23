# Diagnóstico del Ecosistema de Datos 2026

**Fecha:** Enero 2026  
**Responsable:** [Nombre del responsable]  
**Área:** Coordinación de Proyectos de TI

---

## 1. Introducción
Este documento presenta el diagnóstico inicial del ecosistema de datos institucional, con el objetivo de identificar fuentes, evaluar la calidad y volumen de los datos, detectar riesgos y definir prioridades de atención para el año 2026.

## 2. Inventario de Fuentes de Datos
1. **Base de Datos de Alumnos**
	- Descripción: Contiene información académica y personal de los estudiantes activos y egresados.
	- Responsable: Departamento de Servicios Escolares
	- Sistema origen: Sistema Escolar SIGA
2. **Sistema de Recursos Humanos**
	- Descripción: Datos de empleados, nómina, asistencias y evaluaciones de desempeño.
	- Responsable: Dirección de Recursos Humanos
	- Sistema origen: RH-Plus
3. **Plataforma de Evaluación Docente**
	- Descripción: Resultados de encuestas de evaluación docente realizadas por los alumnos.
	- Responsable: Coordinación Académica
	- Sistema origen: EvalDoc
4. **Sistema de Bibliotecas**
	- Descripción: Préstamos, devoluciones y catálogo de libros.
	- Responsable: Biblioteca Central
	- Sistema origen: BiblioSoft

## 3. Evaluación de Calidad y Volumen
**Completitud:**
- La Base de Datos de Alumnos presenta un 98% de registros completos; sin embargo, faltan datos de contacto en 2% de los casos.
- El Sistema de Recursos Humanos tiene campos de dirección incompletos en 5% de los empleados.

**Consistencia:**
- Se detectaron inconsistencias en los nombres de alumnos (acentos y mayúsculas/minúsculas) y duplicidad de registros en la Plataforma de Evaluación Docente.

**Actualidad:**
- La información de la Base de Datos de Alumnos y RH se actualiza diariamente.
- El Sistema de Bibliotecas actualiza su catálogo semanalmente.

**Volumen:**
- Base de Datos de Alumnos: 25,000 registros activos, 80,000 históricos.
- Recursos Humanos: 2,500 empleados activos.
- Plataforma de Evaluación Docente: 15,000 encuestas por semestre.

## 4. Identificación de Riesgos
1. **Duplicidad de registros en evaluaciones docentes**
	- Impacto: Medio. Puede distorsionar resultados y análisis.
	- Probabilidad: Alta.
2. **Falta de respaldo periódico en el Sistema de Bibliotecas**
	- Impacto: Alto. Pérdida de información de préstamos y catálogo.
	- Probabilidad: Media.
3. **Acceso no controlado a la Base de Datos de Alumnos**
	- Impacto: Alto. Riesgo de fuga de información personal.
	- Probabilidad: Media.

## 5. Priorización de Acciones para 2026
1. Implementar reglas de validación y depuración en la Plataforma de Evaluación Docente para eliminar duplicados y estandarizar nombres.
2. Establecer respaldos automáticos semanales en el Sistema de Bibliotecas.
3. Revisar y reforzar los controles de acceso a la Base de Datos de Alumnos, implementando autenticación de dos factores.

## 6. Conclusiones y Recomendaciones
El diagnóstico realizado permitió identificar las principales fuentes de datos institucionales, así como sus fortalezas y áreas de oportunidad. Se recomienda priorizar la mejora de calidad y seguridad en las fuentes críticas, así como establecer procesos de respaldo y validación de datos. Estas acciones sentarán las bases para una gestión de datos más eficiente y segura durante 2026.

---

**Anexos:**
- Tablas de inventario detallado
- Evidencias de calidad y volumen
- Matriz de riesgos
