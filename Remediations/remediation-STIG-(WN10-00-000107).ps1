<#
.SYNOPSIS
    Disables Windows Copilot for all loaded user SIDs and at the machine level.

.DESCRIPTION
    Implements (site policy) to turn off Windows Copilot by setting:
      - HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot\TurnOffWindowsCopilot = 1
      - HKU\<SID>\Software\Policies\Microsoft\Windows\WindowsCopilot\TurnOffWindowsCopilot = 1 for each loaded user hive

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-12
    Last Modified   : 2025-08-12
    Version         : 1.0
    STIG-ID         : WN10-00-000107

.EXAMPLE
    PS C:\> ./remediation-STIG-(WN10-00-000107).ps1
    # Sets DEP to OptOut mode for the current boot entry.

.TESTED
    Date(s) Tested  : 2025-08-12
    Tested By       : Victor Cardoso
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1
#>

# Machine-wide policy
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' `
  -Name TurnOffWindowsCopilot -PropertyType DWord -Value 1 -Force | Out-Null

# Per-loaded-user policy
Get-ChildItem -Path 'Registry::HKEY_USERS' |
  Where-Object { $_.Name -match 'HKEY_USERS\\S-1-5-21-\d+-\d+-\d+-\d+$' } |
  ForEach-Object {
    $sid = $_.PSChildName
    $path = "Registry::HKEY_USERS\$sid\Software\Policies\Microsoft\Windows\WindowsCopilot"
    New-Item -Path $path -Force | Out-Null
    New-ItemProperty -Path $path -Name TurnOffWindowsCopilot -PropertyType DWord -Value 1 -Force | Out-Null
  }
