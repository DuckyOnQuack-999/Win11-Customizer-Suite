import tkinter as tk
from tkinter import scrolledtext

class Application(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("GUI Application")
        self.geometry("800x600")

        # Initialize log messages
        self.log_messages = []

        # Create the menu bar
        self.create_menu_bar()

        # Create the main frames
        self.create_frames()

        # Create the sidebar navigation
        self.create_sidebar()

        # Create the status box
        self.create_status_box()

        # Initially select the first menu
        self.select_menu(0)

    def create_menu_bar(self):
        """Creates the top bar menu, including the debug window option."""
        menu_bar = tk.Menu(self)
        self.config(menu=menu_bar)

        # Add 'View' menu with 'Debug Window' option
        view_menu = tk.Menu(menu_bar, tearoff=0)
        view_menu.add_command(label="Open Debug Window", command=self.open_debug_window)
        menu_bar.add_cascade(label="View", menu=view_menu)

    def create_frames(self):
        """Creates the main frames for the sidebar and content areas."""
        # Main frame divides the window into left and right
        self.main_frame = tk.Frame(self)
        self.main_frame.pack(fill=tk.BOTH, expand=True)

        # Left frame for sidebar
        self.sidebar_frame = tk.Frame(self.main_frame, width=200, bg='lightgrey')
        self.sidebar_frame.pack(side=tk.LEFT, fill=tk.Y)
        self.sidebar_frame.pack_propagate(False)  # Prevent resizing

        # Right frame for content
        self.content_frame = tk.Frame(self.main_frame)
        self.content_frame.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

    def create_sidebar(self):
        """Creates the sidebar with 10 menu buttons for navigation."""
        self.menu_buttons = []
        for i in range(10):
            btn = tk.Button(
                self.sidebar_frame, 
                text=f"Menu {i+1}", 
                command=lambda idx=i: self.select_menu(idx)
            )
            btn.pack(fill=tk.X)
            self.menu_buttons.append(btn)

    def create_status_box(self):
        """Creates the status box at the bottom of the window."""
        self.status_box = tk.Label(
            self, text="Status: Ready", anchor='w', relief=tk.SUNKEN
        )
        self.status_box.pack(side=tk.BOTTOM, fill=tk.X)

    def select_menu(self, index):
        """Handles the display and functionality when a menu is selected."""
        # Log the menu selection
        self.log(f"Menu {index+1} selected.")

        # Update status box
        self.status_box.config(text=f"Status: Menu {index+1} selected.")

        # Clear the content frame
        for widget in self.content_frame.winfo_children():
            widget.destroy()

        # Create the on/off buttons for the selected menu
        self.toggle_vars = []
        for i in range(10):
            var = tk.IntVar()
            cb = tk.Checkbutton(
                self.content_frame, 
                text=f"Option {i+1}", 
                variable=var, 
                command=lambda idx=i, var=var: self.toggle_option(idx, var)
            )
            cb.pack(anchor='w')
            self.toggle_vars.append(var)

    def toggle_option(self, index, var):
        """Handles the state of an option when toggled."""
        state = 'ON' if var.get() else 'OFF'
        message = f"Option {index+1} turned {state}."
        # Log the action
        self.log(message)
        # Update status box
        self.status_box.config(text=f"Status: {message}")

    def open_debug_window(self):
        """Opens or focuses the debug window displaying log messages."""
        if hasattr(self, 'debug_window') and self.debug_window.winfo_exists():
            self.debug_window.focus()
            return

        # Create a new window
        self.debug_window = tk.Toplevel(self)
        self.debug_window.title("Debug Window")
        self.debug_window.geometry("600x400")

        # Create a scrolled text widget for logs
        self.log_text = scrolledtext.ScrolledText(self.debug_window, state='disabled')
        self.log_text.pack(fill=tk.BOTH, expand=True)

        # Insert existing log messages
        self.update_log_window()

    def log(self, message):
        """Logs messages and updates the debug window if open."""
        self.log_messages.append(message)
        # If debug window is open, update it
        if hasattr(self, 'debug_window') and self.debug_window.winfo_exists():
            self.update_log_window()

    def update_log_window(self):
        """Updates the debug window with log messages."""
        self.log_text.config(state='normal')
        self.log_text.delete(1.0, tk.END)
        for msg in self.log_messages:
            self.log_text.insert(tk.END, msg + '\n')
        self.log_text.config(state='disabled')


if __name__ == "__main__":
    app = Application()
    app.mainloop()
