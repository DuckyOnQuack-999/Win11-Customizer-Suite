Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to create the GUI
function Show-CertificateSignerForm {
    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Certificate Signer"
    $form.Size = New-Object System.Drawing.Size(500,300)
    $form.StartPosition = "CenterScreen"

    # Create CA Certificate section
    $caGroupBox = New-Object System.Windows.Forms.GroupBox
    $caGroupBox.Text = "Generate CA Certificate"
    $caGroupBox.Size = New-Object System.Drawing.Size(460,100)
    $caGroupBox.Location = New-Object System.Drawing.Point(10,10)
    $form.Controls.Add($caGroupBox)

    $caCertNameLabel = New-Object System.Windows.Forms.Label
    $caCertNameLabel.Text = "CA Certificate Name:"
    $caCertNameLabel.Location = New-Object System.Drawing.Point(10,30)
    $caCertNameLabel.Size = New-Object System.Drawing.Size(150,20)
    $caGroupBox.Controls.Add($caCertNameLabel)

    $caCertNameTextBox = New-Object System.Windows.Forms.TextBox
    $caCertNameTextBox.Location = New-Object System.Drawing.Point(160,30)
    $caCertNameTextBox.Size = New-Object System.Drawing.Size(250,20)
    $caCertNameTextBox.Text = "CN=MyRootCA"
    $caGroupBox.Controls.Add($caCertNameTextBox)

    $generateCaButton = New-Object System.Windows.Forms.Button
    $generateCaButton.Text = "Generate CA Certificate"
    $generateCaButton.Location = New-Object System.Drawing.Point(160,60)
    $generateCaButton.Size = New-Object System.Drawing.Size(150,30)
    $caGroupBox.Controls.Add($generateCaButton)

    # Create New Certificate section
    $newCertGroupBox = New-Object System.Windows.Forms.GroupBox
    $newCertGroupBox.Text = "Generate and Sign New Certificate"
    $newCertGroupBox.Size = New-Object System.Drawing.Size(460,130)
    $newCertGroupBox.Location = New-Object System.Drawing.Point(10,120)
    $form.Controls.Add($newCertGroupBox)

    $newCertNameLabel = New-Object System.Windows.Forms.Label
    $newCertNameLabel.Text = "New Certificate Name:"
    $newCertNameLabel.Location = New-Object System.Drawing.Point(10,30)
    $newCertNameLabel.Size = New-Object System.Drawing.Size(150,20)
    $newCertGroupBox.Controls.Add($newCertNameLabel)

    $newCertNameTextBox = New-Object System.Windows.Forms.TextBox
    $newCertNameTextBox.Location = New-Object System.Drawing.Point(160,30)
    $newCertNameTextBox.Size = New-Object System.Drawing.Size(250,20)
    $newCertNameTextBox.Text = "CN=MySignedCert"
    $newCertGroupBox.Controls.Add($newCertNameTextBox)

    $selectCaButton = New-Object System.Windows.Forms.Button
    $selectCaButton.Text = "Select CA Certificate"
    $selectCaButton.Location = New-Object System.Drawing.Point(10,60)
    $selectCaButton.Size = New-Object System.Drawing.Size(150,30)
    $newCertGroupBox.Controls.Add($selectCaButton)

    $signCertButton = New-Object System.Windows.Forms.Button
    $signCertButton.Text = "Generate and Sign Certificate"
    $signCertButton.Location = New-Object System.Drawing.Point(160,60)
    $signCertButton.Size = New-Object System.Drawing.Size(250,30)
    $newCertGroupBox.Controls.Add($signCertButton)

    # Create status label
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Text = ""
    $statusLabel.Location = New-Object System.Drawing.Point(10,260)
    $statusLabel.Size = New-Object System.Drawing.Size(460,20)
    $form.Controls.Add($statusLabel)

    # Handle CA certificate generation
    $generateCaButton.Add_Click({
        $caCertName = $caCertNameTextBox.Text
        if ([string]::IsNullOrWhiteSpace($caCertName)) {
            $statusLabel.Text = "Please enter a CA certificate name."
            return
        }
        
        try {
            $caCertPath = "$env:TEMP\MyRootCA.pfx"
            $caCertPassword = Read-Host -AsSecureString "Enter password for CA certificate"
            New-SelfSignedCertificate -DnsName $caCertName -CertStoreLocation "Cert:\LocalMachine\My" -KeyUsage KeyCertSign, CRLSign -KeyLength 2048 -NotBefore (Get-Date) -NotAfter (Get-Date).AddYears(10)
            Export-PfxCertificate -Cert (Get-ChildItem -Path "Cert:\LocalMachine\My" | Where-Object { $_.Subject -eq "CN=$caCertName" }) -FilePath $caCertPath -Password $caCertPassword
            $statusLabel.Text = "CA Certificate generated and exported to $caCertPath"
        } catch {
            $statusLabel.Text = "Error generating CA certificate: $($_.Exception.Message)"
        }
    })

    # Handle new certificate signing
    $selectCaButton.Add_Click({
        $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $openFileDialog.Filter = "PFX Files (*.pfx)|*.pfx"
        if ($openFileDialog.ShowDialog() -eq "OK") {
            $caCertPath = $openFileDialog.FileName
            $statusLabel.Text = "Selected CA Certificate: $caCertPath"
        }
    })

    $signCertButton.Add_Click({
        $newCertName = $newCertNameTextBox.Text
        $caCertPath = $selectCaButton.Tag

        if ([string]::IsNullOrWhiteSpace($newCertName)) {
            $statusLabel.Text = "Please enter a new certificate name."
            return
        }
        
        if ([string]::IsNullOrWhiteSpace($caCertPath)) {
            $statusLabel.Text = "Please select a CA certificate."
            return
        }

        try {
            $caCertPassword = Read-Host -AsSecureString "Enter password for CA certificate"
            $caCert = Import-PfxCertificate -FilePath $caCertPath -CertStoreLocation "Cert:\LocalMachine\My" -Password $caCertPassword
            $signedCertPath = "$env:TEMP\MySignedCert.pfx"
            $signedCertPassword = Read-Host -AsSecureString "Enter password for signed certificate"
            
            $signingCert = New-SelfSignedCertificate -DnsName $newCertName -CertStoreLocation "Cert:\LocalMachine\My" -KeyUsage DigitalSignature, KeyEncipherment -KeyLength 2048 -NotBefore (Get-Date) -NotAfter (Get-Date).AddYears(1) -Signer $caCert
            Export-PfxCertificate -Cert $signingCert -FilePath $signedCertPath -Password $signedCertPassword

            $statusLabel.Text = "Certificate signed and exported to $signedCertPath"
        } catch {
            $statusLabel.Text = "Error signing certificate: $($_.Exception.Message)"
        }
    })

    # Show the form
    $form.ShowDialog()
}

# Run the GUI
Show-CertificateSignerForm
