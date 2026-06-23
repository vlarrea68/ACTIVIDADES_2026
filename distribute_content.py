import os
import re

base_dir = r"c:\VLP\GitHub\ACTIVIDADES_2026\05-Mayo-Junio\Entregables\2026-06"
informe_path = r"c:\VLP\GitHub\ACTIVIDADES_2026\Reportes\2026-06\Informe_Mensual_2026-06.md"

with open(informe_path, 'r', encoding='utf-8') as f:
    informe_content = f.read()

# Extract sections
# 1. Vida Saludable (Criptografía)
vida_saludable_sec = re.search(r'(### 3\.1 Blindaje de Criptografía e Inyecciones SQL \(Vida Saludable\).*?)(?=\n###|\n##|\Z)', informe_content, re.DOTALL).group(1)

# 2. MUSEMS-PU Rendimiento y Seguridad (Implementación Defensiva)
musems_defensiva = re.search(r'(### 3\.2 Implementación Defensiva en MUSEMS-PU.*?)(?=\n###|\n##|\Z)', informe_content, re.DOTALL).group(1)
musems_arq = re.search(r'(### 2\.1 Ecosistema de Inteligencia Analítica \(MUSEMS-PU\).*?)(?=\n###|\n##|\Z)', informe_content, re.DOTALL).group(1)

# 3. QA Despliegue
qa_sec = re.search(r'(## 5\. Resumen de Despliegue Oficial en Ambiente QA.*?)(?=\n###|\n##|\Z)', informe_content, re.DOTALL).group(1)

# 4. ETL y Documental
etl_sec = re.search(r'(### 4\.2 Automatización Inmutable de Entregables Gubernamentales \(`generate_docs\.py`\).*?)(?=\n###|\n##|\Z)', informe_content, re.DOTALL).group(1)

# 5. Datos IA / SAST
sast_sec = re.search(r'(### 4\.1 Análisis SAST / SCA \(Barrera de Código\).*?)(?=\n###|\n##|\Z)', informe_content, re.DOTALL).group(1)


# Files to append to
files = {
    "01-Reporte_Especificaciones_Vida_Saludable_2026-06.md": f"\n\n## Actualización Especial de Cierre (Junio 2026)\n\n{vida_saludable_sec}",
    "02-Informe_Optimizacion_Rendimiento_BD_2026-06.md": f"\n\n## Actualización Especial de Cierre (Junio 2026)\n\n{musems_defensiva}",
    "03-Reporte_Monitoreo_Alertamiento_2026-06.md": f"\n\n## Actualización Especial de Cierre (Junio 2026)\n\n{qa_sec}",
    "04-Reporte_Preparacion_Datos_IA_2026-06.md": f"\n\n## Actualización Especial de Cierre (Junio 2026)\n\n{sast_sec}",
    "05-Informe_Procesos_ETL_ELT_2026-06.md": f"\n\n## Actualización Especial de Cierre (Junio 2026)\n\n{etl_sec}\n\n{musems_arq}"
}

for fname, addition in files.items():
    path = os.path.join(base_dir, fname)
    with open(path, 'a', encoding='utf-8') as f:
        f.write(addition)
    print(f"Updated {fname}")
