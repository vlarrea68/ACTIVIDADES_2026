$mermaid = "graph TD`nA-->B"
try {
    Invoke-WebRequest -Uri 'https://kroki.io/mermaid/png' -Method Post -Body $mermaid -ContentType 'text/plain' -OutFile "test_kroki2.png" -UseBasicParsing
    Write-Host "Success text/plain"
} catch {
    Write-Host "Error text/plain: $($_.Exception.Message)"
}
