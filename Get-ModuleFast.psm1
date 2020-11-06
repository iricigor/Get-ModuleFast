
foreach ($FunctionFile in (Get-ChildItem Public -Filter '*.ps1')) {
    Write-Verbose "Importing $($FunctionFile.BaseName)"
    . ($FunctionFile.FullName)
}