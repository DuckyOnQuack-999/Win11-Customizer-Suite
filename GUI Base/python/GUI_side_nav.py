import tkinter as tk
from tkinter import scrolledtext
import subprocess
from unittest.mock import patch

class PowerShellGUITest:
    def __init__(self, root):
        self.root = root
        self.root.title("PowerShell GUI Executor Test")
        self.root.geometry("800x600")

        # Create a frame for the side navigation
        self.side_nav = tk.Frame(self.root, bg="lightgray", width=150)
        self.side_nav.pack(side="left", fill="y")

        # Create the buttons for the side navigation (10 menus)
        self.create_menu_buttons()

        # Main frame for the input and output sections
        self.main_frame = tk.Frame(self.root, bg="white")
        self.main_frame.pack(side="left", fill="both", expand=True)

        # PowerShell input area (ScrolledText widget for multi-line input)
        self.ps_input = scrolledtext.ScrolledText(self.main_frame, height=15)
        self.ps_input.pack(padx=10, pady=10, fill="x")

        # Execute button
        self.execute_button = tk.Button(self.main_frame, text="Execute PowerShell", command=self.execute_powershell)
        self.execute_button.pack(pady=10)

        # Status/Debug box (ScrolledText widget for output)
        self.status_box = scrolledtext.ScrolledText(self.main_frame, height=10, bg="black", fg="white")
        self.status_box.pack(padx=10, pady=10, fill="x")

    def create_menu_buttons(self):
        # Create 10 buttons for different PowerShell scripts
        for i in range(1, 11):
            btn = tk.Button(self.side_nav, text=f"Menu {i}", command=lambda i=i: self.load_preset_script(i), height=2)
            btn.pack(fill="x", padx=5, pady=5)

    def load_preset_script(self, menu_number):
        # This function loads a preset PowerShell script into the input box
        preset_scripts = {
            1: 'Get-Process',
            2: 'Get-Service',
            3: 'Get-EventLog -LogName System -Newest 10',
            4: 'Get-ChildItem',
            5: 'Get-WmiObject Win32_BIOS',
            6: 'Get-WmiObject Win32_OperatingSystem',
            7: 'Get-Help',
            8: 'Test-Connection google.com',
            9: 'Get-NetIPAddress',
            10: 'Get-Disk'
        }
        script = preset_scripts.get(menu_number, "")
        self.ps_input.delete(1.0, tk.END)
        self.ps_input.insert(tk.END, script)

    def execute_powershell(self):
        self.status_box.delete(1.0, tk.END)
        ps_script = self.ps_input.get(1.0, tk.END).strip()

        if not ps_script:
            self.status_box.insert(tk.END, "No PowerShell script entered.")
            return

        try:
            # Mock the subprocess call to simulate a successful execution
            with patch("subprocess.run") as mocked_run:
                mocked_run.return_value.returncode = 0
                mocked_run.return_value.stdout = "Simulated PowerShell Output"
                mocked_run.return_value.stderr = ""

                result = subprocess.run(["powershell", "-Command", ps_script], capture_output=True, text=True)

                # Simulate the output
                if result.returncode == 0:
                    self.status_box.insert(tk.END, result.stdout)
                else:
                    self.status_box.insert(tk.END, result.stderr)

        except Exception as e:
            self.status_box.insert(tk.END, f"Error: {e}")

if __name__ == "__main__":
    root = tk.Tk()
    app = PowerShellGUITest(root)
    root.mainloop()
