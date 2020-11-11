# Get-ModuleFast
Currently get-module command is very expensive. This is experiment in trying to make it fast.

## Current state
Current version on my PC is running about 30 times faster than `Get-Module -ListAvailable`, but it still returns all the same modules!

## Issues
- script is now running only on PS7 on Windows
- regex `'CompatiblePSEditions.*Core'` should be improved
- it is not returning version property unless available in path
- it is not returning other properties from manifest, like ModuleType, PSEdition, ExportedCommands, etc.

## Big picture

This workflow should run fast:
- get all modules
- check if they can be updated

With current updates in PowerShell Get v3, it is expected to enable second step to run fast.
Alternatively, one can use [`psaptgetupdate`](https://github.com/iricigor/psaptgetupdate) module which already has that fast functionality.

This project is trying also to enable first tstep to run fast.
Once both are done, you will be able to check if there are modules on your system that needs update **in less than a second!**


## Further ideas
- Convert script to run also on PS5 and on Linux
- Add switch to include additional properties
- Rename function to Get-ModuleList
- Add parameter Name
- Publish it to PS Gallery as script?
- Try parallel foreach operations

## Test pipeline status

[![Build status](https://dev.azure.com/iiric/azmi/_apis/build/status/Run%20Pester%20Tests)](https://dev.azure.com/iiric/azmi/_build/latest?definitionId=34)
![](https://img.shields.io/azure-devops/tests/iiric/azmi/34)
![](https://img.shields.io/azure-devops/coverage/iiric/azmi/34)

*Click on image to see details.*

## Other Badges

![](https://img.shields.io/github/languages/count/iricigor/Get-ModuleFast)
![](https://img.shields.io/github/languages/top/iricigor/Get-ModuleFast)

![](https://img.shields.io/github/last-commit/iricigor/Get-ModuleFast)
![](https://img.shields.io/github/languages/code-size/iricigor/Get-ModuleFast)
![](https://img.shields.io/github/repo-size/iricigor/Get-ModuleFast)
