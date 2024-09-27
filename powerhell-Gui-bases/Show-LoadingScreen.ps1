# Show-LoadingScreen.ps1
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create a new form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Loading...'
$form.Size = New-Object System.Drawing.Size(300, 150)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'None'
$form.ControlBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
$form.TransparencyKey = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
$form.ShowInTaskbar = $false

# Create a label for status
$label = New-Object System.Windows.Forms.Label
$label.Text = 'Loading, please wait...'
$label.AutoSize = $true
$label.ForeColor = [System.Drawing.Color]::White
$label.Location = New-Object System.Drawing.Point(50, 60)
$form.Controls.Add($label)

# Update status method
function Update-Status {
    param ([string]$statusText)
    $label.Text = $statusText
}

# Show the form
$form.Show()

# Keep the form open
[System.Windows.Forms.Application]::Run($form)

# Return the form object for further manipulation
return $form
