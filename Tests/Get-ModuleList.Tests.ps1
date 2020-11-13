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

