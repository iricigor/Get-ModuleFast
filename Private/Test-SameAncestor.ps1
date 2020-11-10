function Test-SameAncestor {

    # returns files where parent folder or its parent have the same name as given file

    # it can be used in two ways:
    #   as filter : (gci).FullName | Test-SameAncestor
    #   directly  : if (Test-SameAncestor $MyPath) {'yea'}

    [CmdletBinding()]
    param (

        [Parameter(Mandatory,ValueFromPipeline)]
        [string[]]$Path,

        [switch]$CaseInsensitive # by default it is case sensitive

    )

    BEGIN {}

    PROCESS {
        foreach ($P1 in $Path) {
            $Name = Split-Path $P1 -LeafBase
            $ParentPath = Split-Path $P1 -Parent
            $Parent = Split-Path $ParentPath -Leaf
            $GrandParent = Split-Path (Split-Path $ParentPath -Parent) -Leaf

            if ($CaseInsensitive) {
                $Name = $Name.ToUpper()
                $Parent = $Parent.ToUpper()
                $GrandParent = $GrandParent.ToUpper()
            }

            # return value
            if (($Name -ceq $Parent) -or ($Name -ceq $GrandParent)) {$P1}
        }
    }

    END {}
}
