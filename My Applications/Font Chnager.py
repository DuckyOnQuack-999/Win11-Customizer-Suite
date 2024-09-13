import tkinter as tk
from tkinter import ttk, font, messagebox
import ctypes
from ctypes import wintypes
import winreg
import sys
import subprocess

def run_as_admin():
    """Relaunch the script with administrative rights."""
    if sys.platform != "win32":
        raise RuntimeError("This function is only available on Windows")

    if not ctypes.windll.shell32.IsUserAnAdmin():
        # Run the script as admin
        script = sys.argv[0]
        params = " ".join(sys.argv[1:])
        subprocess.run(["powershell", "-Command", f"Start-Process python -ArgumentList '{script} {params}' -Verb runAs"], check=True)
        sys.exit(0)

class LOGFONT(ctypes.Structure):
    _fields_ = [
        ("lfHeight", wintypes.INT),
        ("lfWidth", wintypes.INT),
        ("lfEscapement", wintypes.INT),
        ("lfOrientation", wintypes.INT),
        ("lfWeight", wintypes.INT),
        ("lfItalic", wintypes.BYTE),
        ("lfUnderline", wintypes.BYTE),
        ("lfStrikeOut", wintypes.BYTE),
        ("lfCharSet", wintypes.BYTE),
        ("lfOutPrecision", wintypes.BYTE),
        ("lfClipPrecision", wintypes.BYTE),
        ("lfQuality", wintypes.BYTE),
        ("lfPitchAndFamily", wintypes.BYTE),
        ("lfFaceName", wintypes.WCHAR * 32)
    ]

class NONCLIENTMETRICS(ctypes.Structure):
    _fields_ = [
        ("cbSize", wintypes.UINT),
        ("iBorderWidth", wintypes.INT),
        ("iScrollWidth", wintypes.INT),
        ("iScrollHeight", wintypes.INT),
        ("iCaptionWidth", wintypes.INT),
        ("iCaptionHeight", wintypes.INT),
        ("lfCaptionFont", LOGFONT),
        ("iSmCaptionWidth", wintypes.INT),
        ("iSmCaptionHeight", wintypes.INT),
        ("lfSmCaptionFont", LOGFONT),
        ("iMenuWidth", wintypes.INT),
        ("iMenuHeight", wintypes.INT),
        ("lfMenuFont", LOGFONT),
        ("lfStatusFont", LOGFONT),
        ("lfMessageFont", LOGFONT),
    ]

def get_system_fonts():
    """Retrieve the current system font settings."""
    metrics = NONCLIENTMETRICS()
    metrics.cbSize = ctypes.sizeof(NONCLIENTMETRICS)
    
    try:
        user32 = ctypes.WinDLL('user32')
        result = user32.SystemParametersInfoW(0x002A, metrics.cbSize, ctypes.byref(metrics), 0)
        
        if not result:
            raise RuntimeError("Failed to retrieve system fonts")
        
        return {
            "CaptionFont": metrics.lfCaptionFont.lfFaceName.strip('\x00'),
            "MenuFont": metrics.lfMenuFont.lfFaceName.strip('\x00'),
            "StatusFont": metrics.lfStatusFont.lfFaceName.strip('\x00'),
            "MessageFont": metrics.lfMessageFont.lfFaceName.strip('\x00'),
        }
    
    except Exception as e:
        messagebox.showerror("Error", f"Failed to retrieve system fonts: {e}")
        return {}

def get_registry_fonts():
    """Retrieve the currently applied fonts from the registry."""
    try:
        reg_path = r"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
        reg_key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, reg_path, 0, winreg.KEY_READ)
        
        font_mapping = {
            "Title Bar": "MS Shell Dlg 2",
            "Menu": "MS Shell Dlg 2",
            "Message Box": "MS Shell Dlg 2",
            "Secondary Title": "MS Shell Dlg 2",
            "Icon": "MS Shell Dlg 2",
            "Status Bar": "MS Shell Dlg 2"
        }
        
        applied_fonts = {}
        for component, default_font in font_mapping.items():
            try:
                font_value, _ = winreg.QueryValueEx(reg_key, default_font)
                applied_fonts[component] = font_value.split(' ')[0]  # Extract font name only
            except FileNotFoundError:
                applied_fonts[component] = "Not set"
        
        winreg.CloseKey(reg_key)
        return applied_fonts
    
    except Exception as e:
        messagebox.showerror("Error", f"Failed to retrieve registry fonts: {e}")
        return {component: "Error" for component in font_mapping.keys()}

