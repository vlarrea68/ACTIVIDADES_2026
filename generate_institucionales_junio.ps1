$ErrorActionPreference = "Stop"

$templateCmd = "c:\VLP\GitHub\ACTIVIDADES_2026\generar_docx_desde_template.ps1"
$templatePath = (Get-ChildItem -Path "c:\VLP\GitHub\ACTIVIDADES_2026\TEMPLATE PARA REPORTES MENSUALES.docx").FullName
$signatureMarker = "8. Sección de firmas"
$signatureHeading = "8. Sección de firmas"

Write-Host "Generando Institucional General 2026-06..."
& $templateCmd -MarkdownPath "c:\VLP\GitHub\ACTIVIDADES_2026\Reportes\2026-06\Informe_Mensual_2026-06.md" -TemplatePath $templatePath -OutputPath "c:\VLP\GitHub\ACTIVIDADES_2026\Reportes\2026-06\Informe_Mensual_2026-06_INSTITUCIONAL.docx" -SignatureMarker $signatureMarker -SignatureHeadingText $signatureHeading -ReplaceBodyBeforeMarker

Write-Host "Generando Entregable 01..."
& $templateCmd -MarkdownPath "c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06\01-Reporte_Especificaciones_Vida_Saludable_2026-06.md" -TemplatePath $templatePath -OutputPath "c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06\01-Reporte_Especificaciones_Vida_Saludable_2026-06_INSTITUCIONAL.docx" -SignatureMarker $signatureMarker -SignatureHeadingText $signatureHeading -ReplaceBodyBeforeMarker

Write-Host "Generando Entregable 02..."
& $templateCmd -MarkdownPath "c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06\02-Informe_Optimizacion_Rendimiento_BD_2026-06.md" -TemplatePath $templatePath -OutputPath "c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06\02-Informe_Optimizacion_Rendimiento_BD_2026-06_INSTITUCIONAL.docx" -SignatureMarker $signatureMarker -SignatureHeadingText $signatureHeading -ReplaceBodyBeforeMarker

Write-Host "Generando Entregable 03..."
& $templateCmd -MarkdownPath "c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06\03-Reporte_Monitoreo_Alertamiento_2026-06.md" -TemplatePath $templatePath -OutputPath "c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06\03-Reporte_Monitoreo_Alertamiento_2026-06_INSTITUCIONAL.docx" -SignatureMarker $signatureMarker -SignatureHeadingText $signatureHeading -ReplaceBodyBeforeMarker

Write-Host "Generando Entregable 04..."
& $templateCmd -MarkdownPath "c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06\04-Reporte_Preparacion_Datos_IA_2026-06.md" -TemplatePath $templatePath -OutputPath "c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06\04-Reporte_Preparacion_Datos_IA_2026-06_INSTITUCIONAL.docx" -SignatureMarker $signatureMarker -SignatureHeadingText $signatureHeading -ReplaceBodyBeforeMarker

Write-Host "Generando Entregable 05..."
& $templateCmd -MarkdownPath "c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06\05-Informe_Procesos_ETL_ELT_2026-06.md" -TemplatePath $templatePath -OutputPath "c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06\05-Informe_Procesos_ETL_ELT_2026-06_INSTITUCIONAL.docx" -SignatureMarker $signatureMarker -SignatureHeadingText $signatureHeading -ReplaceBodyBeforeMarker

Write-Host "Todos los documentos generados exitosamente."
