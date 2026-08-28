#requires -Version 5.1

[CmdletBinding()]
param(
    [string] $BuildRecord
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

$repositoryRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
Import-Module (Join-Path $PSScriptRoot 'TestHarness.psm1') -Force

function Assert-True {
    param(
        [Parameter(Mandatory = $true)][bool] $Condition,
        [Parameter(Mandatory = $true)][string] $Message
    )
    if (-not $Condition) {
        throw $Message
    }
}

function Invoke-Fake {
    param(
        [Parameter(Mandatory = $true)][string] $Mode,
        [Parameter(Mandatory = $true)][string] $Directory,
        [int] $PollMilliseconds = 100,
        [int] $StallMilliseconds = 5000
    )

    New-Item -ItemType Directory -Path $Directory | Out-Null
    $progress = Join-Path $Directory 'progress.jsonl'
    $stdout = Join-Path $Directory 'stdout.txt'
    $stderr = Join-Path $Directory 'stderr.txt'
    $controller = Join-Path $Directory 'controller.log'
    $shell = (Get-Command pwsh.exe -ErrorAction SilentlyContinue).Source
    if (-not $shell) {
        $shell = (Get-Command powershell.exe -ErrorAction Stop).Source
    }
    return Invoke-HarnessProcess `
        -Executable $shell `
        -Arguments @(
            '-NoProfile', '-File', (Join-Path $PSScriptRoot 'fixtures\fake-test-process.ps1'),
            '-ProgressPath', $progress, '-Mode', $Mode, '-StallMilliseconds', '10000'
        ) `
        -WorkingDirectory $repositoryRoot `
        -ProgressPath $progress `
        -StdoutPath $stdout `
        -StderrPath $stderr `
        -ControllerLogPath $controller `
        -PollMilliseconds $PollMilliseconds `
        -StallMilliseconds $StallMilliseconds
}

$testRoot = Join-Path $repositoryRoot ('build\test-harness-self-test\{0}' -f
    [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ'))
New-Item -ItemType Directory -Path $testRoot -Force | Out-Null

$attemptNumberRoot = Join-Path $testRoot 'attempt-number'
New-Item -ItemType Directory -Path $attemptNumberRoot | Out-Null
New-Item -ItemType Directory -Path (Join-Path $attemptNumberRoot 'attempt-0001') | Out-Null
$nextAttempt = Get-NextAttemptNumber -ChunkDirectory $attemptNumberRoot
Assert-True -Condition ($nextAttempt -is [int] -and $nextAttempt -eq 2) `
    -Message '다음 시도 번호를 정수 2로 계산하지 못했습니다.'

$pass = Invoke-Fake -Mode pass -Directory (Join-Path $testRoot 'pass with spaces')
Assert-True -Condition $pass.completed -Message '통과 프로세스를 완료로 판정하지 못했습니다.'
Assert-True -Condition ($pass.exit_code -eq 0) -Message '통과 프로세스 종료 코드가 0이 아닙니다.'

$fail = Invoke-Fake -Mode fail -Directory (Join-Path $testRoot 'fail')
Assert-True -Condition $fail.completed -Message '테스트 실패를 정상 완료로 판정하지 못했습니다.'
Assert-True -Condition ($fail.exit_code -eq 1) -Message '테스트 실패 종료 코드가 1이 아닙니다.'

$crash = Invoke-Fake -Mode crash -Directory (Join-Path $testRoot 'crash')
Assert-True -Condition (-not $crash.completed) -Message '충돌 프로세스를 완료로 판정했습니다.'
Assert-True -Condition ($crash.reason -eq 'unexpected_exit') -Message '충돌 처분이 unexpected_exit가 아닙니다.'

$stall = Invoke-Fake -Mode stall -Directory (Join-Path $testRoot 'stall')
Assert-True -Condition (-not $stall.completed) -Message '교착 프로세스를 완료로 판정했습니다.'
Assert-True -Condition ($stall.reason -eq 'stalled') -Message '교착 처분이 stalled가 아닙니다.'

$fakeRecord = [pscustomobject]@{
    tests = @(
        [pscustomobject]@{ name = 'alpha'; hidden = $false },
        [pscustomobject]@{ name = 'beta'; hidden = $true }
    )
}
$validManifest = [pscustomobject]@{
    schema_version = 1
    seed = 7
    chunks = @(
        [pscustomobject]@{ id = 'one'; tests = @('alpha') },
        [pscustomobject]@{ id = 'two'; seed = 8; tests = @('beta') }
    )
}
$normalized = ConvertTo-NormalizedManifest -Manifest $validManifest -BuildRecord $fakeRecord
Assert-True -Condition ($normalized.chunks.Count -eq 2) -Message '유효 명세를 정규화하지 못했습니다.'
Assert-True -Condition ($normalized.chunks[1].seed -eq 8) -Message '조각 seed 재정의를 보존하지 못했습니다.'

$duplicateRejected = $false
try {
    $invalidManifest = [pscustomobject]@{
        schema_version = 1
        seed = 7
        chunks = @(
            [pscustomobject]@{ id = 'one'; tests = @('alpha') },
            [pscustomobject]@{ id = 'two'; tests = @('alpha') }
        )
    }
    $null = ConvertTo-NormalizedManifest -Manifest $invalidManifest -BuildRecord $fakeRecord
} catch {
    $duplicateRejected = (Get-HarnessExitCode -Exception $_.Exception) -eq 2
}
Assert-True -Condition $duplicateRejected -Message '중복 테스트 이름을 거부하지 않았습니다.'

if ($BuildRecord) {
    $badBuild = Read-JsonFile -Path ([IO.Path]::GetFullPath($BuildRecord))
    $badBuild.executable.sha256 = '0' * 64
    $badBuildRejected = $false
    try {
        Assert-BuildRecordCurrent -BuildRecord $badBuild
    } catch {
        $badBuildRejected = (Get-HarnessExitCode -Exception $_.Exception) -eq 3
    }
    Assert-True -Condition $badBuildRejected -Message '실행 파일 해시 불일치를 거부하지 않았습니다.'

    $verificationRecord = [pscustomobject]@{
        schema_version = 1
        outcome = 'passed'
        build_id = [string]$badBuild.build_id
        executable_sha256 = [string](Read-JsonFile -Path ([IO.Path]::GetFullPath($BuildRecord))).executable.sha256
        source_fingerprint = [string]$badBuild.source.fingerprint
    }
    $currentBuild = Read-JsonFile -Path ([IO.Path]::GetFullPath($BuildRecord))
    Assert-VerificationRecordCurrent -VerificationRecord $verificationRecord -BuildRecord $currentBuild
    $verificationRecord.source_fingerprint = '0' * 64
    $badVerificationRejected = $false
    try {
        Assert-VerificationRecordCurrent -VerificationRecord $verificationRecord -BuildRecord $currentBuild
    } catch {
        $badVerificationRejected = (Get-HarnessExitCode -Exception $_.Exception) -eq 3
    }
    Assert-True -Condition $badVerificationRejected -Message '다른 소스의 데이터 검증 기록을 거부하지 않았습니다.'

    $integrationRoot = Join-Path $testRoot 'actual'
    $shell = (Get-Command pwsh.exe -ErrorAction SilentlyContinue).Source
    if (-not $shell) {
        $shell = (Get-Command powershell.exe -ErrorAction Stop).Source
    }
    $runScript = Join-Path $repositoryRoot 'run-tests.ps1'
    $firstOutput = @(& $shell -NoProfile -File $runScript `
        -BuildRecord ([IO.Path]::GetFullPath($BuildRecord)) `
        -RunDirectory $integrationRoot `
        -TestName test_output_directory `
        -Seed 1)
    Assert-True -Condition ($LASTEXITCODE -eq 0) -Message "실제 테스트 통합 실행이 실패했습니다: $($firstOutput -join ' ')"
    $attemptsBefore = @(Get-ChildItem -LiteralPath (Join-Path $integrationRoot 'batches') `
        -Directory -Filter 'attempt-*').Count
    $resumeOutput = @(& $shell -NoProfile -File $runScript -Resume $integrationRoot)
    Assert-True -Condition ($LASTEXITCODE -eq 0) -Message "실제 테스트 재개 실행이 실패했습니다: $($resumeOutput -join ' ')"
    $attemptsAfter = @(Get-ChildItem -LiteralPath (Join-Path $integrationRoot 'batches') `
        -Directory -Filter 'attempt-*').Count
    Assert-True -Condition ($attemptsBefore -eq 1 -and $attemptsAfter -eq 1) `
        -Message '완료 조각을 재개 실행에서 다시 실행했습니다.'
    $outputArtifact = Join-Path $integrationRoot `
        'batches\attempt-0001\artifacts\direct\test-output-smoke.txt'
    Assert-True -Condition (Test-Path -LiteralPath $outputArtifact -PathType Leaf) `
        -Message '테스트 출력 파일이 시도 artifacts 디렉터리에 없습니다.'

    $retryRoot = Join-Path $testRoot 'actual-retry'
    $retryOutput = @(& $shell -NoProfile -File $runScript `
        -BuildRecord ([IO.Path]::GetFullPath($BuildRecord)) `
        -RunDirectory $retryRoot `
        -TestName test_harness_crash_once `
        -Seed 1)
    Assert-True -Condition ($LASTEXITCODE -eq 0) -Message "실제 재시도 통합 실행이 실패했습니다: $($retryOutput -join ' ')"
    $retryResult = Read-JsonFile -Path (Join-Path $retryRoot 'result.json')
    Assert-True -Condition ($retryResult.chunks[0].attempt_count -eq 2) `
        -Message '충돌 뒤 같은 조각을 두 번째 시도로 재실행하지 않았습니다.'
    Assert-True -Condition ($retryResult.chunks[0].attempts[0].reason -eq 'unexpected_exit' -and
        $retryResult.chunks[0].attempts[1].reason -eq 'completed') `
        -Message '충돌 시도와 완료 시도의 처분이 올바르지 않습니다.'

    $persistentRoot = Join-Path $testRoot 'actual-persistent'
    $persistentOutput = @(& $shell -NoProfile -File $runScript `
        -BuildRecord ([IO.Path]::GetFullPath($BuildRecord)) `
        -RunDirectory $persistentRoot `
        -Manifest (Join-Path $PSScriptRoot 'fixtures\two-nogame-chunks.json'))
    Assert-True -Condition ($LASTEXITCODE -eq 0) -Message "지속 프로세스 통합 실행이 실패했습니다: $($persistentOutput -join ' ')"
    $persistentBatches = @(Get-ChildItem -LiteralPath (Join-Path $persistentRoot 'batches') `
        -Directory -Filter 'attempt-*').Count
    $persistentResult = Read-JsonFile -Path (Join-Path $persistentRoot 'result.json')
    Assert-True -Condition ($persistentBatches -eq 1 -and $persistentResult.chunks.Count -eq 2) `
        -Message '두 논리 조각을 테스트 프로세스 하나에서 완료하지 못했습니다.'

    $failureRoot = Join-Path $testRoot 'actual-failure'
    $failureOutput = @(& $shell -NoProfile -File $runScript `
        -BuildRecord ([IO.Path]::GetFullPath($BuildRecord)) `
        -RunDirectory $failureRoot `
        -Manifest (Join-Path $PSScriptRoot 'fixtures\failure-then-pass.json'))
    Assert-True -Condition ($LASTEXITCODE -eq 1) -Message "테스트 실패 실행의 종료 코드가 1이 아닙니다: $($failureOutput -join ' ')"
    $failureResult = Read-JsonFile -Path (Join-Path $failureRoot 'result.json')
    Assert-True -Condition ($failureResult.chunks[0].outcome -eq 'failed' -and
        $failureResult.chunks[1].outcome -eq 'passed') `
        -Message '테스트 실패 뒤 후속 조각을 완료하지 못했습니다.'
}

Write-Output 'HARNESS_TESTS: PASSED'
Write-Output "RESULTS: $testRoot"
