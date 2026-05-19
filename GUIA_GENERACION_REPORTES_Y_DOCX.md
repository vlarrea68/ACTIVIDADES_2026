# Guía de Generación de Reportes y DOCX

## Objetivo

Este documento explica cómo se construyeron los reportes mensuales y los documentos Word dentro de este repositorio, qué componentes intervienen en la generación y cómo repetir el proceso en otra computadora sin perder el flujo ya validado.

La intención es que cualquier persona, incluyendo otro agente de IA trabajando en otra máquina, pueda identificar:

- dónde vive cada reporte;
- cómo se generan los `.docx` estándar;
- cómo se generan los `.docx` con formato institucional;
- qué dependencias locales son necesarias;
- qué problemas ya se detectaron y cómo evitarlos.

## Estructura vigente del repositorio

La organización actual separa reportes mensuales generales de entregables mensuales de soporte:

- `Reportes/YYYY-MM/`
- `04-Abril-Mayo/Entregables/YYYY-MM/`
- `05-Mayo-Junio/Entregables/YYYY-MM/`

Ejemplos ya existentes:

- `Reportes/2026-03/`
- `Reportes/2026-04/`
- `Reportes/2026-05/`
- `Reportes/2026-06/`
- `04-Abril-Mayo/Entregables/2026-04/`
- `04-Abril-Mayo/Entregables/2026-05/`
- `05-Mayo-Junio/Entregables/2026-06/`

## Tipos de salida DOCX

Actualmente existen tres tipos de salida Word en este repositorio.

### 1. DOCX estándar

Se genera a partir del Markdown del mes o del entregable usando los scripts locales `md_to_docx.ps1` o `md_to_docx_entregables_*.ps1`.

Características:

- convierte el Markdown a Word usando automatización COM de Microsoft Word;
- produce una salida funcional y limpia;
- no usa la plantilla institucional enriquecida;
- sirve como base portable y como salida técnica normal.

Ejemplos:

- `Reportes/2026-03/Informe_Mensual_2026-03.docx`
- `Reportes/2026-04/Informe_Mensual_2026-04.docx`

### 2. DOCX de comparación con plantilla sencilla

Se genera con el archivo raíz:

- `TEMPLATE PARA REPORTES MENSUALES.docx`

Se usó como comparación para preservar sección de firmas institucional y estructura básica.

Ejemplo:

- `Reportes/2026-04/Informe_Mensual_2026-04_OFICINA.docx`

### 3. DOCX institucional híbrido

Es la variante actualmente más útil cuando se quiere:

- conservar el contenido real actualizado del reporte o entregable;
- aprovechar la apariencia del documento de ejemplo enriquecido;
- mantener al final la firma institucional visible como `8. Sección de firmas`.

Esta salida se genera con:

- `EjemploDiagnósticoDelEcosistemaDeDatos.docx` como base visual;
- `generar_docx_desde_template.ps1` como script principal;
- `-ReplaceBodyBeforeMarker` para eliminar el cuerpo anterior del documento base;
- `-SignatureMarker '3. Sección de firmas'` para localizar la sección real existente en el ejemplo;
- `-SignatureHeadingText '8. Sección de firmas'` para reescribir el encabezado final al formato institucional requerido.

Ejemplos:

- `Reportes/2026-03/Informe_Mensual_2026-03_INSTITUCIONAL.docx`
- `Reportes/2026-04/Informe_Mensual_2026-04_INSTITUCIONAL.docx`
- `04-Abril-Mayo/Entregables/2026-04/01-Reporte_Especificaciones_Vida_Saludable_2026-04_INSTITUCIONAL.docx`

## Archivos clave

### Scripts de conversión estándar

Cada carpeta mensual puede incluir dos scripts locales:

- `md_to_docx.py`
- `md_to_docx.ps1`

Uso recomendado:

- preferir `md_to_docx.ps1` para obtener mejor fidelidad en Word cuando Microsoft Word está instalado;
- conservar `md_to_docx.py` como alternativa portable y apoyo técnico.

### Script principal para plantilla institucional

Archivo:

- `generar_docx_desde_template.ps1`

Responsabilidades:

