function Test-TLSBanner {
    param($Host,$Port)

    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $tcp.Connect($Host,$Port)

        $ssl = New-Object System.Net.Security.SslStream($tcp.GetStream(),$false,{$true})
        $ssl.AuthenticateAsClient($Host)

        $cert = $ssl.RemoteCertificate

        if ($cert) {
            return [PSCustomObject]@{
                Service = "TLS"
                Detail  = $cert.Subject
            }
        }
    }
    catch {}

    return $null
}