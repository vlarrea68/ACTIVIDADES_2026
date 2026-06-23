import os
import shutil

base_out_dir = r"c:\VLP\GitHub\ACTIVIDADES_2026"
musems_doc_dir = r"c:\VLP\GitHub\SEP_MUSEMS_PU\DOCUMENTACION"
vida_doc_dir = r"c:\VLP\GitHub\py-sep-descarga-vida-saludable\fase-2"

# 01-Reporte_Especificaciones_Vida_Saludable_2026-06.md
path_01 = os.path.join(base_out_dir, r"05-Mayo-Junio\Entregables\2026-06\01-Reporte_Especificaciones_Vida_Saludable_2026-06.md")
with open(path_01, 'a', encoding='utf-8') as f:
    f.write("\n\n## Anexo Forense de Cierre: Análisis Técnico de Código y Criptografía\n\n")
    # Append ANALISIS-TECNICO-CODIGO-2026-04-17.md
    with open(os.path.join(vida_doc_dir, "ANALISIS-TECNICO-CODIGO-2026-04-17.md"), 'r', encoding='utf-8') as src:
        # Strip level 1 headers and replace github alerts
        text = src.read().replace("# ", "### ").replace(">[!WARNING]", "**Advertencia:**").replace(">[!NOTE]", "**Nota:**")
        f.write(text)

# 02-Informe_Optimizacion_Rendimiento_BD_2026-06.md
path_02 = os.path.join(base_out_dir, r"05-Mayo-Junio\Entregables\2026-06\02-Informe_Optimizacion_Rendimiento_BD_2026-06.md")
with open(path_02, 'a', encoding='utf-8') as f:
    f.write("\n\n## Anexo Forense de Cierre: Diccionarios de Datos y Vistas Analíticas Oficiales\n\n")
    # Append diccionario_datos_musems.md
    with open(os.path.join(musems_doc_dir, "diccionario_datos_musems.md"), 'r', encoding='utf-8') as src:
        text = src.read().replace("# ", "### ")
        f.write(text)
    # Append DICCIONARIO_VISTAS_ANALITICAS_MUSEMS.md
    f.write("\n\n### Diccionario Complementario de Vistas Analíticas Institucionales\n\n")
    with open(os.path.join(musems_doc_dir, "DICCIONARIO_VISTAS_ANALITICAS_MUSEMS.md"), 'r', encoding='utf-8') as src:
        text = src.read().replace("# ", "### ")
        f.write(text)

# 03-Reporte_Monitoreo_Alertamiento_2026-06.md
path_03 = os.path.join(base_out_dir, r"05-Mayo-Junio\Entregables\2026-06\03-Reporte_Monitoreo_Alertamiento_2026-06.md")
with open(path_03, 'a', encoding='utf-8') as f:
    f.write("\n\n## Anexo Forense de Cierre: Checklist de Auditoría, Observabilidad y Monitoreo WAF\n\n")
    # Append CHECKLIST-AUDITORIA-2026-04-17.md
    with open(os.path.join(vida_doc_dir, "CHECKLIST-AUDITORIA-2026-04-17.md"), 'r', encoding='utf-8') as src:
        text = src.read().replace("# ", "### ")
        f.write(text)

# 04-Reporte_Preparacion_Datos_IA_2026-06.md
path_04 = os.path.join(base_out_dir, r"05-Mayo-Junio\Entregables\2026-06\04-Reporte_Preparacion_Datos_IA_2026-06.md")
with open(path_04, 'a', encoding='utf-8') as f:
    f.write("\n\n## Anexo Forense de Cierre: Matriz de Políticas y Preparación SAST/SCA\n\n")
    # Append MATRIZ-PROCESOS-POLITICAS-2026-04-17.md
    with open(os.path.join(vida_doc_dir, "MATRIZ-PROCESOS-POLITICAS-2026-04-17.md"), 'r', encoding='utf-8') as src:
        text = src.read().replace("# ", "### ")
        f.write(text)

# 05-Informe_Procesos_ETL_ELT_2026-06.md
path_05 = os.path.join(base_out_dir, r"05-Mayo-Junio\Entregables\2026-06\05-Informe_Procesos_ETL_ELT_2026-06.md")
with open(path_05, 'a', encoding='utf-8') as f:
    f.write("\n\n## Anexo Forense de Cierre: Inventario Técnico de Repositorios e Intercambio ETL\n\n")
    # Append INVENTARIO-TECNICO-REPOSITORIO-2026-04-17.md
    with open(os.path.join(vida_doc_dir, "INVENTARIO-TECNICO-REPOSITORIO-2026-04-17.md"), 'r', encoding='utf-8') as src:
        text = src.read().replace("# ", "### ")
        f.write(text)
    # Append BITACORA-PROYECTO.md
    f.write("\n\n### Bitácora Cronológica de Resoluciones ETL\n\n")
    with open(os.path.join(vida_doc_dir, "BITACORA-PROYECTO.md"), 'r', encoding='utf-8') as src:
        text = src.read().replace("# ", "### ")
        f.write(text)

# Informe Mensual
path_06 = os.path.join(base_out_dir, r"Reportes\2026-06\Informe_Mensual_2026-06.md")
with open(path_06, 'a', encoding='utf-8') as f:
    f.write("\n\n## Anexo Forense de Cierre: Análisis Integral de Procesos de Negocio Institucionales\n\n")
    # Append ANALISIS-PROCESOS-POLITICAS.md
    with open(os.path.join(vida_doc_dir, "ANALISIS-PROCESOS-POLITICAS.md"), 'r', encoding='utf-8') as src:
        text = src.read().replace("# ", "### ")
        f.write(text)

print("Expansión masiva completada.")
