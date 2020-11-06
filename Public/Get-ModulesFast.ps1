function Get-ModulesFast {

    # processing
    $EnvFolders = $env:PSModulePath -split ';'
    foreach ($F1 in $EnvFolders) {
        # $Folders = Get-ChildItem $F1 -Directory -ea 0
        # foreach ($Folder in $Folders) {
        #     $Manifest = $Folder.BaseName + '.psd1'
        #     $T1 = Join-Path $Folder $Manifest
        #     $T2 = Join-Path $Folder '*' $Manifest
        #     if (Test-Path $T1) {
        #         $T1
        #     } elseif (Test-Path $T2) {
        #         (Get-Item $T2).FullName
        #     }
        # }
        # version 1: 10.9 sec

        $Manifests = Get-ChildItem $F1 -Filter '*.psd1' -Depth 2 -Recurse
        $Manifests | % {
            $ModuleName = Split-Path $_ -LeafBase
            $Split = $_.FullName.Substring($F1.Length+1) -split '\\'
            $FirstFolder = $Split[0]
            if ($ModuleName -eq $FirstFolder) {
                # return value
                # Get-Module ($_.FullName) -List # 20 sec
                # Test-ModuleManifest extremely slow, 150 sec
                [PSCustomObject]@{
                    Name    = $ModuleName
                    Version = $Split.Count -eq 3 ? $Split[1] : $null
                    Path    = $_.FullName
                }
            }
        }
    }
}