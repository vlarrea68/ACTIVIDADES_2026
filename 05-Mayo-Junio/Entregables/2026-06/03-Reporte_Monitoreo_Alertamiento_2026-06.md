# Reporte Mensual de Monitoreo y Alertamiento

**Mes:** Junio 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Documentar los controles de monitoreo preventivo, volumétrico y alertamiento consolidados al cierre del trimestre. Durante el mes de junio, la prioridad se centró en la seguridad perimetral a nivel aplicativo de la plataforma MUSEMS (Issue #56), previniendo ataques de denegación de servicio e inundación.

## 2. Resultados Consolidados de Junio

### 2.1 Implementación de Monitoreo Volumétrico (Rate Limiting)
Para resolver la ausencia de controles en la concurrencia de acceso y autenticación, se instrumentó exitosamente la librería `slowapi` en la capa de FastAPI del proyecto MUSEMS. Este componente actúa como un monitor activo que evalúa en tiempo real las ráfagas provenientes de una misma dirección IP origen.

### 2.2 Configuración de Umbrales
- Se definió un umbral estricto de **5 peticiones por minuto** (`5/minute`) exclusivamente sobre endpoints críticos de negocio: `/login`, `/forgot-password` y `/reset-password`.
- Los flujos analíticos internos operan sin restricciones de umbral, salvaguardando la operatividad general post-inicio de sesión.

### 2.3 Evidencia y Resultados del Monitoreo
Durante las pruebas de validación, la herramienta demostró bloquear conexiones abusivas, devolviendo exitosamente el código HTTP de alertamiento `429 Too Many Requests` de manera estandarizada y absteniéndose de invocar la carga en la base de datos Oracle, lo cual preservó de facto la resiliencia operativa de la infraestructura backend.

## 3. Manejo de Excepciones y Riesgos
- **Riesgo por Proxies/NAT:** Se identificó la posibilidad técnica de falsos positivos en redes con NAT estricto (uso compartido de IP pública). Para mitigarlo, la arquitectura depende de la lectura correcta de la cabecera `X-Forwarded-For` o de `ProxyFix` a nivel de despliegue productivo.
- **Testing Continuo:** Para no interrumpir los procesos de monitoreo E2E (Smoke Tests con Playwright), se instrumentó a nivel de pipeline una correcta tolerancia a este Rate Limiting asegurando que los bots de test no se automarginen del sistema.

## 4. Próximos Pasos Posteriores al Trimestre
- Analizar los registros (logs) de producción para dimensionar la incidencia de alertas tipo `429` generadas por uso real.
- Validar con el área de operaciones si es requerido conectar este limitador a un almacén de caché distribuido (como Redis) en futuros rediseños o escalados de instancias (pods).

---

**Comentarios adicionales:**
Con las acciones efectuadas en junio, la organización cierra el trimestre con una madurez sustancial en la detección temprana y mitigación activa de ráfagas anómalas (observabilidad volumétrica), mitigando amenazas del Top 10 de OWASP.