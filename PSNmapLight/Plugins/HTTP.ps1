function Test-HTTPBanner {
    param($Host,$Port)

    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $tcp.Connect($Host,$Port)

        $stream = $tcp.GetStream()
        $stream.ReadTimeout = 300

        $req = "HEAD / HTTP/1.1`r`nHost: $Host`r`nConnection: close`r`n`r`n"
        $bytes = [Text.Encoding]::ASCII.GetBytes($req)

        $stream.Write($bytes,0,$bytes.Length)

        $buffer = New-Object byte[] 1024
        $read = $stream.Read($buffer,0,1024)

        if ($read -gt 0) {

            $resp = [Text.Encoding]::ASCII.GetString($buffer,0,$read)

            # STRICT HTTP validation
            if ($resp -match "^HTTP/1\.[01]") {

                $server = if ($resp -match "Server:\s*(.+)") { $matches[1] } else { "Unknown" }

                return [PSCustomObject]@{
                    Service = "HTTP"
                    Detail  = $server
                }
            }
        }
    }
    catch {}

    return $null
}