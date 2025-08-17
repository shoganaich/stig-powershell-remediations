<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-AC-000040 by enabling Password Complexity Requirements.

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-AC-000040
      - Requirement : Passwords must meet complexity requirements (enabled).
      - Run as Admin.
    Applies to standalone/workgroup machines. Exits on domain-joined machines.

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-17
    Last Modified   : 2025-08-17
    Version         : 1.5
    STIG-ID         : WN10-AC-000040

.EXAMPLE
    PS C:\> .\remediation-STIG-(WN10-AC-000040).ps1

.TESTED
    Date(s) Tested  : 2025-08-17
    Tested By       : Victor Cardoso
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 7.2
#>
$seceditFile = "$env:TEMP\secpol.inf"
$logFile     = "$env:TEMP\secpol.log"

secedit /export /cfg $seceditFile /log $logFile

(Get-Content $seceditFile).ForEach{
    $_ -replace '^PasswordComplexity\s*=.*', 'PasswordComplexity = 1'
} | Set-Content $seceditFile

secedit /configure /db secedit.sdb /cfg $seceditFile /log $logFile /quiet

# Clean temp and cache
Remove-Item $seceditFile -Force
Remove-Item $logFile -Force
