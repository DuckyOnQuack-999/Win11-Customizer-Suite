Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to create the GUI
function Show-InstallCertificateForm {
    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Install Certificate"
    $form.Size = New-Object System.Drawing.Size(400,200)
    $form.StartPosition = "CenterScreen"

    # Create the browse button
    $browseButton = New-Object System.Windows.Forms.Button
    $browseButton.Text = "Browse"
    $browseButton.Location = New-Object System.Drawing.Point(10,10)
    $browseButton.Size = New-Object System.Drawing.Size(80,25)
    $form.Controls.Add($browseButton)

    # Create the text box to display the file path
    $filePathTextBox = New-Object System.Windows.Forms.TextBox
    $filePathTextBox.Location = New-Object System.Drawing.Point(100,10)
    $filePathTextBox.Size = New-Object System.Drawing.Size(260,25)
    $filePathTextBox.ReadOnly = $true
    $form.Controls.Add($filePathTextBox)

    # Create the install button
    $installButton = New-Object System.Windows.Forms.Button
    $installButton.Text = "Install"
    $installButton.Location = New-Object System.Drawing.Point(10,50)
    $installButton.Size = New-Object System.Drawing.Size(80,25)
    $form.Controls.Add($installButton)

    # Create a label for status messages
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Text = ""
    $statusLabel.Location = New-Object System.Drawing.Point(10,90)
    $statusLabel.Size = New-Object System.Drawing.Size(350,25)
    $form.Controls.Add($statusLabel)

    # Handle the browse button click
    $browseButton.Add_Click({
        $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $openFileDialog.Filter = "Certificate Files (*.cer, *.pfx)|*.cer;*.pfx"
        if ($openFileDialog.ShowDialog() -eq "OK") {
            $filePathTextBox.Text = $openFileDialog.FileName
        }
    })

    # Handle the install button click
    $installButton.Add_Click({
        $certPath = $filePathTextBox.Text
        if ([string]::IsNullOrWhiteSpace($certPath)) {
            $statusLabel.Text = "Please select a certificate file."
            return
        }

        try {
            # Install the certificate
            if ($certPath.EndsWith(".pfx")) {
                $certPass = Read-Host -AsSecureString "Enter PFX Password"
                Import-PfxCertificate -FilePath $certPath -CertStoreLocation Cert:\LocalMachine\My -Password $certPass
            } else {
                Import-Certificate -FilePath $certPath -CertStoreLocation Cert:\LocalMachine\My
            }
            $statusLabel.Text = "Certificate installed successfully."
        } catch {
            $statusLabel.Text = "Error: $($_.Exception.Message)"
        }
    })

    # Show the form
    $form.ShowDialog()
}

# Run the GUI
Show-InstallCertificateForm

