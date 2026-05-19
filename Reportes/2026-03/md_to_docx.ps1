$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$mdPath = Join-Path $baseDir 'Informe_Mensual_2026-03.md'
$htmlPath = Join-Path $baseDir 'Informe_Mensual_2026-03.html'
$docxPath = Join-Path $baseDir 'Informe_Mensual_2026-03.docx'

function Convert-ToHtmlSafe {
    param([string]$Text)

    return [System.Net.WebUtility]::HtmlEncode($Text)
}

function Convert-InlineMarkdownToHtml {
    param([string]$Text)

    $encoded = Convert-ToHtmlSafe -Text $Text
    $encoded = [regex]::Replace($encoded, '\*\*(.+?)\*\*', '<strong>$1</strong>')
    $encoded = [regex]::Replace($encoded, '`([^`]+)`', '<code>$1</code>')
    return $encoded
}

$lines = Get-Content -Path $mdPath -Encoding UTF8
$html = New-Object System.Collections.Generic.List[string]
$html.Add('<!DOCTYPE html>')
$html.Add('<html><head><meta charset="utf-8">')
$html.Add('<style>body{font-family:Calibri,Arial,sans-serif;font-size:11pt;} h1,h2,h3{color:#1f1f1f;} table{border-collapse:collapse;width:100%;margin:12px 0;} th,td{border:1px solid #666;padding:6px;text-align:left;vertical-align:top;} pre{font-family:Consolas,monospace;background:#f4f4f4;padding:10px;border:1px solid #ddd;white-space:pre-wrap;} ul{margin-top:0;} hr{border:none;border-top:1px solid #888;}</style>')
$html.Add('</head><body>')

$index = 0
$inList = $false
$inCode = $false

while ($index -lt $lines.Count) {
    $line = $lines[$index]

    if ($line.StartsWith('```')) {
        if (-not $inCode) {
            if ($inList) {
                $html.Add('</ul>')
                $inList = $false
            }
            $html.Add('<pre>')
            $inCode = $true
        }
        else {
            $html.Add('</pre>')
            $inCode = $false
        }
        $index++
        continue
    }

    if ($inCode) {
        $html.Add((Convert-ToHtmlSafe -Text $line))
        $index++
        continue
    }

    if ($line.Trim().StartsWith('|')) {
        if ($inList) {
            $html.Add('</ul>')
            $inList = $false
        }

        $tableLines = @()
        while ($index -lt $lines.Count -and $lines[$index].Trim().StartsWith('|')) {
            $tableLines += $lines[$index].Trim()
            $index++
        }

        if ($tableLines.Count -ge 2) {
            $headers = $tableLines[0].Trim('|').Split('|') | ForEach-Object { Convert-InlineMarkdownToHtml -Text $_.Trim() }
            $html.Add('<table>')
            $html.Add('<thead><tr>')
            foreach ($header in $headers) {
                $html.Add("<th>$header</th>")
            }
            $html.Add('</tr></thead>')
            $html.Add('<tbody>')

            for ($rowIndex = 2; $rowIndex -lt $tableLines.Count; $rowIndex++) {
                $cells = $tableLines[$rowIndex].Trim('|').Split('|') | ForEach-Object { Convert-InlineMarkdownToHtml -Text $_.Trim() }
                $html.Add('<tr>')
                foreach ($cell in $cells) {
                    $html.Add("<td>$cell</td>")
                }
                $html.Add('</tr>')
            }

            $html.Add('</tbody></table>')
        }
        continue
    }

    if ($line.StartsWith('# ')) {
        if ($inList) {
            $html.Add('</ul>')
            $inList = $false
        }
        $html.Add("<h1>$(Convert-InlineMarkdownToHtml -Text $line.Substring(2))</h1>")
    }
    elseif ($line.StartsWith('## ')) {
        if ($inList) {
            $html.Add('</ul>')
            $inList = $false
        }
        $html.Add("<h2>$(Convert-InlineMarkdownToHtml -Text $line.Substring(3))</h2>")
    }
    elseif ($line.StartsWith('### ')) {
        if ($inList) {
            $html.Add('</ul>')
            $inList = $false
        }
        $html.Add("<h3>$(Convert-InlineMarkdownToHtml -Text $line.Substring(4))</h3>")
    }
    elseif ($line.StartsWith('- ')) {
        if (-not $inList) {
            $html.Add('<ul>')
            $inList = $true
        }
        $html.Add("<li>$(Convert-InlineMarkdownToHtml -Text $line.Substring(2))</li>")
    }
    elseif ($line.Trim() -eq '---') {
        if ($inList) {
            $html.Add('</ul>')
            $inList = $false
        }
        $html.Add('<hr />')
    }
    elseif ([string]::IsNullOrWhiteSpace($line)) {
        if ($inList) {
            $html.Add('</ul>')
            $inList = $false
        }
    }
    else {
        if ($inList) {
            $html.Add('</ul>')
            $inList = $false
        }
        $html.Add("<p>$(Convert-InlineMarkdownToHtml -Text $line)</p>")
    }

    $index++
}

if ($inList) {
    $html.Add('</ul>')
}

if ($inCode) {
    $html.Add('</pre>')
}

$html.Add('</body></html>')
[System.IO.File]::WriteAllLines($htmlPath, $html, [System.Text.Encoding]::UTF8)

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

try {
    if (Test-Path $docxPath) {
        Remove-Item $docxPath -Force
    }
    $document = $word.Documents.Open($htmlPath, $false, $false)
    $format = 16
    $document.SaveAs2([string]$docxPath, [int]$format)
    $document.Close()
    Write-Output "Documento Word generado en: $docxPath"
}
finally {
    $word.Quit()
    if (Test-Path $htmlPath) {
        Remove-Item $htmlPath -Force
    }
}