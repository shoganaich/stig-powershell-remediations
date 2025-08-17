<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-AU-000010 by enabling auditing of Credential Validation (Success).

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-AU-000010
      - Requirement : The system must be configured to audit Account Logon → Credential Validation successes.
      - Method      : Sets Advanced Audit Policy subcategory "Credential Validation" to Success via auditpol.
      - Run as Admin.
    Note: In domain environments this setting is typically enforced via GPO. This script applies a local change only.

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-17
    Last Modified   : 2025-08-17
    Version         : 1.0
    STIG-ID         : WN10-AU-000010

.EXAMPLE
    PS C:\> .\remediation-STIG-(WN10-AU-000010).ps1

.TESTED
    Date(s) Tested  : 2025-08-17
    Tested By       : Victor Cardoso
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 7.2
#>

auditpol /set /subcategory:"Credential Validation" /success:enable
