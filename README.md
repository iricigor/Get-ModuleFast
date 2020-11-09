# Get-ModuleFast
Currently get-module command is very expensive. This is experiment in trying to make it fast.

## Current state
Current version on my PC is running about 30 times faster than `Get-Module -ListAvailable`, but it still returns all the same modules!

## Issues
- script is now running only on PS7 on Windows
- regex `'CompatiblePSEditions.*Core'` should be improved
- it is not returning version property unless available in path
- it is not returning other properties from manifest, like ModuleType, PSEdition, ExportedCommands, etc.

## Further ideas
- Convert script to run also on PS5 and on Linux
- Add switch to include additional properties
- Rename function to Get-ModuleList
- Add parameter Name
- Publish it to PS Gallery as script?