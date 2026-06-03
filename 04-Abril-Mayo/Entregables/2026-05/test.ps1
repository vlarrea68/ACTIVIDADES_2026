$mermaid = "graph TD`nA-->B"
$bodyObj = @{
    diagram_source = $mermaid
    diagram_type = "mermaid"
    output_format = "png"
}
$body = $bodyObj | ConvertTo-Json
try {
    Invoke-WebRequest -Uri 'https://kroki.io/' -Method Post -Body $body -ContentType 'application/json' -OutFile "test_kroki.png" -UseBasicParsing
    Write-Host "Success"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