- convierte un Markdown a un `.docx` temporal;
- copia un `.docx` base como plantilla de salida;
- elimina el cuerpo viejo antes de la sección de firmas, si se solicita;
- inserta el contenido nuevo al inicio del documento;
- fuerza un salto de página antes de la firma;
- opcionalmente cambia el título visible de la sección de firmas.

Parámetros principales:

- `-MarkdownPath`: ruta del Markdown fuente;
- `-TemplatePath`: plantilla `.docx` base;
- `-OutputPath`: ruta del `.docx` de salida;
- `-SignatureMarker`: texto que se usará para encontrar la sección de firmas existente;
- `-SignatureHeadingText`: texto que se mostrará finalmente en la sección de firmas;
- `-ReplaceBodyBeforeMarker`: borra el contenido previo a la firma dentro de la plantilla base.

## Dependencias necesarias en otra computadora

Para repetir el flujo completo en otra máquina se necesita lo siguiente.

### Requerido para salida Word de alta fidelidad

- Windows;
- Microsoft Word instalado;
- PowerShell con permisos para ejecutar scripts al menos en alcance de proceso.

El flujo depende de COM Automation (`Word.Application`). Si Word no está instalado, el camino `.ps1` no funcionará correctamente.

### Requerido para la alternativa Python

- Python instalado;
- entorno virtual opcional, pero recomendado;
- paquete `python-docx`.

En esta máquina se trabajó con:

- Python `3.14.3`;
- entorno virtual en `.venv/`.

Activación típica en PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
& .\.venv\Scripts\Activate.ps1
```

## Flujo recomendado para regenerar documentos

### A. Generar un reporte mensual estándar

Ejemplo para abril:

```powershell
& "c:\VLP\GitHub\ACTIVIDADES_2026\Reportes\2026-04\md_to_docx.ps1"
```

Esto regenera:

- `Reportes/2026-04/Informe_Mensual_2026-04.docx`

### B. Generar un reporte mensual institucional híbrido

Ejemplo para abril:

```powershell
& "c:\VLP\GitHub\ACTIVIDADES_2026\generar_docx_desde_template.ps1" \
  -MarkdownPath "c:\VLP\GitHub\ACTIVIDADES_2026\Reportes\2026-04\Informe_Mensual_2026-04.md" \
  -TemplatePath "c:\VLP\GitHub\ACTIVIDADES_2026\EjemploDiagnósticoDelEcosistemaDeDatos.docx" \
  -OutputPath "c:\VLP\GitHub\ACTIVIDADES_2026\Reportes\2026-04\Informe_Mensual_2026-04_INSTITUCIONAL.docx" \
  -SignatureMarker "3. Sección de firmas" \
  -SignatureHeadingText "8. Sección de firmas" \
  -ReplaceBodyBeforeMarker
```

### C. Generar un entregable institucional híbrido

Ejemplo para el entregable 01 de abril:

```powershell
& "c:\VLP\GitHub\ACTIVIDADES_2026\generar_docx_desde_template.ps1" \
  -MarkdownPath "c:\VLP\GitHub\ACTIVIDADES_2026\04-Abril-Mayo\Entregables\2026-04\01-Reporte_Especificaciones_Vida_Saludable_2026-04.md" \
  -TemplatePath "c:\VLP\GitHub\ACTIVIDADES_2026\EjemploDiagnósticoDelEcosistemaDeDatos.docx" \
  -OutputPath "c:\VLP\GitHub\ACTIVIDADES_2026\04-Abril-Mayo\Entregables\2026-04\01-Reporte_Especificaciones_Vida_Saludable_2026-04_INSTITUCIONAL.docx" \
  -SignatureMarker "3. Sección de firmas" \
  -SignatureHeadingText "8. Sección de firmas" \
  -ReplaceBodyBeforeMarker
