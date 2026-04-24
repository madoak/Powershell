@{
    RootModule        = 'PSNmapLight.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'a1c9f3d2-8b11-4d44-9c21-psnmaplight-v7'
    Author            = 'madoak'
    CompanyName       = 'PersonalTools'
    Copyright         = '(c) 2026'

    Description       = 'Stable plugin-based lightweight Nmap-style scanner'

    PowerShellVersion = '5.1'

    FunctionsToExport = @('Invoke-NmapLight')
}