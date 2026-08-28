#requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string] $BuildRecord,
    [Parameter(Mandatory = $true)][string] $RunDirectory
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

Import-Module (Join-Path $PSScriptRoot 'test-harness\TestHarness.psm1') -Force

$controllerLog = $null
try {
    $buildPath = [IO.Path]::GetFullPath($BuildRecord)
    $runRoot = [IO.Path]::GetFullPath($RunDirectory)
    if (Test-Path -LiteralPath $runRoot) {
        throw (New-HarnessException -ExitCode 2 -Message "새 데이터 검증 디렉터리가 이미 있습니다: $runRoot")
    }
    $build = Read-JsonFile -Path $buildPath
    Assert-BuildRecordCurrent -BuildRecord $build
    New-Item -ItemType Directory -Path $runRoot | Out-Null
    $inputDirectory = Join-Path $runRoot 'input'
    New-Item -ItemType Directory -Path $inputDirectory | Out-Null
    $frozenBuildPath = Join-Path $inputDirectory 'build.json'
    Copy-Item -LiteralPath $buildPath -Destination $frozenBuildPath
    $buildHash = Get-Sha256File -Path $frozenBuildPath
    $controllerLog = Join-Path $runRoot 'controller.log'
    Add-ControllerLog -Path $controllerLog -Message 'verification_started'

    $attemptsRoot = Join-Path $runRoot 'attempts'
    New-Item -ItemType Directory -Path $attemptsRoot | Out-Null
    while ($true) {
        Assert-BuildRecordCurrent -BuildRecord $build
        $attemptNumber = Get-NextAttemptNumber -ChunkDirectory $attemptsRoot
        $attemptDirectory = Join-Path $attemptsRoot ('attempt-{0:D4}' -f $attemptNumber)
        New-Item -ItemType Directory -Path $attemptDirectory | Out-Null
        $userDirectory = Join-Path $attemptDirectory 'user'
        $artifactsDirectory = Join-Path $attemptDirectory 'artifacts'
        New-Item -ItemType Directory -Path $userDirectory,$artifactsDirectory | Out-Null
        $progress = Join-Path $attemptDirectory 'progress.jsonl'
        $stdout = Join-Path $attemptDirectory 'stdout.txt'
        $stderr = Join-Path $attemptDirectory 'stderr.txt'
        $arguments = @(
            'test_data_initialization', '--rng-seed', '1', '--order', 'decl',
            '--use-colour', 'no', '--wait-for-keypress', 'never', '--drop-world',
            '--user-dir', $userDirectory, '--test-output-dir', $artifactsDirectory,
            '--test-progress-log', $progress
        )
        $commandPath = Join-Path $attemptDirectory 'command.json'
        Write-JsonFile -Path $commandPath -Value ([ordered]@{
            executable = [string]$build.executable.path
            arguments = $arguments
            working_directory = [string]$build.source_root
        })
        $process = Invoke-HarnessProcess `
            -Executable ([string]$build.executable.path) `
            -Arguments $arguments `
            -WorkingDirectory ([string]$build.source_root) `
            -ProgressPath $progress `
            -StdoutPath $stdout `
            -StderrPath $stderr `
            -ControllerLogPath $controllerLog `
            -PollMilliseconds 60000 `
            -StallMilliseconds 1800000 `
            -InitializationStallMilliseconds 5400000
        $attempt = [ordered]@{
            number = $attemptNumber
            completed = [bool]$process.completed
            reason = [string]$process.reason
            pid = [int]$process.pid
            exit_code = [int]$process.exit_code
            started_at = [string]$process.started_at
            ended_at = [string]$process.ended_at
            command = Get-FileEvidence -Path $commandPath
            progress = Get-FileEvidence -Path $progress
            stdout = Get-FileEvidence -Path $stdout
            stderr = Get-FileEvidence -Path $stderr
            user_directory = Get-DirectoryEvidence -Path $userDirectory
            artifacts_directory = Get-DirectoryEvidence -Path $artifactsDirectory
        }
        Write-JsonFile -Path (Join-Path $attemptDirectory 'attempt.json') -Value $attempt
        if (-not $process.completed) {
            Add-ControllerLog -Path $controllerLog -Message "verification_retry attempt=$attemptNumber reason=$($process.reason)"
            continue
        }
        $finished = @($process.events | Where-Object { $_.event -eq 'test_finished' })
        if ($finished.Count -ne 1 -or [string]$finished[0].name -ne 'test_data_initialization') {
            throw (New-HarnessException -ExitCode 3 -Message '데이터 검증 테스트 결과가 완전하지 않습니다.')
        }
        $outcome = if ($process.exit_code -eq 0) { 'passed' } else { 'failed' }
        Add-ControllerLog -Path $controllerLog -Message "verification_completed outcome=$outcome"
        $record = [ordered]@{
            schema_version = 1
            outcome = $outcome
            created_at = [DateTime]::UtcNow.ToString('o')
            build_id = [string]$build.build_id
            build_record_sha256 = $buildHash
            executable_sha256 = [string]$build.executable.sha256
            source_fingerprint = [string]$build.source.fingerprint
            mods = @('dda', 'test_data')
            completed_attempt = $attemptNumber
            controller_log = Get-FileEvidence -Path $controllerLog
            attempt = $attempt
        }
        $resultPath = Join-Path $runRoot 'verification.json'
        Write-JsonFile -Path $resultPath -Value $record
        Write-Output "VERIFICATION: $($outcome.ToUpperInvariant())"
        Write-Output "RESULT: $resultPath"
        if ($outcome -eq 'failed') {
            exit 1
        }
        exit 0
    }
} catch {
    $code = Get-HarnessExitCode -Exception $_.Exception
    if ($controllerLog) {
        try { Add-ControllerLog -Path $controllerLog -Message "verification_error code=$code message=$($_.Exception.Message)" } catch {}
    }
    Write-Output 'VERIFICATION: ERROR'
    Write-Output "ERROR: $($_.Exception.Message)"
    exit $code
}