```

## Continuidad específica para mayo y junio

La estructura de mayo y junio ya quedó preparada para reutilizar exactamente el mismo flujo institucional, aunque al cierre de esta guía todavía no se habían generado todas las variantes `_INSTITUCIONAL.docx` de esos meses.

### Mayo

Ubicaciones:

- `Reportes/2026-05/`
- `04-Abril-Mayo/Entregables/2026-05/`

Estado actual:

- existe el Markdown mensual `Informe_Mensual_2026-05.md`;
- existe su DOCX estándar `Informe_Mensual_2026-05.docx`;
- existen los 5 entregables de mayo en Markdown y DOCX estándar;
- existe el script `md_to_docx_entregables_2026-05.ps1`.

Sentido documental de mayo:

- mayo debe registrar evidencia operativa del mes;
- no debe duplicar la línea base de abril;
- debe concentrarse en validaciones, resultados, monitoreo, incidencias y seguimiento.

Comando modelo para generar la variante institucional del reporte de mayo:

```powershell
& "c:\VLP\GitHub\ACTIVIDADES_2026\generar_docx_desde_template.ps1" \
  -MarkdownPath "c:\VLP\GitHub\ACTIVIDADES_2026\Reportes\2026-05\Informe_Mensual_2026-05.md" \
  -TemplatePath "c:\VLP\GitHub\ACTIVIDADES_2026\EjemploDiagnósticoDelEcosistemaDeDatos.docx" \
  -OutputPath "c:\VLP\GitHub\ACTIVIDADES_2026\Reportes\2026-05\Informe_Mensual_2026-05_INSTITUCIONAL.docx" \
  -SignatureMarker "3. Sección de firmas" \
  -SignatureHeadingText "8. Sección de firmas" \
  -ReplaceBodyBeforeMarker
```

Comando modelo para un entregable de mayo:

```powershell
& "c:\VLP\GitHub\ACTIVIDADES_2026\generar_docx_desde_template.ps1" \
  -MarkdownPath "c:\VLP\GitHub\ACTIVIDADES_2026\04-Abril-Mayo\Entregables\2026-05\01-Reporte_Especificaciones_Vida_Saludable_2026-05.md" \
  -TemplatePath "c:\VLP\GitHub\ACTIVIDADES_2026\EjemploDiagnósticoDelEcosistemaDeDatos.docx" \
  -OutputPath "c:\VLP\GitHub\ACTIVIDADES_2026\04-Abril-Mayo\Entregables\2026-05\01-Reporte_Especificaciones_Vida_Saludable_2026-05_INSTITUCIONAL.docx" \
  -SignatureMarker "3. Sección de firmas" \
  -SignatureHeadingText "8. Sección de firmas" \
  -ReplaceBodyBeforeMarker
```

### Junio

Ubicaciones:

- `Reportes/2026-06/`
- `05-Mayo-Junio/Entregables/2026-06/`

Estado actual:

- existe el Markdown mensual `Informe_Mensual_2026-06.md`;
- existe su DOCX estándar `Informe_Mensual_2026-06.docx`;
- existen los 5 entregables de junio en Markdown y DOCX estándar;
- existe el script `md_to_docx_entregables_2026-06.ps1`.

Sentido documental de junio:

- junio debe operar como cierre trimestral;
- debe separar claramente lo ejecutado en abril, la evidencia de mayo y las conclusiones finales;
- debe incluir comparativos, recomendaciones y estado final de las cinco líneas de trabajo.

Comando modelo para generar la variante institucional del reporte de junio:

```powershell
& "c:\VLP\GitHub\ACTIVIDADES_2026\generar_docx_desde_template.ps1" \
  -MarkdownPath "c:\VLP\GitHub\ACTIVIDADES_2026\Reportes\2026-06\Informe_Mensual_2026-06.md" \
  -TemplatePath "c:\VLP\GitHub\ACTIVIDADES_2026\EjemploDiagnósticoDelEcosistemaDeDatos.docx" \
  -OutputPath "c:\VLP\GitHub\ACTIVIDADES_2026\Reportes\2026-06\Informe_Mensual_2026-06_INSTITUCIONAL.docx" \
  -SignatureMarker "3. Sección de firmas" \
  -SignatureHeadingText "8. Sección de firmas" \
  -ReplaceBodyBeforeMarker
```

Comando modelo para un entregable de junio:

```powershell
& "c:\VLP\GitHub\ACTIVIDADES_2026\generar_docx_desde_template.ps1" \
  -MarkdownPath "c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06\01-Reporte_Especificaciones_Vida_Saludable_2026-06.md" \
  -TemplatePath "c:\VLP\GitHub\ACTIVIDADES_2026\EjemploDiagnósticoDelEcosistemaDeDatos.docx" \
  -OutputPath "c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06\01-Reporte_Especificaciones_Vida_Saludable_2026-06_INSTITUCIONAL.docx" \
  -SignatureMarker "3. Sección de firmas" \
  -SignatureHeadingText "8. Sección de firmas" \
  -ReplaceBodyBeforeMarker
