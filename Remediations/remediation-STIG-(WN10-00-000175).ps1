<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-00-000175 by disabling the Secondary Logon service.

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-00-000175
      - Requirement : The Secondary Logon service must be disabled on Windows 10.
    The script disable the Secondary Logon service (It is required to restart the machine).

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-12
    Last Modified   : 2025-08-12
    Version         : 1.0
    STIG-ID         : WN10-00-000175

.EXAMPLE
    PS C:\> .\Remediation-STIG-WN10-00-000175.ps1
    # Disables the Secondary Logon service immediately.
#>

# Disable the Secondary Logon service
Set-Service seclogon -StartupType Disabled
