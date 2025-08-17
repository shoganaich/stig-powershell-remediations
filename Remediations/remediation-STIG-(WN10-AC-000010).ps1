<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-AC-000010 by setting Account Lockout Threshold.

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-AC-000010
      - Requirement : Account lockout threshold must be configured to 3 invalid logon attempts or less.
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
    STIG-ID         : WN10-AC-000010

.EXAMPLE
    PS C:\> .\remediation-STIG-(WN10-AC-000010).ps1
    # Sets Account lockout threshold to 3 on a standalone machine.

.TESTED
    Date(s) Tested  : 2025-08-14
    Tested By       : Victor Cardoso
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1
#>

function Write-Info($m){ Write-Host "[INFO]  $m" -ForegroundColor Cyan }
function Write-OK($m){ Write-Host   "[OK]    $m" -ForegroundColor Green }
function Write-Err($m){ Write-Host  "[ERROR] $m" -ForegroundColor Red }

# Require admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Err "This script must be run as Administrator."; exit 1
}

# Stop on domain-joined
try {
    if ((Get-CimInstance Win32_ComputerSystem -ErrorAction Stop).PartOfDomain) {
        Write-Err "Domain-joined system detected. Use GPO/Default Domain Password Policy instead."; exit 2
    }
} catch { Write-Err "Unable to determine domain membership: $($_.Exception.Message)"; exit 3 }

# Helper
function Invoke-NetAccounts([string]$Args){
    $p = Start-Process -FilePath "cmd.exe" -ArgumentList "/c net accounts $Args" -NoNewWindow -PassThru -Wait -RedirectStandardOutput "$env:TEMP\netacc.out" -RedirectStandardError "$env:TEMP\netacc.err"
    $out = Get-Content "$env:TEMP\netacc.out" -Raw; $err = Get-Content "$env:TEMP\netacc.err" -Raw
    if ($p.ExitCode -ne 0){ throw "net accounts $Args failed ($($p.ExitCode)): $err $out" }
    $out
}

try {
    Write-Info "Setting Account lockout threshold to 3 invalid logon attempts..."
    Invoke-NetAccounts "/lockoutthreshold:3" | Out-Null
    Write-OK "Lockout threshold set."

    Write-Info "Effective account policy:"
    Invoke-NetAccounts "" | Write-Host
    Write-OK "WN10-AC-000010 remediation complete."
    exit 0
} catch { Write-Err $_.Exception.Message; exit 4 }
