#requires -Version 5.1

[CmdletBinding(DefaultParameterSetName = 'Manifest')]
param(
    [Parameter(Mandatory = $true, ParameterSetName = 'Manifest')]
    [Parameter(Mandatory = $true, ParameterSetName = 'Direct')]
    [string] $BuildRecord,

    [Parameter(Mandatory = $true, ParameterSetName = 'Manifest')]
    [Parameter(Mandatory = $true, ParameterSetName = 'Direct')]
    [string] $RunDirectory,

    [Parameter(Mandatory = $true, ParameterSetName = 'Manifest')]
    [string] $Manifest,

    [Parameter(Mandatory = $true, ParameterSetName = 'Direct')]
    [string[]] $TestName,

    [Parameter(Mandatory = $true, ParameterSetName = 'Direct')]
    [UInt64] $Seed,

    [Parameter(ParameterSetName = 'Manifest')]
    [Parameter(ParameterSetName = 'Direct')]
    [string] $VerificationRecord,

    [Parameter(Mandatory = $true, ParameterSetName = 'Resume')]
    [string] $Resume
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

Import-Module (Join-Path $PSScriptRoot 'test-harness\TestHarness.psm1') -Force

$controllerLogPath = $null
$resultPath = $null

function Set-ResultProperty {
    param(
        [Parameter(Mandatory = $true)] $Value,
        [Parameter(Mandatory = $true)][string] $Name,
        [Parameter(Mandatory = $true)] $PropertyValue
    )

    if ($Value -is [Collections.IDictionary]) {
        $Value[$Name] = $PropertyValue
    } elseif ($Value.PSObject.Properties[$Name]) {
        $Value.$Name = $PropertyValue
    } else {
        $Value | Add-Member -MemberType NoteProperty -Name $Name -Value $PropertyValue
    }
}

function ConvertTo-IsoTimestamp {
    param([Parameter(Mandatory = $true)] $Value)

    if ($Value -is [DateTime]) {
        return $Value.ToUniversalTime().ToString('o')
    }
    return [string]$Value
}

function Assert-SelectedTestsCompleted {
    param(
        [Parameter(Mandatory = $true)][string[]] $Selected,
        [Parameter(Mandatory = $true)][object[]] $Events,
        [Parameter(Mandatory = $true)][string] $ChunkId
    )

    $finished = @($Events | Where-Object { $_.event -eq 'test_finished' })
    if ($finished.Count -ne $Selected.Count) {
        throw (New-HarnessException -ExitCode 2 -Message (
            "조각 '$ChunkId'의 완료 테스트 수가 선택 목록과 다릅니다: 선택 $($Selected.Count), 완료 $($finished.Count)"
        ))
    }
    $selectedSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($name in $Selected) {
        $null = $selectedSet.Add($name)
    }
    $finishedSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($event in $finished) {
        if (-not $finishedSet.Add([string]$event.name)) {
            throw (New-HarnessException -ExitCode 2 -Message "조각 '$ChunkId'가 테스트를 중복 완료했습니다: $($event.name)")
        }
    }
    if (-not $selectedSet.SetEquals($finishedSet)) {
        $missing = @($Selected | Where-Object { -not $finishedSet.Contains($_) })
        $extra = @($finishedSet | Where-Object { -not $selectedSet.Contains($_) })
        throw (New-HarnessException -ExitCode 2 -Message (
            "조각 '$ChunkId'의 실제 테스트가 선택 목록과 다릅니다. 누락: $($missing -join ', '); 추가: $($extra -join ', ')"
        ))
    }
    return $finished
}

function New-AttemptEvidence {
    param(
        [Parameter(Mandatory = $true)][string] $AttemptDirectory,
        [Parameter(Mandatory = $true)] $ProcessResult,
        [Parameter(Mandatory = $true)][string] $ProgressPath,
        [Parameter(Mandatory = $true)][string] $StdoutPath,
        [Parameter(Mandatory = $true)][string] $StderrPath,
        [Parameter(Mandatory = $true)][string] $CommandPath,
        [Parameter(Mandatory = $true)][string] $UserDirectory,
        [Parameter(Mandatory = $true)][string] $ArtifactsDirectory
    )

    return [pscustomobject][ordered]@{
        schema_version = 1
        attempt_directory = [IO.Path]::GetFullPath($AttemptDirectory)
        completed = [bool]$ProcessResult.completed
        reason = [string]$ProcessResult.reason
        pid = [int]$ProcessResult.pid
        exit_code = [int]$ProcessResult.exit_code
        started_at = [string]$ProcessResult.started_at
        ended_at = [string]$ProcessResult.ended_at
        progress = Get-FileEvidence -Path $ProgressPath
        stdout = Get-FileEvidence -Path $StdoutPath
        stderr = Get-FileEvidence -Path $StderrPath
        command = Get-FileEvidence -Path $CommandPath
        user_directory = Get-DirectoryEvidence -Path $UserDirectory
        artifacts_directory = Get-DirectoryEvidence -Path $ArtifactsDirectory
    }
}

try {
    if ($PSCmdlet.ParameterSetName -eq 'Resume') {
        $runRoot = [IO.Path]::GetFullPath($Resume)
        if (-not (Test-Path -LiteralPath $runRoot -PathType Container)) {
            throw (New-HarnessException -ExitCode 2 -Message "재개할 실행 디렉터리가 없습니다: $runRoot")
        }
        $runMetadataPath = Join-Path $runRoot 'run.json'
        $runMetadata = Read-JsonFile -Path $runMetadataPath
        $frozenBuildPath = Join-Path $runRoot 'input\build.json'
        $frozenManifestPath = Join-Path $runRoot 'input\manifest.json'
        if ((Get-Sha256File -Path $frozenBuildPath) -ne [string]$runMetadata.build_record_sha256 -or
            (Get-Sha256File -Path $frozenManifestPath) -ne [string]$runMetadata.manifest_sha256) {
            throw (New-HarnessException -ExitCode 3 -Message '재개 입력의 해시가 run.json과 다릅니다.')
        }
        $build = Read-JsonFile -Path $frozenBuildPath
        $plan = ConvertTo-NormalizedManifest `
            -Manifest (Read-JsonFile -Path $frozenManifestPath) `
            -BuildRecord $build
        $buildRecordHash = [string]$runMetadata.build_record_sha256
        $manifestHash = [string]$runMetadata.manifest_sha256
        $verification = $null
        $verificationHash = $null
        if ($runMetadata.PSObject.Properties['verification_record_sha256']) {
            $frozenVerificationPath = Join-Path $runRoot 'input\verification.json'
            $verificationHash = Get-Sha256File -Path $frozenVerificationPath
            if ($verificationHash -ne [string]$runMetadata.verification_record_sha256) {
                throw (New-HarnessException -ExitCode 3 -Message '재개 데이터 검증 기록의 해시가 run.json과 다릅니다.')
            }
            $verification = Read-JsonFile -Path $frozenVerificationPath
            Assert-VerificationRecordCurrent -VerificationRecord $verification -BuildRecord $build
        }
    } else {
        $runRoot = [IO.Path]::GetFullPath($RunDirectory)
        if (Test-Path -LiteralPath $runRoot) {
            throw (New-HarnessException -ExitCode 2 -Message "새 실행 디렉터리가 이미 있습니다: $runRoot")
        }
        $buildPath = [IO.Path]::GetFullPath($BuildRecord)
        $build = Read-JsonFile -Path $buildPath
        Assert-BuildRecordCurrent -BuildRecord $build

        if ($PSCmdlet.ParameterSetName -eq 'Manifest') {
            $rawManifest = Read-JsonFile -Path ([IO.Path]::GetFullPath($Manifest))
        } else {
            $rawManifest = [pscustomobject][ordered]@{
                schema_version = 1
                seed = $Seed
                chunks = @([pscustomobject][ordered]@{
                    id = 'direct'
                    tests = @($TestName)
                })
            }
        }
        $plan = ConvertTo-NormalizedManifest -Manifest $rawManifest -BuildRecord $build

        New-Item -ItemType Directory -Path $runRoot | Out-Null
        $inputDirectory = Join-Path $runRoot 'input'
        New-Item -ItemType Directory -Path $inputDirectory | Out-Null
        $frozenBuildPath = Join-Path $inputDirectory 'build.json'
        $frozenManifestPath = Join-Path $inputDirectory 'manifest.json'
        Copy-Item -LiteralPath $buildPath -Destination $frozenBuildPath
        Write-JsonFile -Path $frozenManifestPath -Value $plan
        $buildRecordHash = Get-Sha256File -Path $frozenBuildPath
        $manifestHash = Get-Sha256File -Path $frozenManifestPath
        $verification = $null
        $verificationHash = $null
        if ($VerificationRecord) {
            $verificationPath = [IO.Path]::GetFullPath($VerificationRecord)
            $verification = Read-JsonFile -Path $verificationPath
            Assert-VerificationRecordCurrent -VerificationRecord $verification -BuildRecord $build
            $frozenVerificationPath = Join-Path $inputDirectory 'verification.json'
            Copy-Item -LiteralPath $verificationPath -Destination $frozenVerificationPath
            $verificationHash = Get-Sha256File -Path $frozenVerificationPath
        }
        $runMetadataPath = Join-Path $runRoot 'run.json'
        $runMetadata = [ordered]@{
            schema_version = 1
            created_at = [DateTime]::UtcNow.ToString('o')
            build_record_sha256 = $buildRecordHash
            manifest_sha256 = $manifestHash
            state = 'running'
        }
        if ($verificationHash) {
            $runMetadata['verification_record_sha256'] = $verificationHash
        }
        Write-JsonFile -Path $runMetadataPath -Value $runMetadata
    }

    $controllerLogPath = Join-Path $runRoot 'controller.log'
    $resultPath = Join-Path $runRoot 'result.json'
    Add-ControllerLog -Path $controllerLogPath -Message "controller_started mode=$($PSCmdlet.ParameterSetName)"
    Assert-BuildRecordCurrent -BuildRecord $build

    $chunksRoot = Join-Path $runRoot 'chunks'
    New-Item -ItemType Directory -Path $chunksRoot -Force | Out-Null
    $batchesRoot = Join-Path $runRoot 'batches'
    New-Item -ItemType Directory -Path $batchesRoot -Force | Out-Null
    foreach ($chunk in @($plan.chunks)) {
        $chunkDirectory = Join-Path $chunksRoot ([string]$chunk.id)
        New-Item -ItemType Directory -Path $chunkDirectory -Force | Out-Null
        $chunkResultPath = Join-Path $chunkDirectory 'result.json'
        if (Test-Path -LiteralPath $chunkResultPath -PathType Leaf) {
            $existingResult = Read-JsonFile -Path $chunkResultPath
            if ([string]$existingResult.build_record_sha256 -ne $buildRecordHash -or
                [string]$existingResult.manifest_sha256 -ne $manifestHash -or
                [string]$existingResult.execution_status -ne 'completed') {
                throw (New-HarnessException -ExitCode 3 -Message "완료 조각 결과가 현재 실행 입력과 다릅니다: $($chunk.id)")
            }
            Add-ControllerLog -Path $controllerLogPath -Message "chunk_skipped id=$($chunk.id)"
        }
    }

    while ($true) {
        $pendingChunks = @($plan.chunks | Where-Object {
            -not (Test-Path -LiteralPath (Join-Path (Join-Path $chunksRoot ([string]$_.id)) 'result.json') -PathType Leaf)
        })
        if ($pendingChunks.Count -eq 0) {
            break
        }

        Assert-BuildRecordCurrent -BuildRecord $build
        $attemptNumber = Get-NextAttemptNumber -ChunkDirectory $batchesRoot
        $attemptDirectory = Join-Path $batchesRoot ('attempt-{0:D4}' -f $attemptNumber)
        New-Item -ItemType Directory -Path $attemptDirectory | Out-Null
        $userDirectory = Join-Path $attemptDirectory 'user'
        $artifactsDirectory = Join-Path $attemptDirectory 'artifacts'
        New-Item -ItemType Directory -Path $userDirectory,$artifactsDirectory | Out-Null
        $progressPath = Join-Path $attemptDirectory 'progress.jsonl'
        $stdoutPath = Join-Path $attemptDirectory 'stdout.txt'
        $stderrPath = Join-Path $attemptDirectory 'stderr.txt'
        $attemptResultPath = Join-Path $attemptDirectory 'attempt.json'
        $commandPath = Join-Path $attemptDirectory 'command.json'
        $processPlanPath = Join-Path $attemptDirectory 'test-plan.json'

        $processChunks = foreach ($chunk in $pendingChunks) {
            $chunkOutput = Join-Path $artifactsDirectory ([string]$chunk.id)
            New-Item -ItemType Directory -Path $chunkOutput | Out-Null
            [ordered]@{
                id = [string]$chunk.id
                seed = [uint64]$chunk.seed
                tests = @([string[]]$chunk.tests)
                output_dir = $chunkOutput
            }
        }
        Write-JsonFile -Path $processPlanPath -Value ([ordered]@{
            schema_version = 1
            chunks = @($processChunks)
        })
        $arguments = @(
            '--test-plan', $processPlanPath,
            '--option_overrides', 'SKIP_VERIFICATION:true',
            '--use-colour', 'no', '--wait-for-keypress', 'never', '--drop-world',
            '--user-dir', $userDirectory,
            '--test-output-dir', $artifactsDirectory,
            '--test-progress-log', $progressPath
        )
        Write-JsonFile -Path $commandPath -Value ([ordered]@{
            executable = [string]$build.executable.path
            arguments = @($arguments)
            working_directory = [string]$build.source_root
        })
        Add-ControllerLog -Path $controllerLogPath -Message (
            "batch_started attempt=$attemptNumber chunks=$(@($pendingChunks.id) -join ',')"
        )
        $processResult = Invoke-HarnessProcess `
            -Executable ([string]$build.executable.path) `
            -Arguments $arguments `
            -WorkingDirectory ([string]$build.source_root) `
            -ProgressPath $progressPath `
            -StdoutPath $stdoutPath `
            -StderrPath $stderrPath `
            -ControllerLogPath $controllerLogPath `
            -PollMilliseconds 60000 `
            -StallMilliseconds 1800000 `
            -InitializationStallMilliseconds 5400000

        $attemptEvidence = New-AttemptEvidence `
            -AttemptDirectory $attemptDirectory `
            -ProcessResult $processResult `
            -ProgressPath $progressPath `
            -StdoutPath $stdoutPath `
            -StderrPath $stderrPath `
            -CommandPath $commandPath `
            -UserDirectory $userDirectory `
            -ArtifactsDirectory $artifactsDirectory
        Write-JsonFile -Path $attemptResultPath -Value $attemptEvidence

        $completedThisBatch = 0
        foreach ($chunk in $pendingChunks) {
            $chunkId = [string]$chunk.id
            $chunkDirectory = Join-Path $chunksRoot $chunkId
            $chunkAttemptsDirectory = Join-Path $chunkDirectory 'attempts'
            New-Item -ItemType Directory -Path $chunkAttemptsDirectory -Force | Out-Null
            $chunkEvents = @($processResult.events | Where-Object { [string]$_.chunk_id -eq $chunkId })
            $terminal = @($chunkEvents | Where-Object { $_.event -eq 'chunk_completed' } | Select-Object -Last 1)
            $chunkAttempt = [ordered]@{
                batch_attempt = $attemptNumber
                completed = $terminal.Count -eq 1
                reason = if ($terminal.Count -eq 1) { 'completed' } else { [string]$processResult.reason }
                batch_attempt_result = Get-FileEvidence -Path $attemptResultPath
                artifacts_directory = Get-DirectoryEvidence -Path (Join-Path $artifactsDirectory $chunkId)
            }
            Write-JsonFile -Path (Join-Path $chunkAttemptsDirectory ('attempt-{0:D4}.json' -f $attemptNumber)) -Value $chunkAttempt
            if ($terminal.Count -eq 0) {
                continue
            }

            $finished = @(Assert-SelectedTestsCompleted `
                -Selected @([string[]]$chunk.tests) `
                -Events $chunkEvents `
                -ChunkId $chunkId)
            $testResults = foreach ($event in $finished) {
                [ordered]@{
                    name = [string]$event.name
                    outcome = [string]$event.outcome
                    duration_seconds = [double]$event.duration_seconds
                    assertions_passed = [uint64]$event.assertions_passed
                    assertions_failed = [uint64]$event.assertions_failed
                    assertions_failed_but_ok = [uint64]$event.assertions_failed_but_ok
                }
            }
            $attempts = @(Get-ChildItem -LiteralPath $chunkAttemptsDirectory -Filter 'attempt-*.json' -File |
                Sort-Object Name | ForEach-Object { Read-JsonFile -Path $_.FullName })
            $chunkResult = [ordered]@{
                schema_version = 1
                chunk_id = $chunkId
                execution_status = 'completed'
                outcome = [string]$terminal[0].outcome
                seed = [uint64]$chunk.seed
                build_record_sha256 = $buildRecordHash
                manifest_sha256 = $manifestHash
                completed_attempt = $attemptNumber
                attempt_count = $attempts.Count
                exit_code = [int]$terminal[0].catch_exit_code
                tests = @($testResults)
                attempts = @($attempts)
            }
            Write-JsonFile -Path (Join-Path $chunkDirectory 'result.json') -Value $chunkResult
            Add-ControllerLog -Path $controllerLogPath -Message "chunk_completed id=$chunkId outcome=$($terminal[0].outcome)"
            $completedThisBatch++
        }

        if ($processResult.completed -and $completedThisBatch -ne $pendingChunks.Count) {
            throw (New-HarnessException -ExitCode 3 -Message '테스트 프로세스가 정상 종료했지만 일부 조각 결과가 없습니다.')
        }
        if (-not $processResult.completed) {
            Add-ControllerLog -Path $controllerLogPath -Message (
                "batch_retry attempt=$attemptNumber reason=$($processResult.reason) completed_chunks=$completedThisBatch"
            )
        }
    }

    Assert-BuildRecordCurrent -BuildRecord $build
    $chunkResults = foreach ($chunk in @($plan.chunks)) {
        Read-JsonFile -Path (Join-Path (Join-Path $chunksRoot ([string]$chunk.id)) 'result.json')
    }
    $overallOutcome = if (@($chunkResults | Where-Object { $_.outcome -eq 'failed' }).Count -gt 0) {
        'failed'
    } else {
        'passed'
    }
    Add-ControllerLog -Path $controllerLogPath -Message "controller_completed outcome=$overallOutcome"
    $finalResult = [ordered]@{
        schema_version = 1
        execution_status = 'completed'
        outcome = $overallOutcome
        started_at = ConvertTo-IsoTimestamp -Value $runMetadata.created_at
        ended_at = [DateTime]::UtcNow.ToString('o')
        build_record_sha256 = $buildRecordHash
        manifest_sha256 = $manifestHash
        build_id = [string]$build.build_id
        controller_log = Get-FileEvidence -Path $controllerLogPath
        chunks = @($chunkResults)
    }
    if ($verificationHash) {
        $finalResult['verification_record'] = Get-FileEvidence -Path $frozenVerificationPath
    }
    Write-JsonFile -Path $resultPath -Value $finalResult
    Set-ResultProperty -Value $runMetadata -Name state -PropertyValue 'completed'
    Set-ResultProperty -Value $runMetadata -Name completed_at -PropertyValue ([DateTime]::UtcNow.ToString('o'))
    Set-ResultProperty -Value $runMetadata -Name outcome -PropertyValue $overallOutcome
    Write-JsonFile -Path $runMetadataPath -Value $runMetadata
    Write-Output "RUN: $($overallOutcome.ToUpperInvariant())"
    Write-Output "RESULT: $resultPath"
    if ($overallOutcome -eq 'failed') {
        exit 1
    }
    exit 0
} catch {
    $code = Get-HarnessExitCode -Exception $_.Exception
    if ($controllerLogPath) {
        try {
            Add-ControllerLog -Path $controllerLogPath -Message "controller_error code=$code message=$($_.Exception.Message)"
        } catch {
        }
    }
    Write-Output 'RUN: ERROR'
    Write-Output "ERROR: $($_.Exception.Message)"
    if ($resultPath -and (Test-Path -LiteralPath $resultPath -PathType Leaf)) {
        Write-Output "RESULT: $resultPath"
    }
    exit $code
}
