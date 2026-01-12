import os
import re

def update_readme():
    root_dir = "."
    main_readme = "README.md"
    start_marker = ""
    end_marker = ""

    # 1. Projeleri Tara / Scan Projects
    projects = []
    for item in sorted(os.listdir(root_dir)):
        if os.path.isdir(item) and not item.startswith('.'): # Gizli klasörleri atla
            readme_path = os.path.join(item, "README.md")
            if os.path.exists(readme_path):
                title = item
                try:
                    with open(readme_path, 'r', encoding='utf-8') as f:
                        for line in f:
                            if line.strip().startswith('# '):
                                title = line.strip()[2:].strip()
                                break
                except: pass
                projects.append(f"- [{title}](./{item})")

    # 2. Listeyi Hazırla / Prepare List
    new_content = f"{start_marker}\n" + "\n".join(projects) + f"\n{end_marker}"

    # 3. Ana Dosyayı Güncelle / Update Main README
    if os.path.exists(main_readme):
        with open(main_readme, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Regex ile değiştir (Markerlar yoksa dosya sonuna ekle)
        pattern = re.compile(f"{re.escape(start_marker)}.*?{re.escape(end_marker)}", re.DOTALL)
        
        if pattern.search(content):
            updated_content = pattern.sub(new_content, content)
        else:
            updated_content = content + f"\n\n## 📂 Projects\n{new_content}"

        if updated_content != content:
            with open(main_readme, 'w', encoding='utf-8') as f:
                f.write(updated_content)
            print("README updated successfully.")
        else:
            print("No changes detected.")

if __name__ == "__main__":
    update_readme()
