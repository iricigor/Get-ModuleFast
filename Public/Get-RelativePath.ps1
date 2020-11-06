function Get-RelativePath {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [string[]]$Path
    )

    BEGIN {
        $Command = 'Get-RelativePath'
        Write-Verbose "$Command starting"
        $Paths = $Env:PSModulePath -split ';'
    }

    PROCESS {
        :outer foreach ($P1 in $Path) {
            Write-Verbose "  checking $P1"

            foreach ($MP in $Paths) {
                if ($P1.ToUpper().StartsWith($MP.ToUpper())) {
                    Write-Verbose "  found under $MP"
                    # return value
                    $P1.Substring($MP.Length)
                    continue outer
                }
            }
            Write-Verbose "  not found anywhere"
            Write-Error "Path not in PSModulePath" -TargetObject $P1
        }
    }

    END {
        Write-Verbose "$Command ended"
    }
}