function Invoke-NmapLight {

    [CmdletBinding()]
    param (
        [string]$Target,

        [ValidateSet("Fast","Balanced","Stealth","Audit")]
        [string]$Profile = "Balanced",

        [string]$ExportPath,

        [ValidateSet("JSON","CSV")]
        [string]$Format,

        [switch]$Help
    )

    # ---------------- HELP ----------------
    if ($Help -or -not $Target) {
        Microsoft.PowerShell.Utility\Write-Host @"
PSNmapLight - Clean Lightweight Scanner

USAGE:
  Invoke-NmapLight -Target <host|subnet> -Profile <Fast|Balanced|Stealth|Audit>

EXAMPLES:
  Invoke-NmapLight -Target 10.0.0.5 -Profile Fast
  Invoke-NmapLight -Target 10.0.0.0/24 -Profile Balanced

PROFILES:
  Fast     = minimal ports
  Balanced = default enterprise scan
  Stealth  = slow, low-noise scan
  Audit    = deep scan (1–1024)
"@
        return
    }

    # ---------------- INIT ----------------
    $ScanId = [guid]::NewGuid().ToString()
    $results = New-Object System.Collections.Generic.List[object]

    . "$PSScriptRoot\..\Private\PluginLoader.ps1"
    $Plugins = Import-NmapPlugins

    # ---------------- PROFILE CONFIG ----------------
    $config = switch ($Profile) {
        "Fast"     { @{ Ports=@(22,80,443); Delay=0;  Timeout=150 } }
        "Balanced" { @{ Ports=@(22,80,443,445,3389); Delay=5;  Timeout=200 } }
        "Stealth"  { @{ Ports=@(22,80,443); Delay=50; Timeout=300 } }
        "Audit"    { @{ Ports=1..1024; Delay=10; Timeout=250 } }
    }

    # ---------------- TARGET EXPANSION ----------------
    function Expand-Target {
        param($t)

        if ($t -match "/24") {
            $base = ($t.Split("/")[0].Split(".")[0..2]) -join "."
            return 1..254 | ForEach-Object { "$base.$_" }
        }

        if ($t -match "/16") {
            $base = ($t.Split("/")[0].Split(".")[0..1]) -join "."
            return for ($i=0; $i -le 255; $i++) {
                for ($j=1; $j -le 254; $j++) {
                    "$base.$i.$j"
                }
            }
        }

        return @($t)
    }

    $targets = Expand-Target $Target

    $total = $targets.Count * $config.Ports.Count
    $i = 0

    # ---------------- SCANNING CORE ----------------
    foreach ($host in $targets) {

        foreach ($port in $config.Ports) {

            $i++

            Microsoft.PowerShell.Utility\Write-Progress `
                -Activity "PSNmapLight" `
                -Status "$host : $port" `
                -PercentComplete (($i / $total) * 100)

            Start-Sleep -Milliseconds $config.Delay

            try {
                $tcp = New-Object System.Net.Sockets.TcpClient
                $iar = $tcp.BeginConnect($host, $port, $null, $null)

                if ($iar.AsyncWaitHandle.WaitOne($config.Timeout, $false)) {

                    $tcp.EndConnect($iar)

                    # ---------------- PLUGIN MATCHING ----------------
                    $matches = @()

                    foreach ($plugin in $Plugins) {
                        try {
                            $r = & $plugin $host $port
                            if ($r) {
                                $matches += $r
                            }
                        }
                        catch {}
                    }

                    # ---------------- SERVICE SELECTION ----------------
                    $service = if ($matches.Count -gt 0) {
                        $matches | Select-Object -First 1
                    } else {
                        [PSCustomObject]@{
                            Service = "OPEN"
                            Detail  = "Unknown"
                        }
                    }

                    $result = [PSCustomObject]@{
                        ScanId  = $ScanId
                        Profile = $Profile
                        Host    = $host
                        Port    = $port
                        State   = "Open"
                        Service = $service.Service
                        Detail  = $service.Detail
                        Time    = Get-Date
                    }

                    $results.Add($result)

                    Microsoft.PowerShell.Utility\Write-Host (
                        "OPEN {0}:{1} [{2}] {3}" -f `
                        $host, $port, $service.Service, $service.Detail
                    ) -ForegroundColor Green
                }

                $tcp.Close()
            }
            catch {
                # silently ignore closed ports
            }
        }
    }

    # ---------------- EXPORT ----------------
    if ($ExportPath) {
        if ($Format -eq "JSON") {
            $results | ConvertTo-Json -Depth 3 | Out-File $ExportPath -Encoding UTF8
        }
        else {
            $results | Export-Csv $ExportPath -NoTypeInformation
        }
    }

    return $results
}