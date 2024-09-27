
# ˗ˏˋ ★ Win11 Customizer Suite ★ ˎˊ˗

<p align="center">
  <img src="https://img.shields.io/github/downloads/DuckyOnQuack-999/Win11-Customizer-Suite/total?color=%230079d5" alt="GitHub Downloads" />
  <img src="https://img.shields.io/badge/version-1.0-blue?style=flat-square" alt="Version 1.0" />
  <img src="https://img.shields.io/badge/Windows%2011-%230079d5.svg?style=flat-square&logo=windows11&logoColor=white" alt="Windows 11" />
  <img src="https://img.shields.io/badge/Python-%233776AB.svg?style=flat-square&logo=python&logoColor=white" alt="Python" />
  <img src="https://img.shields.io/badge/PowerShell-%235391FE.svg?style=flat-square&logo=powershell&logoColor=white" alt="PowerShell" />
  <img src="https://img.shields.io/badge/Shell%20Scripts-%23121011.svg?style=flat-square&logo=gnubash&logoColor=white" alt="Shell Scripts" />
</p>

> **Win11 Customizer Suite** is the ultimate toolkit for tweaking, personalizing, and boosting the performance of your Windows 11 experience.

---

## 🗂️ Project Structure

Here's a detailed breakdown of the folders, including descriptions of the purpose of each script or tool:

<details>
<summary>💼 <strong>Fixers</strong> - Troubleshooting Scripts</summary>

```bash
📂 Fixers/
    ├── 🛠️ Clear&Rebuild-BCD&EFI.bat
    ├── 🖱️ FixReverseMouseScroll.ps1
    ├── 👥 LocalUsers&Groups-Reset.ps1
    ├── 🔧 Repair-Windows.ps1
    └── 🗂️ WinRepairKitPro.ps1
```

### Descriptions:
- **Clear&Rebuild-BCD&EFI.bat:** Clears and rebuilds the Boot Configuration Data (BCD) and EFI boot records to fix boot-related issues.
- **FixReverseMouseScroll.ps1:** Corrects the reverse scrolling direction for touchpad and mouse devices on Windows 11.
- **LocalUsers&Groups-Reset.ps1:** Resets local users and groups settings to their default state, useful after misconfigurations.
- **Repair-Windows.ps1:** Repairs common Windows issues such as file corruption and registry errors.
- **WinRepairKitPro.ps1:** A comprehensive repair kit script that fixes various system issues, including registry and DLL-related problems.
</details>

<details>
<summary>🔄 <strong>Updaters</strong> - Scripts for .NET and PowerShell Modules</summary>

```bash
📂 Updaters/
    ├── 🌐 .net_aio_tool_v1.ps1
    ├── ⬇️ DownloadDotNet.ps1
    ├── 💻 Allow_Scripts.cmd
    └── ⚙️ dotnet-install.ps1
```

### Descriptions:
- **.net_aio_tool_v1.ps1:** Installs and manages multiple versions of .NET Framework to ensure compatibility with various applications.
- **DownloadDotNet.ps1:** Downloads the latest version of the .NET runtime and framework, ensuring your system stays up to date.
- **Allow_Scripts.cmd:** Temporarily enables script execution policy to allow PowerShell scripts to run without restrictions.
- **dotnet-install.ps1:** Automates the installation of the .NET SDK, runtime, and other essential components.
</details>

<details>
<summary>📦 <strong>Modules</strong> - PowerShell Modules</summary>

```bash
📂 Modules/
    ├── 📌 PSReadline/
    ├── 📌 PSFzf/
    ├── 📌 PowerShellGet/
    ├── 🛠️ PowerShellProTools/
    └── 🎨 Terminal-Icons/
```

### Descriptions:
- **PSReadline:** Enhances the command-line editing experience in PowerShell by adding syntax highlighting and history.
- **PSFzf:** Integrates the FZF fuzzy finder into PowerShell for easier command and file searches.
- **PowerShellGet:** Manages PowerShell modules and scripts, allowing easy installation and updates of PowerShell modules.
- **PowerShellProTools:** Provides professional-level tools to extend PowerShell's functionality, including script packaging and GUI creation.
- **Terminal-Icons:** Adds icons to the PowerShell terminal to make directories and files more visually identifiable.
</details>

<details>
<summary>💡 <strong>Scripts</strong> - Customization and System Scripts</summary>

```bash
📂 Scripts/
    ├── 🛠️ Add-AppDevPackage.ps1
    ├── 🛠️ AddPythonContextMenu.ps1
    ├── 🔒 CertificateInstaller.ps1
    ├── 🛡️ FixWindowsCheckForErrors.ps1
    ├── 🔄 ResetSearchPolicies.ps1
    ├── 🎨 Reset Scaling Factor Size.ps1
    ├── 🛠️ Service-Context-Menu.ps1
    ├── ⚙️ Set-ExecutionPolicy.ps1
    ├── 📊 DiagnosticReset.ps1
    └── 🗂️ WinKit_v1.ps1

```

