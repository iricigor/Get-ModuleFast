BeforeAll {

    $ModuleName = 'Get-ModuleFast'
    Import-Module (Join-Path $PSScriptRoot '..' "$ModuleName.psd1") -Force
}

Describe 'Fake-Test' {
    It 'runs fake test' {
        $true | Should -BeTrue
    }
}

Describe 'Functionality tests' {
    It 'returns same module paths as original command' {
        $Modules = Get-Module -ListAvailable
        $MyModules = $null
        $MyModules = Get-ModulesFast #-Verbose

        $MyModules.Count | Should -Be $Modules.Count
        ($MyModules | where Path -notin $Modules.Path | select -Expand Path).Count | Should -Be 0
        ($Modules | where Path -notin $MyModules.Path | select -Expand Path).Count | Should -Be 0
    }
}

Describe 'Speed tests' {
    It 'runs under one second' {
        # to be precise, we run it 10 times
        Measure-Command {1..10 | %{Get-ModulesFast}} | Select -Expand TotalSeconds | Should -BeLessThan 10
    }
}

