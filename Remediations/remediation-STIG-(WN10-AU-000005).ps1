<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-AU-000005 by auditing Credential Validation failures.

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-AU-000005
      - Requirement : Audit Credential Validation with "Failure" selected.
      - Run as Admin.
    Applies locally; domain GPO may override.

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-17
    Last Modified   : 2025-08-17
    Version         : 1.0
    STIG-ID         : WN10-AU-000005
    Warning         : This audit category is deprecated in newer STIGs.

.EXAMPLE
    PS C:\> .\remediation-STIG-(WN10-AU-000005).ps1

.TESTED
    Date(s) Tested  : 2025-08-17
    Tested By       : Victor Cardoso
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1
#>

auditpol /set /subcategory:"Credential Validation" /failure:enable
