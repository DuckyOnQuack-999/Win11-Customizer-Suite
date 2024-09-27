# Update-LoadingScreen.ps1
param (
    [string]$StatusText
)

Add-Type -AssemblyName System.Windows.Forms

$form = [System.Windows.Forms.Application]::OpenForms | Where-Object { $_.Text -eq 'Loading...' }
if ($form) {
    $label = $form.Controls.Find('label', $true)[0]
    if ($label) {
        $label.Text = $StatusText
    }
}
