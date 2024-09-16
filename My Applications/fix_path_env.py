import os
import sys
import ctypes
from pathlib import Path

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def scan_and_fix_path_env():
    path_env = os.environ.get('PATH', '')
    paths = path_env.split(os.pathsep)
    fixed_paths = []
    seen_paths = set()

    print("Scanning and fixing PATH environment variable...\n")
    
    for path in paths:
        path = path.strip()
        
        if not Path(path).exists():
            print(f"Warning: Non-existent path found: {path}")
            continue
        
        if path in seen_paths:
            print(f"Duplicate path removed: {path}")
            continue
        
        fixed_paths.append(path)
        seen_paths.add(path)
    
    fixed_path_env = os.pathsep.join(fixed_paths)
    print("\nFixed PATH:\n", fixed_path_env)
    
    os.environ['PATH'] = fixed_path_env
    
    return fixed_path_env

if __name__ == "__main__":
    if is_admin():
        fixed_path = scan_and_fix_path_env()
        print("\nPATH environment variable has been fixed.")
        
        # Optionally, persist the changes by editing system environment variables (requires admin):
        # import winreg
        # key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SYSTEM\CurrentControlSet\Control\Session Manager\Environment", 0, winreg.KEY_ALL_ACCESS)
        # winreg.SetValueEx(key, "PATH", 0, winreg.REG_EXPAND_SZ, fixed_path)
        # winreg.CloseKey(key)
        
    else:
        print("Script is not running as administrator. Attempting to restart with admin privileges...")
       
