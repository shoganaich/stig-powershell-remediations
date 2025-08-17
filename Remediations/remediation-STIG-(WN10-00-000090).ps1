<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-00-000090 by enabling password 
    expiration for all local accounts.

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-00-000090
      - Requirement : Accounts must be configured to require password expiration.
      - Run as Admin.

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-12
    Last Modified   : 2025-08-13
    Version         : 1.0
    STIG-ID         : WN10-00-000090

.EXAMPLE
    PS C:\> .\remediation-STIG-(WN10-00-000090).ps1
    # Disables the Secondary Logon service immediately.

.TESTED
    Date(s) Tested  : 2025-08-13
    Tested By       : Victor Cardoso
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1
#>

# Disable "Password never expires" for all ENABLED local users
$fixed = @()

Get-LocalUser |
  Where-Object { $_.Enabled -eq $true -and $_.PasswordNeverExpires -eq $true } |
  ForEach-Object {
    Set-LocalUser -Name $_.Name -PasswordNeverExpires:$false -ErrorAction Stop
    $fixed += $_.Name
  }

if ($fixed.Count) {
  Write-Host "Updated accounts:" ($fixed -join ', ')
} else {
  Write-Host "No enabled local accounts had 'Password never expires' set."
}

# (Optional) enforce a max password age for the machine, e.g., 90 days:
# net accounts /maxpwage:90
