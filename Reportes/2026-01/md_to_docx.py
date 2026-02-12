import markdown
from docx import Document
from docx.shared import Inches
import os

# Ruta de los archivos
md_path = r"c:/VLP/GitHub/ACTIVIDADES_2026/Reportes/2026-01/Informe_Mensual_2026-01.md"
docx_path = r"c:/VLP/GitHub/ACTIVIDADES_2026/Reportes/2026-01/Informe_Mensual_2026-01.docx"

def md_to_docx(md_path, docx_path):
    # Leer el archivo markdown
    with open(md_path, 'r', encoding='utf-8') as f:
        md_text = f.read()

    # Crear documento Word
    doc = Document()
    doc.add_heading('Informe Mensual de Actividades', 0)

    # Procesar líneas
    for line in md_text.splitlines():
        if line.startswith('# '):
            doc.add_heading(line[2:], level=1)
        elif line.startswith('## '):
            doc.add_heading(line[3:], level=2)
        elif line.startswith('### '):
            doc.add_heading(line[4:], level=3)
        elif line.startswith('- '):
            doc.add_paragraph(line[2:], style='List Bullet')
        elif line.startswith('1. '):
            doc.add_paragraph(line, style='List Number')
        elif line.strip().startswith('|') and line.strip().endswith('|'):
            # Saltar tablas markdown (no conversión directa)
            continue
        elif line.strip().startswith('```'):
            # Saltar bloques de código
            continue
        elif line.strip() == '':
            doc.add_paragraph('')
        else:
            doc.add_paragraph(line)

    # Guardar documento
    doc.save(docx_path)
    print(f"Documento Word generado en: {docx_path}")

if __name__ == "__main__":
    md_to_docx(md_path, docx_path)
