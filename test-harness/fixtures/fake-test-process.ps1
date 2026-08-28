#requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string] $ProgressPath,
    [Parameter(Mandatory = $true)]
    [ValidateSet('pass', 'fail', 'crash', 'stall')]
    [string] $Mode,
    [int] $StallMilliseconds = 10000
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

function Add-Event {
    param(
        [Parameter(Mandatory = $true)][string] $Event,
        [hashtable] $Fields = @{}
    )

    $value = [ordered]@{
        schema_version = 1
        event = $Event
        timestamp_unix_ms = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
    }
    foreach ($key in $Fields.Keys) {
        $value[$key] = $Fields[$key]
    }
    Add-Content -LiteralPath $ProgressPath -Value ($value | ConvertTo-Json -Compress) -Encoding UTF8
}

Add-Event -Event 'run_started' -Fields @{ seed = 1 }
Add-Event -Event 'test_started' -Fields @{ name = 'fake_test' }

if ($Mode -eq 'crash') {
    Write-Error 'simulated crash'
    exit 99
}
if ($Mode -eq 'stall') {
    Start-Sleep -Milliseconds $StallMilliseconds
}

$failed = $Mode -eq 'fail'
Add-Event -Event 'test_finished' -Fields @{
    name = 'fake_test'
    outcome = if ($failed) { 'failed' } else { 'passed' }
    duration_seconds = 0.01
    assertions_passed = if ($failed) { 0 } else { 1 }
    assertions_failed = if ($failed) { 1 } else { 0 }
    assertions_failed_but_ok = 0
}
Add-Event -Event 'run_finished' -Fields @{
    outcome = if ($failed) { 'failed' } else { 'passed' }
}
if ($failed) {
    exit 1
}
exit 0
