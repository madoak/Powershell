# Set RDP Certificate
$a = Get-ComputerInfo | select CsDNSHostName, CsDomain
$fqdn = "$($a.CsDNSHostName).$($a.CsDomain)"
$sub = "$($a.CsDNSHostName).$($a.CsDNSHostName),$($a.CsDNSHostName)"
$subjectName = "CN=$fqdn"

# Open Remote Desktop certificate store (Remote Desktop\Certificates)
$certStorePath = "Cert:\LocalMachine\Remote Desktop\Certificates"
$certStore = New-Object System.Security.Cryptography.X509Certificates.X509Store($certStorePath, "LocalMachine")
$certStore.Open("ReadWrite")  # Open in ReadWrite to allow removal of certificates

# Check if a certificate already exists
$cert = $certStore.Certificates | Where-Object { $_.Subject -like "*$fqdn*" } | Select-Object -First 1

if ($cert) {
    Write-Output "Found an existing certificate with subject name: $subjectName"

    # Check if the certificate is self-signed
    if ($cert.Issuer -eq $cert.Subject) {
        Write-Output "The certificate is self-signed and will be replaced."

        # Remove the self-signed certificate
        $certStore.Remove($cert)
        Write-Output "Self-signed certificate removed."

        # Request a new certificate from the PKI
        $newCert = Get-Certificate -Template RDPTemplate -SubjectName $subjectName -DnsName $sub -CertStoreLocation $certStorePath
        $thumbprint = $newCert.Thumbprint
        Write-Output "New certificate requested and installed with thumbprint: $thumbprint"
    } else {
        Write-Output "The certificate is not self-signed. It will be used for RDP."
        $thumbprint = $cert.Thumbprint
    }
} else {
    Write-Output "No certificate found, requesting a new one using template RDPTemplate"
    $newCert = Get-Certificate -Template RDPTemplate -SubjectName $subjectName -DnsName $sub -CertStoreLocation $certStorePath
    $thumbprint = $newCert.Thumbprint
}

# Close the certificate store
$certStore.Close()

# Set the RDP to use the found or newly created certificate
$rdpCertKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
Set-ItemProperty -Path $rdpCertKeyPath -Name "SSLCertificateSHA1Hash" -Value $thumbprint

Write-Output "RDP is now configured to use the certificate with thumbprint: $thumbprint"
