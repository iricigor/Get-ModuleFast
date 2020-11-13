if (!(Get-Module Pester -List | ? Version -ge 5.0.0)) {
    Write-Host 'Importing Pester module'
    Install-Module Pester -RequiredVersion 5.0.0
}

Invoke-Pester -Output Detailed -CI