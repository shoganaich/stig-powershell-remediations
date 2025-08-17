<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-AU-000565 by enabling auditing for
    Logon/Logoff → Other Logon/Logoff Events (Failures).

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-AU-000565
      - Requirement : Windows 10 must be configured to audit "Other Logon/Logoff Events" with
      - Run as Admin.
.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-17
    Last Modified   : 2025-08-17
    Version         : 1.0
    STIG-ID         : WN10-AU-000565

.EXAMPLE
    PS C:\> .\remediation-STIG-(WN10-AU-000565).ps1

.TESTED
    Date(s) Tested  : 2025-08-17
    Tested By       : Victor Cardoso
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1
#>

auditpol /set /subcategory:"Other Logon/Logoff Events" /failure:enable
