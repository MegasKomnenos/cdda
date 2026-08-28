Set-StrictMode -Version 3.0

function Get-Sha256File {
    param([Parameter(Mandatory = $true)][string] $Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "파일을 찾을 수 없습니다: $Path"
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Get-Sha256Text {
    param([Parameter(Mandatory = $true)][AllowEmptyString()][string] $Text)

    $sha = [Security.Cryptography.SHA256]::Create()
    try {
        $bytes = [Text.Encoding]::UTF8.GetBytes($Text)
        return ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace('-', '').ToLowerInvariant()
    } finally {
        $sha.Dispose()
    }
}

function Read-JsonFile {
    param([Parameter(Mandatory = $true)][string] $Path)

    try {
        return Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
        throw "JSON 파일을 읽을 수 없습니다: $Path`n$($_.Exception.Message)"
    }
}

function Write-JsonFile {
    param(
        [Parameter(Mandatory = $true)][string] $Path,
        [Parameter(Mandatory = $true)] $Value
    )

    $parent = Split-Path -Parent $Path
    if ($parent) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    $temporary = "$Path.tmp-$PID"
    $Value | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $temporary -Encoding UTF8
    Move-Item -LiteralPath $temporary -Destination $Path -Force
}

function New-HarnessException {
    param(
        [Parameter(Mandatory = $true)][string] $Message,
        [Parameter(Mandatory = $true)][ValidateSet(2, 3)][int] $ExitCode
    )

    $exception = [InvalidOperationException]::new($Message)
    $exception.Data['HarnessExitCode'] = $ExitCode
    return $exception
}

function Get-HarnessExitCode {
    param([Parameter(Mandatory = $true)][Exception] $Exception)

    if ($Exception.Data.Contains('HarnessExitCode')) {
        return [int]$Exception.Data['HarnessExitCode']
    }
    return 3
}

function Invoke-GitLines {
    param(
        [Parameter(Mandatory = $true)][string] $SourceRoot,
        [Parameter(Mandatory = $true)][string[]] $Arguments
    )

    $output = @(& git -C $SourceRoot @Arguments 2>&1)
    if ($LASTEXITCODE -ne 0) {
        throw "Git 명령이 실패했습니다: git -C $SourceRoot $($Arguments -join ' ')`n$($output -join [Environment]::NewLine)"
    }
    return @($output | ForEach-Object { $_.ToString() })
}

function Get-SourceFingerprint {
    param([Parameter(Mandatory = $true)][string] $SourceRoot)

    $resolvedRoot = [IO.Path]::GetFullPath($SourceRoot)
    $head = (Invoke-GitLines -SourceRoot $resolvedRoot -Arguments @('rev-parse', 'HEAD') |
        Select-Object -First 1).Trim()
    $status = @(Invoke-GitLines -SourceRoot $resolvedRoot -Arguments @(
        'status', '--porcelain=v1', '--untracked-files=all'
    ))
    $diff = @(Invoke-GitLines -SourceRoot $resolvedRoot -Arguments @(
        'diff', '--binary', '--no-ext-diff', 'HEAD', '--'
    ))
    $untracked = @(Invoke-GitLines -SourceRoot $resolvedRoot -Arguments @(
        'ls-files', '--others', '--exclude-standard'
    ) | Where-Object { $_ })

    $untrackedEvidence = foreach ($relativePath in ($untracked | Sort-Object)) {
        $fullPath = Join-Path $resolvedRoot $relativePath
        if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
            throw "소스 지문을 계산하는 동안 untracked 파일이 사라졌습니다: $fullPath"
        }
        [ordered]@{
            path = $relativePath.Replace('\', '/')
            sha256 = Get-Sha256File -Path $fullPath
        }
    }

    $payload = [ordered]@{
        head = $head
        status = @($status)
        diff = @($diff)
        untracked = @($untrackedEvidence)
    }
    $canonical = $payload | ConvertTo-Json -Depth 10 -Compress
    return [pscustomobject][ordered]@{
        head = $head
        fingerprint = Get-Sha256Text -Text $canonical
        status_count = $status.Count
        untracked_count = $untracked.Count
    }
}

function Assert-BuildRecordCurrent {
    param([Parameter(Mandatory = $true)] $BuildRecord)

    foreach ($property in @('source_root', 'source', 'executable')) {
        if (-not $BuildRecord.PSObject.Properties[$property]) {
            throw (New-HarnessException -ExitCode 3 -Message "빌드 기록에 '$property' 필드가 없습니다.")
        }
    }
    $executablePath = [string]$BuildRecord.executable.path
    if (-not (Test-Path -LiteralPath $executablePath -PathType Leaf)) {
        throw (New-HarnessException -ExitCode 3 -Message "테스트 실행 파일이 없습니다: $executablePath")
    }
    $actualExecutableHash = Get-Sha256File -Path $executablePath
    if ($actualExecutableHash -ne [string]$BuildRecord.executable.sha256) {
        throw (New-HarnessException -ExitCode 3 -Message "테스트 실행 파일이 빌드 기록과 다릅니다: $executablePath")
    }
    $actualSource = Get-SourceFingerprint -SourceRoot ([string]$BuildRecord.source_root)
    if ($actualSource.fingerprint -ne [string]$BuildRecord.source.fingerprint) {
        throw (New-HarnessException -ExitCode 3 -Message '소스 상태가 빌드 기록과 다릅니다. 새 빌드를 만드세요.')
    }
}

function Assert-VerificationRecordCurrent {
    param(
        [Parameter(Mandatory = $true)] $VerificationRecord,
        [Parameter(Mandatory = $true)] $BuildRecord
    )

    if ([int]$VerificationRecord.schema_version -ne 1 -or
        [string]$VerificationRecord.outcome -ne 'passed') {
        throw (New-HarnessException -ExitCode 3 -Message '데이터 검증 기록이 통과 상태가 아닙니다.')
    }
    if ([string]$VerificationRecord.build_id -ne [string]$BuildRecord.build_id -or
        [string]$VerificationRecord.executable_sha256 -ne [string]$BuildRecord.executable.sha256 -or
        [string]$VerificationRecord.source_fingerprint -ne [string]$BuildRecord.source.fingerprint) {
        throw (New-HarnessException -ExitCode 3 -Message '데이터 검증 기록이 현재 빌드와 다릅니다.')
    }
}

function Get-ObjectPropertyNames {
    param([Parameter(Mandatory = $true)] $Value)
    return @($Value.PSObject.Properties | Select-Object -ExpandProperty Name)
}

function Assert-OnlyProperties {
    param(
        [Parameter(Mandatory = $true)] $Value,
        [Parameter(Mandatory = $true)][string[]] $Allowed,
        [Parameter(Mandatory = $true)][string] $Context
    )

    $unknown = @(Get-ObjectPropertyNames -Value $Value | Where-Object { $_ -notin $Allowed })
    if ($unknown.Count -gt 0) {
        throw (New-HarnessException -ExitCode 2 -Message "$Context 알 수 없는 필드가 있습니다: $($unknown -join ', ')")
    }
}

function ConvertTo-Seed {
    param(
        [Parameter(Mandatory = $true)] $Value,
        [Parameter(Mandatory = $true)][string] $Context
    )

    $number = 0L
    if (-not [Int64]::TryParse($Value.ToString(), [ref]$number) -or
        $number -lt 1 -or $number -gt [UInt32]::MaxValue) {
        throw (New-HarnessException -ExitCode 2 -Message "$Context seed는 1부터 4294967295 사이의 정수여야 합니다.")
    }
    return [uint32]$number
}

function ConvertTo-NormalizedManifest {
    param(
        [Parameter(Mandatory = $true)] $Manifest,
        [Parameter(Mandatory = $true)] $BuildRecord
    )

    Assert-OnlyProperties -Value $Manifest -Allowed @('schema_version', 'seed', 'chunks') -Context '명세에'
    if (-not $Manifest.PSObject.Properties['schema_version'] -or [int]$Manifest.schema_version -ne 1) {
        throw (New-HarnessException -ExitCode 2 -Message '명세 schema_version은 1이어야 합니다.')
    }
    if (-not $Manifest.PSObject.Properties['seed']) {
        throw (New-HarnessException -ExitCode 2 -Message '명세 seed가 없습니다.')
    }
    if (-not $Manifest.PSObject.Properties['chunks']) {
        throw (New-HarnessException -ExitCode 2 -Message '명세 chunks가 없습니다.')
    }

    $defaultSeed = ConvertTo-Seed -Value $Manifest.seed -Context '명세'
    $chunks = @($Manifest.chunks)
    if ($chunks.Count -eq 0) {
        throw (New-HarnessException -ExitCode 2 -Message '명세에 조각이 없습니다.')
    }

    $inventory = [Collections.Generic.Dictionary[string, object]]::new([StringComparer]::Ordinal)
    foreach ($entry in @($BuildRecord.tests)) {
        if ($inventory.ContainsKey([string]$entry.name)) {
            throw (New-HarnessException -ExitCode 3 -Message "빌드 기록에 중복 테스트 이름이 있습니다: $($entry.name)")
        }
        $inventory.Add([string]$entry.name, $entry)
    }

    $chunkIds = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $testNames = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $normalizedChunks = [Collections.Generic.List[object]]::new()
    foreach ($chunk in $chunks) {
        Assert-OnlyProperties -Value $chunk -Allowed @('id', 'seed', 'tests') -Context '조각에'
        if (-not $chunk.PSObject.Properties['id'] -or
            [string]$chunk.id -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$') {
            throw (New-HarnessException -ExitCode 2 -Message '조각 id는 영문자나 숫자로 시작하는 1~64자의 영문자·숫자·점·밑줄·하이픈이어야 합니다.')
        }
        $chunkId = [string]$chunk.id
        if (-not $chunkIds.Add($chunkId)) {
            throw (New-HarnessException -ExitCode 2 -Message "중복 조각 id가 있습니다: $chunkId")
        }
        if (-not $chunk.PSObject.Properties['tests']) {
            throw (New-HarnessException -ExitCode 2 -Message "조각 '$chunkId'에 tests가 없습니다.")
        }
        $tests = @($chunk.tests)
        if ($tests.Count -eq 0) {
            throw (New-HarnessException -ExitCode 2 -Message "조각 '$chunkId'의 테스트 목록이 비어 있습니다.")
        }
        $normalizedTests = [Collections.Generic.List[string]]::new()
        foreach ($test in $tests) {
            $name = [string]$test
            if (-not $inventory.ContainsKey($name)) {
                throw (New-HarnessException -ExitCode 2 -Message "등록되지 않은 테스트 이름입니다: $name")
            }
            if ($name -match '[,\*\?\[\]~"\\]') {
                throw (New-HarnessException -ExitCode 2 -Message "Catch2 필터 문자가 들어간 테스트 이름은 정확히 전달할 수 없습니다: $name")
            }
            if (-not $testNames.Add($name)) {
                throw (New-HarnessException -ExitCode 2 -Message "중복 테스트 이름이 있습니다: $name")
            }
            $normalizedTests.Add($name)
        }
        $chunkSeed = $defaultSeed
        if ($chunk.PSObject.Properties['seed']) {
            $chunkSeed = ConvertTo-Seed -Value $chunk.seed -Context "조각 '$chunkId'"
        }
        $normalizedChunks.Add([pscustomobject][ordered]@{
            id = $chunkId
            seed = [uint64]$chunkSeed
            tests = @($normalizedTests)
        })
    }

    return [pscustomobject][ordered]@{
        schema_version = 1
        seed = [uint64]$defaultSeed
        chunks = @($normalizedChunks)
    }
}

function ConvertTo-NativeArgument {
    param([Parameter(Mandatory = $true)][AllowEmptyString()][string] $Value)

    if ($Value.Length -gt 0 -and $Value -notmatch '[\s"]') {
        return $Value
    }
    $builder = [Text.StringBuilder]::new()
    $null = $builder.Append('"')
    $backslashes = 0
    foreach ($character in $Value.ToCharArray()) {
        if ($character -eq '\') {
            $backslashes++
            continue
        }
        if ($character -eq '"') {
            $null = $builder.Append(('\' * ($backslashes * 2 + 1)))
            $null = $builder.Append('"')
            $backslashes = 0
            continue
        }
        if ($backslashes -gt 0) {
            $null = $builder.Append(('\' * $backslashes))
            $backslashes = 0
        }
        $null = $builder.Append($character)
    }
    if ($backslashes -gt 0) {
        $null = $builder.Append(('\' * ($backslashes * 2)))
    }
    $null = $builder.Append('"')
    return $builder.ToString()
}

function Stop-ProcessTree {
    param([Parameter(Mandatory = $true)][int] $ProcessId)

    $taskkill = Join-Path $env:SystemRoot 'System32\taskkill.exe'
    if (Test-Path -LiteralPath $taskkill -PathType Leaf) {
        & $taskkill /PID $ProcessId /T /F 1>$null 2>$null
        return
    }
    Stop-Process -Id $ProcessId -Force -ErrorAction SilentlyContinue
}

function Add-ControllerLog {
    param(
        [Parameter(Mandatory = $true)][string] $Path,
        [Parameter(Mandatory = $true)][string] $Message
    )

    $line = '{0:o} {1}' -f [DateTime]::UtcNow, $Message
    Add-Content -LiteralPath $Path -Value $line -Encoding UTF8
}

function Get-NextAttemptNumber {
    param([Parameter(Mandatory = $true)][string] $ChunkDirectory)

    $numbers = @(Get-ChildItem -LiteralPath $ChunkDirectory -Directory -Filter 'attempt-*' `
        -ErrorAction SilentlyContinue | ForEach-Object {
            if ($_.Name -match '^attempt-(\d{4})$') {
                [int]$Matches[1]
            }
        })
    if ($numbers.Count -eq 0) {
        return 1
    }
    return [int](($numbers | Measure-Object -Maximum).Maximum + 1)
}

function Get-ProgressEvents {
    param([Parameter(Mandatory = $true)][string] $Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return @()
    }
    $events = [Collections.Generic.List[object]]::new()
    foreach ($line in Get-Content -LiteralPath $Path -Encoding UTF8) {
        if (-not $line) {
            continue
        }
        try {
            $events.Add(($line | ConvertFrom-Json))
        } catch {
            continue
        }
    }
    return @($events)
}

function Invoke-HarnessProcess {
    param(
        [Parameter(Mandatory = $true)][string] $Executable,
        [Parameter(Mandatory = $true)][string[]] $Arguments,
        [Parameter(Mandatory = $true)][string] $WorkingDirectory,
        [Parameter(Mandatory = $true)][string] $ProgressPath,
        [Parameter(Mandatory = $true)][string] $StdoutPath,
        [Parameter(Mandatory = $true)][string] $StderrPath,
        [Parameter(Mandatory = $true)][string] $ControllerLogPath,
        [Parameter(Mandatory = $true)][int] $PollMilliseconds,
        [Parameter(Mandatory = $true)][int] $StallMilliseconds,
        [int] $InitializationStallMilliseconds = 0
    )

    if ($InitializationStallMilliseconds -le 0) {
        $InitializationStallMilliseconds = $StallMilliseconds
    }

    $startInfo = [Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $Executable
    $startInfo.Arguments = ($Arguments | ForEach-Object { ConvertTo-NativeArgument -Value $_ }) -join ' '
    $startInfo.WorkingDirectory = $WorkingDirectory
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true

    $stdoutStream = [IO.File]::Open($StdoutPath, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::Read)
    $stderrStream = [IO.File]::Open($StderrPath, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::Read)
    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $startInfo
    $processStarted = $false
    $stdoutTask = $null
    $stderrTask = $null
    $startedAt = [DateTime]::UtcNow
    $lastProgressAt = $startedAt
    $lastProgressLength = 0L
    $termination = $null
    try {
        if (-not $process.Start()) {
            throw "테스트 프로세스를 시작하지 못했습니다: $Executable"
        }
        $processStarted = $true
        $stdoutTask = $process.StandardOutput.BaseStream.CopyToAsync($stdoutStream)
        $stderrTask = $process.StandardError.BaseStream.CopyToAsync($stderrStream)
        Add-ControllerLog -Path $ControllerLogPath -Message "process_started pid=$($process.Id)"

        while (-not $process.WaitForExit($PollMilliseconds)) {
            $now = [DateTime]::UtcNow
            $length = 0L
            if (Test-Path -LiteralPath $ProgressPath -PathType Leaf) {
                $length = (Get-Item -LiteralPath $ProgressPath).Length
            }
            if ($length -gt $lastProgressLength) {
                $lastProgressLength = $length
                $lastProgressAt = $now
            }
            $initializing = $false
            if ($length -gt 0) {
                $progressEvents = @(Get-ProgressEvents -Path $ProgressPath)
                $lastInitializationStart = @($progressEvents | Where-Object {
                    $_.event -eq 'initialization_started'
                } | Select-Object -Last 1)
                $lastInitializationFinish = @($progressEvents | Where-Object {
                    $_.event -eq 'initialization_finished'
                } | Select-Object -Last 1)
                $initializing = $lastInitializationStart.Count -eq 1 -and
                    ($lastInitializationFinish.Count -eq 0 -or
                     [int64]$lastInitializationStart[0].timestamp_unix_ms -gt
                     [int64]$lastInitializationFinish[0].timestamp_unix_ms)
            }
            $activeStallMilliseconds = if ($initializing) {
                $InitializationStallMilliseconds
            } else {
                $StallMilliseconds
            }
            Add-ControllerLog -Path $ControllerLogPath -Message (
                "process_alive pid=$($process.Id) progress_bytes=$length initializing=$initializing last_progress=$($lastProgressAt.ToString('o'))"
            )
            if (($now - $lastProgressAt).TotalMilliseconds -ge $activeStallMilliseconds) {
                $termination = 'stalled'
                Add-ControllerLog -Path $ControllerLogPath -Message "process_stalled pid=$($process.Id)"
                Stop-ProcessTree -ProcessId $process.Id
                $process.WaitForExit()
                break
            }
        }
        $null = $stdoutTask.GetAwaiter().GetResult()
        $null = $stderrTask.GetAwaiter().GetResult()
    } finally {
        if ($processStarted -and -not $process.HasExited) {
            Stop-ProcessTree -ProcessId $process.Id
            $process.WaitForExit()
        }
        if ($null -ne $stdoutTask -and -not $stdoutTask.IsCompleted) {
            $stdoutTask.Wait()
        }
        if ($null -ne $stderrTask -and -not $stderrTask.IsCompleted) {
            $stderrTask.Wait()
        }
        $stdoutStream.Dispose()
        $stderrStream.Dispose()
    }

    $endedAt = [DateTime]::UtcNow
    $exitCode = $process.ExitCode
    $pid = $process.Id
    $process.Dispose()
    $events = @(Get-ProgressEvents -Path $ProgressPath)
    $runFinished = @($events | Where-Object { $_.event -eq 'run_finished' } | Select-Object -Last 1)
    $normalExit = $exitCode -ge 0 -and $exitCode -le 255
    $completed = $termination -eq $null -and $normalExit -and $runFinished.Count -eq 1
    $reason = if ($completed) {
        'completed'
    } elseif ($termination) {
        $termination
    } else {
        'unexpected_exit'
    }
    Add-ControllerLog -Path $ControllerLogPath -Message "process_ended pid=$pid exit=$exitCode reason=$reason"

    return [pscustomobject][ordered]@{
        completed = $completed
        reason = $reason
        pid = $pid
        exit_code = $exitCode
        started_at = $startedAt.ToString('o')
        ended_at = $endedAt.ToString('o')
        events = @($events)
    }
}

function Get-FileEvidence {
    param([Parameter(Mandatory = $true)][string] $Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return [pscustomobject][ordered]@{ path = [IO.Path]::GetFullPath($Path); exists = $false }
    }
    $item = Get-Item -LiteralPath $Path
    return [pscustomobject][ordered]@{
        path = $item.FullName
        exists = $true
        bytes = $item.Length
        sha256 = Get-Sha256File -Path $item.FullName
    }
}

function Get-DirectoryEvidence {
    param([Parameter(Mandatory = $true)][string] $Path)

    $resolved = [IO.Path]::GetFullPath($Path)
    if (-not (Test-Path -LiteralPath $resolved -PathType Container)) {
        return [pscustomobject][ordered]@{ path = $resolved; exists = $false; files = @() }
    }
    $files = foreach ($file in Get-ChildItem -LiteralPath $resolved -File -Recurse | Sort-Object FullName) {
        [ordered]@{
            path = $file.FullName.Substring($resolved.Length).TrimStart('\', '/').Replace('\', '/')
            bytes = $file.Length
            sha256 = Get-Sha256File -Path $file.FullName
        }
    }
    $canonical = @($files) | ConvertTo-Json -Depth 5 -Compress
    return [pscustomobject][ordered]@{
        path = $resolved
        exists = $true
        files = @($files)
        sha256 = Get-Sha256Text -Text $canonical
    }
}

Export-ModuleMember -Function @(
    'Get-Sha256File', 'Get-Sha256Text', 'Read-JsonFile', 'Write-JsonFile',
    'New-HarnessException', 'Get-HarnessExitCode', 'Get-SourceFingerprint',
    'Assert-BuildRecordCurrent', 'Assert-VerificationRecordCurrent', 'ConvertTo-NormalizedManifest',
    'Invoke-HarnessProcess', 'Get-ProgressEvents', 'Get-FileEvidence',
    'Get-DirectoryEvidence', 'Add-ControllerLog', 'Get-NextAttemptNumber'
)
