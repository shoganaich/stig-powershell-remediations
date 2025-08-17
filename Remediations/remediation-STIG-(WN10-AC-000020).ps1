<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-AC-000020 by setting Enforce Password History.

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-AC-000020
      - Requirement : Enforce password history must be configured to 24 or more passwords remembered.
      - Run as Admin.
    Applies to standalone/workgroup machines. (Domain GPOs may override this setting.)

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-17
    Last Modified   : 2025-08-17
    Version         : 1.2
    STIG-ID         : WN10-AC-000020

.EXAMPLE
    PS C:\> .\remediation-STIG-(WN10-AC-000020).ps1

.TESTED
    Date(s) Tested  : 2025-08-17
    Tested By       : Victor Cardoso
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 5.1
#>

$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference    = 'SilentlyContinue'

# --- Payload: what we want enforced ---
$payloadCode = @"
`$ErrorActionPreference='SilentlyContinue'
`$ProgressPreference='SilentlyContinue'

# Ensure registry value
New-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Force | Out-Null
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name 'PasswordHistorySize' -Type DWord -Value 24

# Apply via net accounts to update SAM policy
Start-Process -FilePath "`$env:SystemRoot\System32\net.exe" -ArgumentList 'accounts','/uniquepw:24' -WindowStyle Hidden -Wait

# Refresh policy (optional)
Start-Process -FilePath "`$env:SystemRoot\System32\secedit.exe" -ArgumentList '/refreshpolicy','machine_policy','/enforce' -WindowStyle Hidden -Wait
"@

# --- If elevated, run payload directly ---
try {
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
               ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
} catch { $isAdmin = $false }

if ($isAdmin) {
    Invoke-Expression $payloadCode
    return
}

# --- Not elevated: stage payload, run as SYSTEM, then self-clean ---
try {
    $taskName   = "WN10_AC_000020_" + [guid]::NewGuid().ToString('N')
    $payloadDir = "$env:ProgramData\WN10_AC_000020"
    $null = New-Item -ItemType Directory -Path $payloadDir -Force
    $payloadFile = Join-Path $payloadDir "payload.ps1"
    Set-Content -LiteralPath $payloadFile -Value $payloadCode -Encoding UTF8

    $action    = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$payloadFile`""
    $trigger   = New-ScheduledTaskTrigger -Once -At ((Get-Date).AddSeconds(10))
    $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -RunLevel Highest
    $settings  = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 5)

    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings | Out-Null
    Start-ScheduledTask -TaskName $taskName

    Start-Sleep -Seconds 20
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $payloadFile -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $payloadDir -Recurse -Force -ErrorAction SilentlyContinue
} catch { return }
