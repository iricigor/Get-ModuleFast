# example file used for investigation

$ModuleManifests = Get-Manifests
$ModuleManifests.Count # 929

$GoodManifest = $ModuleManifests.FullName | Test-SameAncestor -CaseInsensitive
$GoodManifest.Count # 778

$Modules = Get-Module -ListAvailable
$Modules.Count # 732

$MissingModules = $GoodManifest | where {$_ -notin $Modules.Path}
$MissingModules.Count  # 46
# examples of manifests NOT returned as modules
#   C:\Users\iiric\Documents\PowerShell\Modules\Az.KeyVault\2.1.0\SecretManagementExtension\SecretManagementExtension.psd1
#   C:\Program Files\WindowsPowerShell\Modules\Azure\5.1.2\ExpressRoute\ExpressRoute.psd1
#   C:\Windows\System32\WindowsPowerShell\v1.0\Modules\AppLocker\AppLocker.psd1

# just confirms all is good above
$MissingManifests = $Modules | ? Path -NotIn $GoodManifest
$MissingManifests.Count # 0
$FoundInBoth = $Modules | ? Path -In $GoodManifest
$FoundInBoth.Count # 732

