function Get-ModulesFast {

    [CmdletBinding()]
    param ()

    # processing
    $EnvFolders = $env:PSModulePath -split ';'
    #foreach ($F1 in $EnvFolders) {
    $EnvFolders | ForEach-Object -Parallel {
        $F1 = $_

        $WinFolder = $F1.ToUpper().StartsWith((Join-Path $Env:SystemRoot '\System32\WindowsPowerShell\v1.0\Modules').ToUpper())
        $F1 = $F1.TrimEnd('\')
        $Manifests = Get-ChildItem $F1 -Filter '*.psd1' -Depth 2 -Recurse -ea 0

        foreach ($M1 in $Manifests) {

            # path manipulation
            $ModuleName = Split-Path $M1 -LeafBase
            $Split = $M1.FullName.Substring($F1.Length+1) -split '\\'
            $FirstFolder = $Split.Count -eq 1 ? $M1.Directory.Name : $Split[0]

            if ($ModuleName -ne $FirstFolder) {continue}

            # prepare return object, but do not return it yet!
            $RetValue = [PSCustomObject]@{
                Version = $Split.Count -eq 3 ? $Split[1] : $null
                Name    = $ModuleName
                Path    = $M1.FullName
            }

            # only if we meet conditions, then return it
            if (!$WinFolder) {
                $RetValue
            } else {
                # we need to check inside of file!
                $cont = (Get-Content $M1 -Raw) -replace "`n",''
                if ($cont -match 'CompatiblePSEditions.*Core') {
                    $RetValue
                }
            }
        } # end foreach $Manifest
    } # end foreach $EnvFolder
}
