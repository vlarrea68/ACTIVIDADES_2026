$png = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes("test_kroki.png"))
$html = "<html><body><img src='data:image/png;base64,$png' /></body></html>"
Set-Content -Path "test_b64.html" -Value $html
$word = New-Object -ComObject Word.Application
$word.Visible = $false
$doc = $word.Documents.Open("C:\VLP\GitHub\ACTIVIDADES_2026\04-Abril-Mayo\Entregables\2026-05\test_b64.html", $false, $false)
$doc.SaveAs2("C:\VLP\GitHub\ACTIVIDADES_2026\04-Abril-Mayo\Entregables\2026-05\test_b64.docx", 16)
$doc.Close()
$word.Quit()
Write-Host "Success"
