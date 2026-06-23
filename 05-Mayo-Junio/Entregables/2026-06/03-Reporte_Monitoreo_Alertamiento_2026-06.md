# Acta de Cierre: Monitoreo Perimetral y Alertamiento

**Mes:** Junio 2026  
**Responsable:** Victor Manuel Lelo de Larea Polanco  
**Área:** Coordinación de Proyectos de TI

---

## 1. Objeto del Entregable
Acreditar la transferencia operativa de los controles de seguridad perimetral, volumetría y alertamiento integrados en la arquitectura backend de la plataforma MUSEMS (Release Candidate 1). Este reporte funciona como acta de conclusión demostrando la protección automatizada activa contra patrones de abuso e inundación (DDoS / Fuerza Bruta).

## 2. Consolidación de Controles Volumétricos (Rate Limiting)

La arquitectura se entrega blindada mediante la orquestación del middleware de observabilidad volumétrica apoyado en `slowapi`.

### 2.1 Umbrales Entregados en el Entorno QA
Se transfiere el control de los límites volumétricos configurados bajo la premisa de "Falla Segura" (Fail-Safe):
- Los endpoints transaccionales públicos (como `/login`, `/forgot-password`) están estrictamente acotados a un máximo de **5 peticiones por minuto** por cada dirección IP de origen.
- Toda superación de este umbral genera automáticamente una excepción de red `429 Too Many Requests`, interceptando la ráfaga a nivel de aplicación (FastAPI) y protegiendo el procesador de base de datos Oracle contra la inanición de conexiones.

### 2.2 Trazabilidad de Auditoría
El control y la alerta de denegación por abuso han sido cubiertos y certificados bajo casos de prueba rigurosos, verificables en la **Matriz de Rastreo y Trazabilidad** transferida al área de operaciones.

## 3. Consideraciones para el Soporte Continuo
Si bien la protección volumétrica actual garantiza la resiliencia base, se transfiere al equipo de operaciones el deber de monitorear el comportamiento de las IPs bajo arquitecturas de red complejas (Carrier-grade NAT). Se recomienda el análisis constante de las cabeceras `X-Forwarded-For` en los logs de los servidores en Producción para afinar la precisión del bloqueo en caso de falsos positivos sistémicos.

## 4. Inventario de Entregables Finales (Handover Tecnológico)

El blindaje de monitoreo y la estrategia de contención se formaliza con la transferencia de los siguientes artefactos aprobados:
- Entregable CMMI (06) **Pruebas de Estrés**, validando el comportamiento volumétrico del sistema.
- Entregable CMMI (04) **Pruebas Funcionales**, certificando la intercepción adecuada (respuesta HTTP 429) por parte de las defensas del sistema sin degradación del resto de servicios.

Estos activos acreditan que el servicio se entrega altamente resiliente y equipado para la operación crítica institucional.