### Descriptions:

- **Add-AppDevPackage.ps1:** Adds Windows Developer Mode app packages necessary for deploying and testing UWP apps.
- **AddPythonContextMenu.ps1:** Adds Python-related options to the Windows context menu for easier script execution.
- **CertificateInstaller.ps1:** Simplifies the installation of certificates to the system, streamlining secure app and service deployment.
- **FixWindowsCheckForErrors.ps1:** Fixes Windows Update and system error-checking functionality by repairing corrupted system components.
- **ResetSearchPolicies.ps1:** Resets any search-related group policies to restore the default Windows search behavior.
- **Reset Scaling Factor Size.ps1:** Resets Windows scaling factor to its default size, useful for fixing display scaling issues.
- **Service-Context-Menu.ps1:** Adds useful service management options to the Windows context menu, allowing you to start, stop, or restart services with a right-click.
- **Set-ExecutionPolicy.ps1:** Adjusts PowerShell's execution policy to allow or restrict the running of scripts on the system.
- **DiagnosticReset.ps1:** Resets diagnostic data collection settings to their default state, ensuring privacy or resolving system tracking issues.
- **WinKit_v1.ps1:** A script that serves as the central hub to launch a suite of customization and optimization tools for Windows 11.
</details>

---

## 🚀 Key Features

<p align="center">
  <img src="https://img.shields.io/badge/Theme%20Customization-%230079d5.svg?style=for-the-badge&logo=windows11" alt="Theme Customization" />
  <img src="https://img.shields.io/badge/Performance%20Boost-%2300FF7F.svg?style=for-the-badge&logo=windows" alt="Performance Boost" />
  <img src="https://img.shields.io/badge/System%20Tweaks-%23FFD700.svg?style=for-the-badge&logo=powershell" alt="System Tweaks" />
  <img src="https://img.shields.io/badge/Automated%20Updaters-%23FF4500.svg?style=for-the-badge&logo=windows" alt="Automated Updaters" />
</p>

### 🎨 **Custom Themes**
Tailor your Windows 11 system themes, icons, and visual aesthetics with ease.

### 🚀 **Performance Boosting Tools**
Enhance speed and efficiency with optimization scripts that ensure top-tier performance.

### 🔧 **System Tweaks**
Unlock hidden settings and boost functionality with advanced system tweaks.

### ⚙️ **Automated Updaters**
Keep your system updated with one-click installations for .NET, PowerShell modules, and more.

---

## 🛠️ Installation

<p align="center">
  <img src="https://img.shields.io/badge/Windows%20Terminal-%234D4D4D.svg?style=for-the-badge&logo=windows-terminal&logoColor=white" alt="Windows Terminal" />
  <img src="https://img.shields.io/badge/GitHub%20CLI-%23000000.svg?style=for-the-badge&logo=github" alt="GitHub CLI" />
</p>

To install the **Win11 Customizer Suite**, follow these simple steps:

```git
# Clone the repository 📂
gh repo clone DuckyOnQuack-999/Win11-Customizer-Suite

# Navigate to the project folder 📁
cd Win11-Customizer-Suite

# Run any script 🖱️
./Fixers/FixReverseMouseScroll.ps1
```

---

## 🛠️ Contributing

<p align="center">
  <img src="https://img.shields.io/badge/Contributions-Welcome-brightgreen?style=for-the-badge" alt="Contributions Welcome" />
  <img src="https://img.shields.io/badge/Issues-Welcome-orange?style=for-the-badge" alt="Issues Welcome" />
</p>

We welcome contributions! Whether it's fixing bugs or suggesting features, feel free to check the [contributing guidelines](https://github.com/your-repo-url/contributing.md) for more details.

---

## 🗺️ Roadmap

<p align="center">
  <img src="https://img.shields.io/badge/Roadmap-Q4%202024-lightblue?style=for-the-badge&logo=roadmap" alt="Roadmap" />
</p>

- [x] Initial Release 🟢
- [ ] **New Customization Features** ⚙️ (ETA: Q4 2024)
- [ ] **Expanded Module Support** 📦 (ETA: Q1 2025)
- [ ] **Multi-language Support** 🌐 (ETA: Q2 2025)

---

## ⭐ Show Your Support

<p align="center">
  <img src="https://img.shields.io/badge/Star%20this%20Repo-%23FFD700.svg?style=for-the-badge&logo=github" alt="Star this repo" />
  <img src="https://img.shields.io/badge/Fork%20this%20Repo-%23FF4500.svg?style=for-the-badge&logo=github" alt="Fork this repo" />
</p>