```

### Criterio para continuar en otra computadora

Si otra IA o persona retoma el trabajo en otra máquina, para mayo y junio debe asumir este criterio:

- no rehacer la estructura de carpetas porque ya está definida;
- usar primero los `.md` y `.docx` estándar existentes como base documental vigente;
- generar nuevas salidas institucionales con sufijo `_INSTITUCIONAL.docx`;
- no sobrescribir los `.docx` estándar salvo que se quiera regenerarlos explícitamente;
- validar siempre que el documento resultante empiece con el contenido del mes y termine con `8. Sección de firmas`.

## Criterios de nombrado

Convenciones usadas:

- Markdown mensual: `Informe_Mensual_YYYY-MM.md`
- DOCX mensual estándar: `Informe_Mensual_YYYY-MM.docx`
- DOCX de plantilla simple: `Informe_Mensual_YYYY-MM_OFICINA.docx`
- DOCX híbrido institucional: `Informe_Mensual_YYYY-MM_INSTITUCIONAL.docx`
- Entregables enumerados: `01-...`, `02-...`, `03-...`, `04-...`, `05-...`
- Entregables híbridos institucionales: mismo nombre + sufijo `_INSTITUCIONAL.docx`

## Problemas encontrados y solución adoptada

### 1. Word dejaba archivos bloqueados

Síntoma:

- no se podía borrar o sobrescribir un `.docx` temporal o final;
- aparecían procesos `WINWORD` huérfanos.

Solución usada:

- cerrar correctamente documentos COM;
- en casos de bloqueo, cerrar procesos `WINWORD` sin ventana principal antes de reintentar.

### 2. La búsqueda con `Find` fallaba en el documento ejemplo

Síntoma:

- `EjemploDiagnósticoDelEcosistemaDeDatos.docx` contiene una entrada de índice con `3. Sección de firmas`;
- Word podía quedarse encontrando la referencia del índice en lugar de la sección real.

Solución adoptada:

- recorrer `Document.Paragraphs` y localizar el último párrafo que contiene el marcador;
- no depender de `Find.Execute()` para ese caso.

### 3. El ejemplo conservaba texto viejo

Síntoma:

- el archivo generado seguía mostrando el cuerpo del documento ejemplo.

Solución adoptada:

- usar `-ReplaceBodyBeforeMarker`;
- localizar el marcador real de la firma;
- borrar el contenido previo a ese punto y luego insertar el contenido nuevo.

## Qué revisar si se mueve a otra computadora

Antes de usar este repositorio en otra máquina, revisar:

- que Microsoft Word abra correctamente por COM;
- que existan en la raíz los archivos `TEMPLATE PARA REPORTES MENSUALES.docx` y `EjemploDiagnósticoDelEcosistemaDeDatos.docx`;
- que PowerShell pueda ejecutar scripts;
- que las rutas locales se ajusten al nuevo directorio del repositorio;
- que no haya procesos `WINWORD` colgados.

## Recomendación operativa

Si se necesita repetir el trabajo en otra computadora, seguir esta secuencia:

1. clonar el repositorio;
2. confirmar que Word está instalado;
3. activar la `.venv` si se usará el flujo Python;
4. regenerar primero el `.docx` estándar del mes o entregable;
5. generar después la variante `_INSTITUCIONAL.docx` si se requiere formato de oficina;
6. validar que el documento final empiece con el contenido nuevo y termine con la sección de firmas.

## Estado validado al cierre de esta etapa

Al cierre de esta documentación ya se habían generado y validado:

- reportes mensuales estándar de marzo a junio;
- variantes institucionales de marzo y abril;
- variantes institucionales de los 5 entregables de abril;
- estructura de mayo y junio preparada para continuar el mismo flujo.

## Nota final para futuros ajustes

Si en el futuro se cambia la plantilla base o el documento ejemplo, hay que volver a validar al menos estos tres puntos:

- el texto exacto del marcador de firmas;
- la posición real de la sección de firmas;
- que el documento generado no conserve contenido viejo del archivo base.