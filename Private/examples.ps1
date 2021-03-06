# example file used for investigation

$ModuleManifests = Get-Manifests
$ModuleManifests.Count # 929 # Depth=2 => 817

$GoodManifest = $ModuleManifests.FullName | Test-SameAncestor -CaseInsensitive
$GoodManifest.Count # 778 # Depth=2 => 767

$Modules = Measure-Command {Get-Module -ListAvailable} # 19 seconds!
$Modules.Count # 732

$MissingModules = $GoodManifest | where {$_ -notin $Modules.Path}
$MissingModules.Count  # 46 # Depth=2 => 35
# examples of manifests NOT returned as modules
#   C:\Users\iiric\Documents\PowerShell\Modules\Az.KeyVault\2.1.0\SecretManagementExtension\SecretManagementExtension.psd1
#   C:\Program Files\WindowsPowerShell\Modules\Azure\5.1.2\ExpressRoute\ExpressRoute.psd1
#   C:\Windows\System32\WindowsPowerShell\v1.0\Modules\AppLocker\AppLocker.psd1

# just confirms all is good above
$MissingManifests = $Modules | ? Path -NotIn $GoodManifest
$MissingManifests.Count # 0
$FoundInBoth = $Modules | ? Path -In $GoodManifest
$FoundInBoth.Count # 732

$MissingModules | % {
    # $_
    # Get-RelativePath $_
    # ((Get-RelativePath $_) -split '\\')[1]
    # Split-Path $_ -LeafBase
    # ""
    if ((((Get-RelativePath $_) -split '\\')[1]) -eq (Split-Path $_ -LeafBase)) {$_}
}





#
#  Monday, November 9th, 2020
#


Import-Module .\Get-ModuleList.psd1 -Force
Measure-Command { Get-ModuleList} # should be under 1 second
Measure-Command { 1..10 | % {Get-ModulesList}} | Select TotalSeconds
$MyModules = $null
$MyModules = Get-ModuleList #-Verbose
$MyModules.Count
#$Modules = Get-Module -ListAvailable
$Modules.Count

# just counts, should be zero on both
($MyModules | where Path -notin $Modules.Path | select -Expand Path).Count
($Modules | where Path -notin $MyModules.Path | select -Expand Path).Count

# my extra
$MyModules | where Path -notin $Modules.Path | select -Expand Path
# Get-Modules extra
$Modules | where Path -notin $MyModules.Path | select -Expand Path

# speed and results checking

#   just gci -depth 2 runs for 350 msec
#   parsing string runs 385-400 msec, added 40 msec, 10%
#   it returns 817 modules, correct number should be 732, 85 modules are extra, none is missing

#   test same ancestor, ❌ abandoned ❌
#   it runs 750-780 msec, added 380 msec, adding 100% => its too slow!
#   it returns 767 modules, 35 modules are extra, none of them is missing

#   rewrite inside test same ancestor
#   it runs 400-420 msec, it added 20 msec, 5%
#   it returns 765 modules, 33 are extra, none is missing
#   all 33 extra are in Windows folder, but there are 59 inside which are good

#   from win folder return only containing core
#   it run 470-490 msec, it added 70 msec, 15-20% => try if faster?
#   it returns 734 modules, 2 extra, none is missing
#     C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSDesiredStateConfiguration\PSDesiredStateConfiguration.psd1
#     C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWorkflow\PSWorkflow.psd1

#   from those results, use regex match for 'CompatiblePSEditions.*Core'
#   it runs 560-620 msec, it added 90-130 msec, 20-30% => try if faster?
#   it returns exactly the same modules!!! 😀😀😀

#   trying to optimize, use -join and select-string
#   it runs 680-610 msec

#   use only second regex is improving speed and not impacting results
#   it runs 530-590 msec
#   considering that gci and parse path takes 390-430 msec, the remaining logic is taking 140-160 msec which is good for 700 modules

#   re-organized and cleaned up the code gave us some minor speed benefits also
#   it runs now 510-580 msec

#   if we use "gci | %" it goes to 0.8-0.9 seconds!
#   therefore we use "foreach ($v in gci) {}"


#
# Wednesday, November 11th
#

# Comparing foreach, foreach-object and foreach-object parallel
#    foreach runs   540-620 msec
#    foreach-object 700-800 msec
#    f-o parallel   520-580 msec



#
# Friday, November 13th
#

$EnvFolders = $env:PSModulePath -split [io.path]::PathSeparator
$Names = @('Az','Pester')

(Measure-Command {foreach ($N1 in $Names) {
    foreach ($F1 in $EnvFolders) {
        Get-ChildItem $F1 -Filter "$N1.psd1" -Depth 2 -Recurse -ea 0 | Select -Expand FullName
    }
}}).TotalMilliseconds


(Measure-Command {
    $Manifests = foreach ($F1 in $EnvFolders) {
        Get-ChildItem $F1 -Filter "*.psd1" -Depth 2 -Recurse -ea 0
    }
    $Manifests | ? BaseName -in $Names | Select -Expand FullName
}).TotalMilliseconds