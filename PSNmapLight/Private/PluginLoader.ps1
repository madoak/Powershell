function Import-NmapPlugins {

    $pluginPath = Join-Path $PSScriptRoot "..\Plugins"

    if (-not (Test-Path $pluginPath)) {
        return @()
    }

    $plugins = @()

    foreach ($file in Get-ChildItem $pluginPath -Filter *.ps1) {
        . $file.FullName
        $plugins += $file.BaseName
    }

    # Return actual callable plugin functions (IMPORTANT FIX)
    return @(
        Get-Command Test-HTTPBanner -ErrorAction SilentlyContinue
        Get-Command Test-SSHBanner  -ErrorAction SilentlyContinue
        Get-Command Test-TLSBanner  -ErrorAction SilentlyContinue
        Get-Command Test-RDPBanner  -ErrorAction SilentlyContinue
        Get-Command Test-SMBBanner  -ErrorAction SilentlyContinue
    ) | Where-Object { $_ }
}