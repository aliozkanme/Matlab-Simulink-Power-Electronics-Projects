import os
import re

# Ayarlar
ROOT_DIR = "."
MAIN_README = "README.md"
START_MARKER = ""
END_MARKER = ""

def get_project_title(readme_path):
    """Proje README'sinin ilk başlığını (H1) çeker."""
    if not os.path.exists(readme_path):
        return None
    with open(readme_path, 'r', encoding='utf-8') as f:
        for line in f:
            if line.strip().startswith('# '):
                return line.strip()[2:].strip() # '# ' kısmını temizle
    return None

def generate_project_list():
    projects = []
    
    # Klasörleri tara
    for item in os.listdir(ROOT_DIR):
        item_path = os.path.join(ROOT_DIR, item)
        
        # Sadece klasörleri ve gizli olmayanları al (.git vs hariç)
        if os.path.isdir(item_path) and not item.startswith('.'):
            readme_path = os.path.join(item_path, "README.md")
            
            # Eğer klasörde README varsa proje olarak kabul et
            if os.path.exists(readme_path):
                title = get_project_title(readme_path)
                if title:
                    # Link formatı: - [Proje Adı](./KlasörAdi)
                    link = f"- [{title}](./{item})"
                    projects.append(link)
    
    # Alfabetik sırala
    projects.sort()
    return "\n".join(projects)

def update_main_readme(content_list):
    with open(MAIN_README, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Markerlar arasını bul ve değiştir
    pattern = re.compile(f"{re.escape(START_MARKER)}.*?{re.escape(END_MARKER)}", re.DOTALL)
    new_content = f"{START_MARKER}\n{content_list}\n{END_MARKER}"
    
    updated_content = pattern.sub(new_content, content)
    
    with open(MAIN_README, 'w', encoding='utf-8') as f:
        f.write(updated_content)

if __name__ == "__main__":
    print("Projeler taranıyor...")
    project_list = generate_project_list()
    print(f"Bulunan projeler:\n{project_list}")
    
    if project_list:
        update_main_readme(project_list)
        print("README.md güncellendi.")
    else:
        print("Hiçbir proje klasörü bulunamadı.")