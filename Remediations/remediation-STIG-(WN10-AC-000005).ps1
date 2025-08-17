<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-AC-000005 by setting up Account Lockout Duration.

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-AC-000005
      - Requirement : Account lockout duration must be configured to 15 minutes or greater (0 also acceptable).
      - Run as Admin.
    This script applies only to standalone/workgroup machines.
    If the computer is joined to an Active Directory domain, the script will stop without making changes.
    Domain-joined machines must be remediated via Group Policy or Set-ADDefaultDomainPasswordPolicy.

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-13
    Last Modified   : 2025-08-14
    Version         : 1.0
    STIG-ID         : WN10-AC-000005

.EXAMPLE
    PS C:\> .\remediation-STIG-(WN10-AC-000005).ps1
    # Sets Account lockout duration to 15 minutes on a standalone machine.

.TESTED
    Date(s) Tested  : 2025-08-14
    Tested By       : Victor Cardoso
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1
#>

# Functions for status messages
function Write-Info($msg){ Write-Host "[INFO]  $msg" -ForegroundColor Cyan }
function Write-OK($msg){ Write-Host   "[OK]    $msg" -ForegroundColor Green }
function Write-Err($msg){ Write-Host "[ERROR] $msg" -ForegroundColor Red }

# Check elevation
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Err "This script must be run as Administrator."
    exit 1
}

# Detect domain membership and stop if joined
try {
    $cs = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop
    if ($cs.PartOfDomain) {
        Write-Err "This computer is joined to an Active Directory domain."
        Write-Err "Domain-joined systems must be remediated via Group Policy or Set-ADDefaultDomainPasswordPolicy."
        exit 2
    }
} catch {
    Write-Err "Could not determine domain membership: $($_.Exception.Message)"
    exit 3
}

# Helper: run NET ACCOUNTS and stop on failure
function Invoke-NetAccounts {
    param([string]$Arguments)
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "cmd.exe"
    $psi.Arguments = "/c net accounts $Arguments"
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError  = $true
    $psi.UseShellExecute = $false
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $psi
    [void]$p.Start()
    $out = $p.StandardOutput.ReadToEnd()
    $err = $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    if ($p.ExitCode -ne 0) {
        throw "net accounts $Arguments failed (code $($p.ExitCode)): $err $out"
    }
    return $out
}

# Set Account lockout duration to 15 minutes
try {
    Write-Info "Configuring Account lockout duration to 15 minutes..."
    $null = Invoke-NetAccounts -Arguments "/lockoutduration:15"
    Write-OK "Lockout duration set."

    # Show effective policy
    Write-Info "Effective account policy:"
    $summary = Invoke-NetAccounts -Arguments ""
    $summary
    Write-OK "WN10-AC-000005 remediation complete."
    exit 0
}
catch {
    Write-Err $_.Exception.Message
    exit 4
}
