function Test-RDPBanner {
    param($Host,$Port)

    if ($Port -eq 3389) {
        return @{ Service="RDP"; Detail="Detected" }
    }

    return $null
}