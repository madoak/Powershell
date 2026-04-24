function Test-SSHBanner {
    param($Host,$Port)

    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $tcp.Connect($Host,$Port)

        $stream = $tcp.GetStream()
        $stream.ReadTimeout = 300

        Start-Sleep -Milliseconds 150

        $buffer = New-Object byte[] 512
        $read = $stream.Read($buffer,0,512)

        if ($read -gt 0) {
            $banner = [Text.Encoding]::ASCII.GetString($buffer,0,$read)

            # STRICT MATCH (this is key)
            if ($banner -match "^SSH-\d\.\d") {
                return [PSCustomObject]@{
                    Service = "SSH"
                    Detail  = $banner.Trim()
                }
            }
        }
    }
    catch {}

    return $null
}