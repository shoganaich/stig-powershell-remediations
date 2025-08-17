<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-00-000145 by setting DEP to at least OptOut.

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-00-000145
      - Requirement : Data Execution Prevention (DEP) must be configured to at least OptOut.
    This script uses BCDEdit to configure the current boot entry to nx OptOut.

    IMPORTANT:
    - Requires administrative privileges.
    - Changing DEP settings may require a reboot.
    - If BitLocker is enabled, suspend it before running this script to avoid recovery prompts.

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-12
    Last Modified   : 2025-08-12
    Version         : 1.0
    STIG-ID         : WN10-00-000145

.EXAMPLE
    PS C:\> .\remediation-STIG-(WN10-00-000145).ps1
    # Sets DEP to OptOut mode for the current boot entry.

.TESTED
    Date(s) Tested  : 2025-08-12
    Tested By       : Victor Cardoso
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1
#>

# Optional: Suspend BitLocker for 1 reboot if enabled
if (Get-BitLockerVolume -ErrorAction SilentlyContinue) {
    Suspend-BitLocker -MountPoint C: -RebootCount 1
}

# Set DEP to OptOut
bcdedit /set "{current}" nx OptOut
