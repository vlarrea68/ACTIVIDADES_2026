import os
import glob
import re

base_dir = r"c:\VLP\GitHub\ACTIVIDADES_2026"
files = glob.glob(os.path.join(base_dir, r"05-Mayo-Junio\Entregables\2026-06\*.md"))
files += glob.glob(os.path.join(base_dir, r"Reportes\2026-06\Informe_Mensual_2026-06.md"))

for fpath in files:
    with open(fpath, "r", encoding="utf-8") as f:
        content = f.read()

    # Remove the GitHub alerts and replace them with standard **Nota:** etc
    content = re.sub(r'>\s*\[!WARNING\]\s*\n', '**Advertencia:**\n', content)
    content = re.sub(r'>\s*\[!CAUTION\]\s*\n', '**Precaución:**\n', content)
    content = re.sub(r'>\s*\[!NOTE\]\s*\n', '**Nota:**\n', content)
    content = re.sub(r'>\s*\[!IMPORTANT\]\s*\n', '**Importante:**\n', content)
    content = re.sub(r'>\s*\[!TIP\]\s*\n', '**Sugerencia:**\n', content)
    
    # Remove blockquotes entirely so they just become normal paragraphs
    content = re.sub(r'^>\s+', '', content, flags=re.MULTILINE)

    with open(fpath, "w", encoding="utf-8") as f:
        f.write(content)

print("Markdown cleaned successfully.")
