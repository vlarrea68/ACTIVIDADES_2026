$markdownFiles = Get-ChildItem -Filter '*.md'

foreach ($file in $markdownFiles) {
    # Generate INSTITUCIONAL
    $outName = $file.BaseName + '_INSTITUCIONAL.docx'
    $outPath = Join-Path $file.DirectoryName $outName
    
    Write-Host "Generando Institucional: $outPath"
    & 'C:\VLP\GitHub\ACTIVIDADES_2026\generar_docx_desde_template.ps1' -MarkdownPath $file.FullName -OutputPath $outPath -SignatureMarker '8. Sección de firmas' -ReplaceBodyBeforeMarker
}

# Regenerar el primero que falló si es que lo cerraron
Write-Host "Regenerando documentos normales..."
& 'C:\VLP\GitHub\ACTIVIDADES_2026\04-Abril-Mayo\Entregables\2026-05\md_to_docx_entregables_2026-05.ps1'
