function Test-SMBBanner {
    param($Host,$Port)

    if ($Port -eq 445) {
        return @{ Service="SMB"; Detail="Detected" }
    }

    return $null
}