
foreach ($FunctionFile in (Get-ChildItem Public -Filter '*.ps1')) {
    Write-Host "Importing $($FunctionFile.BaseName)"
    . ($FunctionFile.FullName)
}

Export-ModuleMember -Function 'Get-ModulesFast'