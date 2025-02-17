﻿BeforeAll {
    # Import the module
    Import-Module "$PSScriptRoot/../LSUClient.psd1"
}

Describe 'Expand-LSUpdate' {
    It 'Calls the extract command' {
        InModuleScope LSUClient {
            $MockPackage = [PSCustomObject]@{
                ID = 'MOCKPKG'
                Installer = [PSCustomObject]@{
                    ExtractCommand = 'NonExistantFile Bogus Arguments'
                }
            }

            Mock -CommandName Invoke-PackageCommand -ModuleName LSUClient -Verifiable

            Expand-LSUpdate -Package $MockPackage -Path "$PWD" -WarningAction Ignore | Should -Invoke Invoke-PackageCommand -Times 1 -Exactly -ParameterFilter {
                $Command -eq 'NonExistantFile Bogus Arguments'
            }
        }
    }
    It 'Returns null' {
        InModuleScope LSUClient {
            $MockPackage = [PSCustomObject]@{
                ID = 'MOCKPKG'
                Installer = [PSCustomObject]@{
                    ExtractCommand = 'NonExistantFile Bogus Arguments'
                }
            }

            Expand-LSUpdate -Package $MockPackage -Path "$PWD" -WarningAction Ignore | Should -Be $null
        }
    }
    It 'Prints a warning' {
        InModuleScope LSUClient {
            $MockPackage = [PSCustomObject]@{
                ID = 'MOCKPKG'
                Installer = [PSCustomObject]@{
                    ExtractCommand = 'NonExistantFile Bogus Arguments'
                }
            }

            Expand-LSUpdate -Package $MockPackage -Path "$PWD" -WarningVariable WARNING -WarningAction SilentlyContinue
            $warning | Should -Not -BeNullOrEmpty
        }
    }
}
