BeforeAll {

    Write-Host "Before All block"

    $ModuleName = 'Get-ModuleList'
    $ModuleManifest = Join-Path $PSScriptRoot '..' "$ModuleName.psd1"
    Import-Module $ModuleManifest -Force
}

Describe 'Fake-Test' {
    It 'runs fake test' {
        $true | Should -BeTrue
    }
}

Describe 'Proper import tests' {

    It 'reads module variable' {
        $ModuleManifest | Should -Not -BeNullOrEmpty
    }

    It 'finds module manifest' {
        Get-Item $ModuleManifest | Should -Not -BeNullOrEmpty
    }

    It 'has module imported' {
        Get-Module $ModuleName | Should -Not -BeNullOrEmpty
    }

    It 'returns commands from the module' {
        Get-Command -Module $ModuleName | Should -Not -BeNullOrEmpty
    }
}

Describe 'Functionality tests' {
    It 'returns same module paths as original command' {
        $MyModules = $null
        $MyModules = Get-ModuleList #-Verbose
        $Modules = Get-Module -ListAvailable

        $MyModules.Count | Should -Be $Modules.Count
        ($MyModules | where Path -notin $Modules.Path | select -Expand Path).Count | Should -Be 0
        ($Modules | where Path -notin $MyModules.Path | select -Expand Path).Count | Should -Be 0
    }
}

Describe 'Speed tests' {
    It 'runs under one second' {
        # to be precise, we run it 10 times
        Measure-Command {1..10 | %{Get-ModuleList}} | Select -Expand TotalSeconds | Should -BeLessThan 10
    }
}

Describe 'Name parameter' {

    It 'returns nothing for non-existing module' {
        Get-ModuleList -Name 'non-existing-module' | Should -BeNullOrEmpty
    }

    It 'returns the the same number of Pester modules' {
        $MyModules = Get-ModuleList -Name Pester
        $Modules = Get-Module Pester -List
        $MyModules.Count | Should -Be ($Modules.Count)
    }

    It 'returns the the same number of first module' {
        $Module1 = Get-Module -List | Select -First 1 -Expand Name

        $MyModules = Get-ModuleList -Name $Module1
        $Modules = Get-Module $Module1 -List

        $MyModules.Count | Should -Be ($Modules.Count)
    }

    It 'accepts pipeline input' {
        $Module1 = Get-Module -List | ? Name -ne 'Pester' | Select -First 1 -Expand Name

        $MyModules = @($Module1, 'Pester') | Get-ModuleList
        $Modules = Get-Module $Module1,'Pester' -List

        $MyModules.Count | Should -Be ($Modules.Count)
    }

}

