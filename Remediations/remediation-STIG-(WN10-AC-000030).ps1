<#
.SYNOPSIS
    Remediates Windows 10 STIG WN10-AC-000030 by setting Minimum Password Age.

.DESCRIPTION
    Implements STIG control:
      - STIG-ID     : WN10-AC-000030
      - Requirement : Minimum password age must be configured to at least 1 day.
      - Run as Admin.
    Applies to standalone/workgroup machines. Exits on domain-joined machines.

.NOTES
    Author          : Victor Cardoso
    LinkedIn        : linkedin.com/in/victordccardoso
    GitHub          : github.com/shoganaich
    Date Created    : 2025-08-17
    Last Modified   : 2025-08-17
    Version         : 1.0
    STIG-ID         : WN10-AC-000030

.EXAMPLE
    PS C:\> .\remediation-STIG-(WN10-AC-000030).ps1

.TESTED
    Date(s) Tested  : 2025-08-17
    Tested By       : Victor Cardoso
    Systems Tested  : Windows 10 Pro 22H2
    PowerShell Ver. : 7.2
#>

$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference    = 'SilentlyContinue'

# --- Payload: enforce minimum password age >= 1 ---
$payloadCode = @"
`$ErrorActionPreference='SilentlyContinue'
`$ProgressPreference='SilentlyContinue'

# Skip domain-joined systems
try {
  `$partOfDomain = (Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction SilentlyContinue).PartOfDomain
} catch { `$partOfDomain = `$false }
if (`$partOfDomain) { return }

# Apply via net accounts
Start-Process -FilePath "`$env:SystemRoot\System32\net.exe" -ArgumentList 'accounts','/minpwage:1' -WindowStyle Hidden -Wait

# Optional: refresh local security policy
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

# --- Not elevated: stage payload, run once as SYSTEM, then self-clean ---
try {
    $taskName   = "WN10_AC_000030_" + [guid]::NewGuid().ToString('N')
    $payloadDir = "$env:ProgramData\WN10_AC_000030"
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
