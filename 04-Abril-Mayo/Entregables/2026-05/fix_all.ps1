$files = Get-ChildItem -Path "C:\VLP\GitHub\ACTIVIDADES_2026" -Include "md_to_docx*.ps1", "generar_docx_desde_template.ps1" -Recurse -File

$searchPattern = '(?s)try \{\s*\[System.Net.ServicePointManager\]::SecurityProtocol = \[System.Net.SecurityProtocolType\]::Tls12\s*Invoke-WebRequest -Uri ''https://kroki.io/mermaid/png'' -Method Post -Body \$mermaidContent -ContentType ''text/plain'' -OutFile \$imgPath -UseBasicParsing\s*\$html.Add\("<img src="".+?"" style=""max-width: 100%; height: auto;"" />"\)\s*\$tempImages.Add\(\$imgPath\)\s*\}'

$replacePattern = 'try {
                        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
                        $tempImg = Join-Path $env:TEMP "mermaid_temp_$([guid]::NewGuid().ToString()).png"
                        Invoke-WebRequest -Uri ''https://kroki.io/mermaid/png'' -Method Post -Body $mermaidContent -ContentType ''text/plain'' -OutFile $tempImg -UseBasicParsing
                        $b64 = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($tempImg))
                        $html.Add("<img src=""data:image/png;base64,$b64"" style=""max-width: 100%; height: auto;"" />")
                        Remove-Item $tempImg -Force
                    }'

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    if ($content -match $searchPattern) {
        $content = $content -replace $searchPattern, $replacePattern
        Set-Content -Path $file.FullName -Value $content
        Write-Host "Updated $($file.FullName)"
    }
}
