# Informe de Optimización y Rendimiento de Bases de Datos

**Mes:** Junio 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Documentar los resultados finales del trimestre en materia de optimización de rendimiento y cargas transaccionales hacia bases de datos. Durante junio, el foco resolutivo recayó sobre la Plataforma de Inteligencia Analítica (MUSEMS), remediando cuellos de botella criptográficos que afectaban la validación asíncrona contra Oracle 19c.

## 2. Resultados Consolidados de Junio

### 2.1 Refactorización de Capa de Autenticación (Issue #55)
Se abordó un problema estructural que amenazaba el rendimiento del sistema en picos de concurrencia. Se eliminó la dependencia obsoleta `passlib`, la cual incrementaba el procesamiento en CPU al validar credenciales, reemplazándose con el uso directo de `bcrypt` nativo. 
Este ajuste minimizó los ciclos de cómputo en la validación asíncrona de hashes contra los registros de la tabla `CTMU061_USUARIO` en la base de datos, garantizando una respuesta eficiente.

### 2.2 Optimización de Pruebas Unitarias
Se solucionó una falla crítica en la recolección de pruebas (*collection phase* de `pytest`) que mantenía interacciones activas con la base de datos durante la fase de carga estática de los módulos. Al aislar correctamente los módulos de prueba, se liberó estrés innecesario sobre la base de datos Oracle durante los ciclos de CI en desarrollo.

### 2.3 Resiliencia en Conexión
La configuración final del *connection pool* de `oracledb` fue verificada para el release final (RC1) desplegado en la IP `168.255.101.67:1530/MUSEMSD`. Se aseguró que el flujo backend gestione el *Thin Mode Pool* sin saturar las sesiones en Oracle, permitiendo transacciones concurrentes seguras y de baja latencia.

## 3. Riesgos Remanentes y Conclusiones
- **Riesgos Mitigados:** El sistema ya no presenta vulnerabilidades de degradación de servicio a nivel de base de datos provocadas por ineficiencias criptográficas. Se ha logrado un rendimiento óptimo en la ruta crítica del *login*.
- **Riesgo Operativo Futuro:** Como pendiente (Backlog QA), se recomienda ejecutar un `EXPLAIN PLAN` en Oracle sobre la vista analítica `VW_BI_MUSEMS_REINSCRIPCIONES` en producción para afinar la indexación en caso de observarse lentitud al graficar trayectorias extensas.

## 4. Próximos Pasos Posteriores a Junio
- Monitorear en producción (QA y PROD) los tiempos de respuesta bajo carga viva sobre las vistas analíticas de negocio de MUSEMS.
- Aplicar las estrategias de índices sobre las tablas maestras si se detectan latencias superiores a 1.5 segundos en la interfaz.

---

**Comentarios adicionales:**
El trimestre se cierra confirmando que la infraestructura de datos en MUSEMS ha sido entregada estable y escalable, eliminando dependencias tóxicas y preservando el performance de lectura y validación.