<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-AC-000015 by setting Reset Account Lockout Counter After.

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-AC-000015
      - Requirement : Reset account lockout counter after must be configured to 15 minutes or greater.
      - Run as Admin.
    Applies only to standalone/workgroup machines; stops on domain-joined machines.

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-13
    Last Modified   : 2025-08-14
    Version         : 1.1
    STIG-ID         : WN10-AC-000015

.EXAMPLE
    PS C:\> .\remediation-STIG-(WN10-AC-000015).ps1

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
    Write-Info "Setting Reset account lockout counter after to 15 minutes..."
    Invoke-NetAccounts "/lockoutwindow:15" | Out-Null
    Write-OK "Reset window set."

    Write-Info "Effective account policy:"
    Invoke-NetAccounts "" | Write-Host
    Write-OK "WN10-AC-000015 remediation complete."
    exit 0
} catch { Write-Err $_.Exception.Message; exit 4 }
