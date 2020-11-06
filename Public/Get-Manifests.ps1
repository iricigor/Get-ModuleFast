function Get-Manifests {

    # processing
    $EnvFolders = $env:PSModulePath -split ';'
    foreach ($F1 in $EnvFolders) {
        Get-ChildItem $F1 -Recurse -Filter '*.psd1' -ea 0
    }
}