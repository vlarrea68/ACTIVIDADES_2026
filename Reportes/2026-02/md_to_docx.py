import markdown
from docx import Document
from markdown2 import markdown as md2
import os

# Ruta de entrada y salida
input_md = r"Reportes/2026-02/Informe_Mensual_2026-02.md"
output_docx = r"Reportes/2026-02/Informe_Mensual_2026-02.docx"

# Leer el archivo Markdown
with open(input_md, encoding="utf-8") as f:
    md_text = f.read()

# Convertir Markdown a HTML
html = md2(md_text)

# Crear documento Word
doc = Document()

def add_html_to_docx(html, doc):
    from bs4 import BeautifulSoup
    soup = BeautifulSoup(html, "html.parser")
    for elem in soup.find_all(['h1','h2','h3','h4','h5','h6','p','ul','ol','li','pre','code','table']):
        if elem.name.startswith('h'):
            doc.add_heading(elem.get_text(), int(elem.name[1]))
        elif elem.name == 'p':
            doc.add_paragraph(elem.get_text())
        elif elem.name == 'li':
            doc.add_paragraph('• ' + elem.get_text())
        elif elem.name == 'pre' or elem.name == 'code':
            doc.add_paragraph(elem.get_text(), style='Intense Quote')
        elif elem.name == 'table':
            rows = elem.find_all('tr')
            cols = rows[0].find_all(['td','th'])
            table = doc.add_table(rows=len(rows), cols=len(cols))
            for i, row in enumerate(rows):
                for j, cell in enumerate(row.find_all(['td','th'])):
                    table.cell(i,j).text = cell.get_text()

add_html_to_docx(html, doc)

doc.save(output_docx)
print(f"Archivo Word generado: {output_docx}")
