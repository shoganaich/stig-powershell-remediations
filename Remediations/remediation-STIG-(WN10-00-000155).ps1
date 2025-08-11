<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-00-000155 by disabling Windows PowerShell 2.0.

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-00-000155
      - Requirement : The Windows PowerShell 2.0 feature must be disabled on the system.
    The script disables the optional features:
      - MicrosoftWindowsPowerShellV2
      - MicrosoftWindowsPowerShellV2Root

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-11
    Last Modified   : 2025-08-11
    Version         : 1.0
    STIG-ID         : WN10-00-000155

.EXAMPLE
    PS C:\> .\Remediation-STIG-WN10-00-000155.ps1
    # Disables PowerShell 2.0 features if enabled; does not restart.
#>

# Disable PowerShell 2.0 and its root component
Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2 -NoRestart
Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root -NoRestart
