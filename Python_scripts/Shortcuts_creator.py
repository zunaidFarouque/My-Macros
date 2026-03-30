import os
import sys
import subprocess
from pathlib import Path

def find_python_executable():
    """Find the Python executable to use."""
    # Try pythonw.exe first (windowless Python)
    pythonw = sys.executable.replace('python.exe', 'pythonw.exe')
    if os.path.exists(pythonw):
        return pythonw
    # Fallback to regular python.exe
    return sys.executable

def create_vbs_launcher(python_file_path, output_folder):
    """Create a VBScript file that runs the Python script silently."""
    python_exe = find_python_executable()
    python_file_abs = os.path.abspath(python_file_path)
    
    # Get the base name without extension for the launcher
    base_name = os.path.splitext(os.path.basename(python_file_path))[0]
    vbs_path = os.path.join(output_folder, f"{base_name}.vbs")
    
    # VBScript content that runs Python silently (window style 0 = hidden)
    # Use Chr(34) for quotes to avoid escaping issues, or use double-double quotes
    # Format: "python_exe" "python_file"
    vbs_content = f'''Set WshShell = CreateObject("WScript.Shell")
WshShell.Run Chr(34) & "{python_exe.replace('"', '""')}" & Chr(34) & " " & Chr(34) & "{python_file_abs.replace('"', '""')}" & Chr(34), 0, False
Set WshShell = Nothing
'''
    
    with open(vbs_path, 'w', encoding='utf-8') as f:
        f.write(vbs_content)
    
    return vbs_path

def create_pyw_wrapper(python_file_path, output_folder):
    """Create a .pyw wrapper file that runs the original script silently."""
    python_file_abs = os.path.abspath(python_file_path)
    base_name = os.path.splitext(os.path.basename(python_file_path))[0]
    pyw_path = os.path.join(output_folder, f"{base_name}.pyw")
    
    # .pyw wrapper that redirects stdout/stderr to suppress output
    pyw_content = f'''import sys
import os

# Redirect stdout and stderr to suppress output
sys.stdout = open(os.devnull, 'w')
sys.stderr = open(os.devnull, 'w')

# Execute the original script
exec(open(r"""{python_file_abs}""").read())
'''
    
    with open(pyw_path, 'w', encoding='utf-8') as f:
        f.write(pyw_content)
    
    return pyw_path

def main():
    # Get the script's directory
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Path to the Clipboard Manipulation folder
    clipboard_folder = os.path.join(script_dir, "Clipboard Manipulation")
    
    if not os.path.exists(clipboard_folder):
        print(f"Error: Folder not found: {clipboard_folder}")
        return
    
    # Create a "Shortcuts" folder for the launchers
    shortcuts_folder = os.path.join(script_dir, "Shortcuts")
    os.makedirs(shortcuts_folder, exist_ok=True)
    
    # Scan for Python files
    python_files = []
    for file in os.listdir(clipboard_folder):
        if file.endswith('.py') and file != '__init__.py':
            python_files.append(os.path.join(clipboard_folder, file))
    
    if not python_files:
        print(f"No Python files found in {clipboard_folder}")
        return
    
    print(f"Found {len(python_files)} Python file(s):")
    
    created_files = []
    for py_file in python_files:
        file_name = os.path.basename(py_file)
        print(f"  - {file_name}")
        
        # Create both VBS and PYW launchers
        vbs_path = create_vbs_launcher(py_file, shortcuts_folder)
        pyw_path = create_pyw_wrapper(py_file, shortcuts_folder)
        
        created_files.append((vbs_path, pyw_path))
        print(f"    Created: {os.path.basename(vbs_path)} and {os.path.basename(pyw_path)}")
    
    print(f"\nAll launchers created in: {shortcuts_folder}")
    print("\nYou can double-click either:")
    print("  - .vbs files (recommended for double-click execution)")
    print("  - .pyw files (alternative, requires Python association)")

if __name__ == "__main__":
    main()
