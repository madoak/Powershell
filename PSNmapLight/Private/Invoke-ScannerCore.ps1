function Invoke-ScannerCore {

    param (
        [string]$Host,
        [int]$Port,
        [int]$Timeout,
        [int]$Delay,
        [string]$ScanId,
        [string]$Profile,
        [object[]]$Plugins
    )

    Start-Sleep -Milliseconds $Delay

    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $iar = $tcp.BeginConnect($Host, $Port, $null, $null)

        if ($iar.AsyncWaitHandle.WaitOne($Timeout, $false)) {
            $tcp.EndConnect($iar)

            # ---------------- PLUGIN EXECUTION ----------------
            $service = $null

            foreach ($p in $Plugins) {
                try {
                    $result = & $p $Host $Port
                    if ($result) {
                        $service = $result
                        break
                    }
                }
                catch {}
            }

            if (-not $service) {
                $service = [PSCustomObject]@{
                    Service = "OPEN"
                    Detail  = "Unknown"
                }
            }

            return [PSCustomObject]@{
                ScanId  = $ScanId
                Profile = $Profile
                Host    = $Host
                Port    = $Port
                State   = "Open"
                Service = $service.Service
                Detail  = $service.Detail
                Time    = Get-Date
            }
        }

        $tcp.Close()
    }
    catch {}

    return $null
}