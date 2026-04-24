<#
.SYNOPSIS
Updates the Windows hosts file by adding or removing entries.

.DESCRIPTION
This script allows you to add or remove hostname entries in the Windows hosts file.
It prevents duplicate entries and ensures consistent formatting.

.PARAMETER Action
Specifies the action to perform. Valid values are Add or Remove.

.PARAMETER Hostname
The hostname to add or remove.

.PARAMETER IPAddress
The IP address associated with the hostname (required when Action = Add).

.PARAMETER Help
Displays this help message.

.EXAMPLE
.\update_hostfile.ps1 -Action Add -Hostname "example.local" -IPAddress "127.0.0.1"

.EXAMPLE
.\update_hostfile.ps1 -Action Remove -Hostname "example.local"

.EXAMPLE
Get-Help .\update_hostfile.ps1 -Full

.NOTES
This script must be run as Administrator.
#>

param (
    [ValidateSet("Add","Remove")]
    [string]$Action,

    [string]$Hostname,

    [string]$IPAddress,

    [switch]$Help
)

# Show help if requested
if ($Help) {
    Get-Help $MyInvocation.MyCommand.Path -Full
    exit
}

# Hosts file path
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"

# Ensure script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    
    Write-Host "Please run this script as Administrator." -ForegroundColor Red
    exit
}

function Add-HostEntry {
    param (
        [string]$Hostname,
        [string]$IPAddress
    )

    $entry = "$IPAddress`t$Hostname"

    $hostsContent = Get-Content $hostsPath -ErrorAction Stop

    if ($hostsContent -match "^\s*$IPAddress\s+$Hostname") {
        Write-Host "Entry already exists: $entry" -ForegroundColor Yellow
        return
    }

    # Remove existing entries for the hostname
    $updatedContent = $hostsContent | Where-Object {
        $_ -notmatch "\s+$Hostname$"
    }

    $updatedContent += $entry

    Set-Content -Path $hostsPath -Value $updatedContent -Force

    Write-Host "Added: $entry" -ForegroundColor Green
}

function Remove-HostEntry {
    param (
        [string]$Hostname
    )

    $hostsContent = Get-Content $hostsPath -ErrorAction Stop

    $updatedContent = $hostsContent | Where-Object {
        $_ -notmatch "\s+$Hostname$"
    }

    if ($hostsContent.Count -eq $updatedContent.Count) {
        Write-Host "No entry found for: $Hostname" -ForegroundColor Yellow
        return
    }

    Set-Content -Path $hostsPath -Value $updatedContent -Force

    Write-Host "Removed entry for: $Hostname" -ForegroundColor Green
}

# Execute action
switch ($Action) {
    "Add" {
        if (-not $Hostname -or -not $IPAddress) {
            Write-Host "Hostname and IPAddress are required for Add." -ForegroundColor Red
            exit
        }
        Add-HostEntry -Hostname $Hostname -IPAddress $IPAddress
    }
    "Remove" {
        if (-not $Hostname) {
            Write-Host "Hostname is required for Remove." -ForegroundColor Red
            exit
        }
        Remove-HostEntry -Hostname $Hostname
    }
    default {
        Write-Host "Invalid or missing Action. Use -Help for usage." -ForegroundColor Red
    }
}