def apply_font(font_name, font_weight, components):
    """Apply the selected font and weight to the specified UI components."""
    try:
        reg_path = r"SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
        reg_key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, reg_path, 0, winreg.KEY_SET_VALUE)
        
        font_mapping = {
            "Title Bar": "MS Shell Dlg 2",
            "Menu": "MS Shell Dlg 2",
            "Message Box": "MS Shell Dlg 2",
            "Secondary Title": "MS Shell Dlg 2",
            "Icon": "MS Shell Dlg 2",
            "Status Bar": "MS Shell Dlg 2"
        }
        
        for component in components:
            font_key = font_mapping.get(component, "MS Shell Dlg 2")
            winreg.SetValueEx(reg_key, font_key, 0, winreg.REG_SZ, f"{font_name} {font_weight}")
        
        winreg.CloseKey(reg_key)
        
        ctypes.windll.user32.SendMessageW(0xFFFF, 0x001A, 0, 0)  # WM_SETTINGCHANGE
        
        messagebox.showinfo("Success", f"Font changed to '{font_name}' ({font_weight}) for {', '.join(components)}. Restart your computer to see the changes.")
        
    except Exception as e:
        messagebox.showerror("Error", f"Failed to apply font: {e}")

def update_preview(*args):
    """Update the font preview based on user selection."""
    font_name = font_combobox.get()
    font_weight = weight_combobox.get()
    sample_text = "Sample Text"
    
    if font_name:
        weight_styles = {
            "Normal": "normal",
            "Italic": "italic",
            "Bold": "bold"
        }
        preview_font = (font_name, 12, weight_styles.get(font_weight, "normal"))  # Adjust font size
        preview_label.config(text=sample_text, font=preview_font)

def show_current_fonts():
    """Display the currently applied fonts."""
    try:
        fonts = get_registry_fonts()
        current_font_text = "\n".join(f"{key}: {value}" for key, value in fonts.items())
        current_font_textbox.config(state=tk.NORMAL)
        current_font_textbox.delete(1.0, tk.END)  # Clear previous text
        current_font_textbox.insert(tk.END, current_font_text)
        current_font_textbox.config(state=tk.DISABLED)
    except RuntimeError as e:
        current_font_textbox.config(state=tk.NORMAL)
        current_font_textbox.delete(1.0, tk.END)  # Clear previous text
        current_font_textbox.insert(tk.END, f"Error: {e}")
        current_font_textbox.config(state=tk.DISABLED)

# Initialize the GUI
root = tk.Tk()
root.title("Font Changer")

# Configure the window size
root.geometry("800x600")

# Create a frame for the text box and scrollbars
frame = tk.Frame(root)
frame.pack(pady=10, padx=10, fill=tk.BOTH, expand=True)

# Create the text widget with scrollbars
current_font_textbox = tk.Text(frame, height=10, width=50, wrap=tk.WORD, state=tk.DISABLED, font=("Arial", 12))  # Smaller dimensions
current_font_textbox.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)

scroll_y = tk.Scrollbar(frame, orient=tk.VERTICAL, command=current_font_textbox.yview)
scroll_y.pack(side=tk.RIGHT, fill=tk.Y)

scroll_x = tk.Scrollbar(frame, orient=tk.HORIZONTAL, command=current_font_textbox.xview)
scroll_x.pack(side=tk.BOTTOM, fill=tk.X)

current_font_textbox.config(yscrollcommand=scroll_y.set, xscrollcommand=scroll_x.set)

show_current_fonts()

# Font options
fonts = list(font.families())
font_combobox = ttk.Combobox(root, values=fonts, width=40)
font_combobox.pack(pady=10)
font_combobox.set("Select a font")
font_combobox.bind("<<ComboboxSelected>>", update_preview)

# Weight options
weights = ["Normal", "Italic", "Bold"]
weight_combobox = ttk.Combobox(root, values=weights, width=10)
weight_combobox.pack(pady=10)
weight_combobox.set("Normal")
weight_combobox.bind("<<ComboboxSelected>>", update_preview)

# Component selection with multiple selection
component_var = tk.Variable(value=["Title Bar"])  # Default value
components = ["Title Bar", "Menu", "Message Box", "Secondary Title", "Icon", "Status Bar"]

component_frame = tk.Frame(root)
component_frame.pack(pady=10)

for component in components:
    tk.Checkbutton(component_frame, text=component, variable=component_var, onvalue=component, offvalue="").pack(anchor="w")

# Preview Box
preview_label = tk.Label(root, text="Sample Text", font=("Arial", 16))  # Larger font for preview
preview_label.pack(pady=20)

# Apply button
apply_button = tk.Button(root, text="Apply Font", command=lambda: apply_font(font_combobox.get(), weight_combobox.get(), [component for component in components if component in component_var.get()]))
apply_button.pack(pady=10)

# Run as admin and start the GUI
if __name__ == "__main__":
    run_as_admin()
    root.mainloop()
