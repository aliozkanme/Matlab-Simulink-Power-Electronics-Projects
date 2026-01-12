import os

def update_readme_projects():
    # Configuration for file name and markers
    readme_filename = "README.md"
    start_marker = '<div id="list-start"></div>'
    end_marker = '<div id="list-end"></div>'

    # 1. Retrieve and filter subdirectories
    # os.listdir('.') gets all items in the current directory
    # os.path.isdir(item) checks if the item is a folder
    # not item.startswith('.') filters out hidden folders (like .git)
    folders = [
        item for item in os.listdir('.') 
        if os.path.isdir(item) and not item.startswith('.')
    ]
    
    # Sort folders alphabetically for better readability
    folders.sort()

    # 2. Generate the Markdown formatted list
    # Format: - [FolderName](./FolderName)
    md_lines = [f"- [{folder}](./{folder})" for folder in folders]
    new_content_block = "\n".join(md_lines)

    # 3. Read the existing README.md file
    try:
        with open(readme_filename, 'r', encoding='utf-8') as file:
            content = file.read()
    except FileNotFoundError:
        print(f"Error: Target file '{readme_filename}' not found.")
        return

    # 4. Find the positions of the start and end markers
    start_idx = content.find(start_marker)
    end_idx = content.find(end_marker)

    # Validate that both markers exist in the file
    if start_idx != -1 and end_idx != -1:
        # 5. Construct the new file content
        # Slice content up to the end of the start marker
        header_part = content[:start_idx + len(start_marker)]
        
        # Slice content from the beginning of the end marker
        footer_part = content[end_idx:]
        
        # Combine: Header + Newlines + New List + Newlines + Footer
        updated_content = f"{header_part}\n\n{new_content_block}\n\n{footer_part}"

        # 6. Write the updated content back to README.md
        with open(readme_filename, 'w', encoding='utf-8') as file:
            file.write(updated_content)
        
        print(f"Successfully updated {readme_filename} with {len(folders)} projects.")
    else:
        print("Error: HTML markers (div id='list-start'/'list-end') not found in the file.")

if __name__ == "__main__":
    update_readme_projects()
