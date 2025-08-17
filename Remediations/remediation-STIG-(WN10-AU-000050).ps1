<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-AU-000050 by enabling auditing of Process Creation (Success).

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-AU-000050
      - Requirement : The system must be configured to audit Detailed Tracking → Process Creation successes.
      - Method      : Sets Advanced Audit Policy subcategory "Process Creation" to Success via auditpol.
      - Run as Admin.
    Note: In domain environments this is typically enforced via GPO. This script applies a local change only.

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-17
    Last Modified   : 2025-08-17
    Version         : 1.0
    STIG-ID         : WN10-AU-000050

.EXAMPLE
    PS C:\> .\remediation-STIG-(WN10-AU-000050).ps1

.TESTED
    Date(s) Tested  : 2025-08-17
    Tested By       : Victor Cardoso
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1
#>

auditpol /set /subcategory:"Process Creation" /success:enable
