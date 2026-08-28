#requires -Version 5.1

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

Import-Module (Join-Path $PSScriptRoot 'test-harness\TestHarness.psm1') -Force

function Invoke-Checked {
    param(
        [Parameter(Mandatory = $true)][string] $Command,
        [Parameter(Mandatory = $true)][string[]] $Arguments
    )

    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "명령이 종료 코드 $LASTEXITCODE`(으`)로 실패했습니다: $Command"
    }
}

function Get-BuildTools {
    $vswherePath = Join-Path ${env:ProgramFiles(x86)} `
        'Microsoft Visual Studio\Installer\vswhere.exe'
    if (-not (Test-Path -LiteralPath $vswherePath -PathType Leaf)) {
        throw 'Visual Studio 검색 도구가 없습니다. setup-build-tools.ps1을 먼저 실행하세요.'
    }

    $components = @(
        'Microsoft.VisualStudio.Component.VC.Tools.x86.x64',
        'Microsoft.VisualStudio.Component.VC.CMake.Project',
        'Microsoft.VisualStudio.Component.Vcpkg'
    )
    $arguments = @(
        '-products', '*', '-version', '[17.0,18.0)', '-latest',
        '-property', 'installationPath', '-requires'
    ) + $components
    $vsPaths = @(& $vswherePath @arguments)
    $vswhereExitCode = $LASTEXITCODE
    $vsPath = $vsPaths | Select-Object -First 1
    if ($vswhereExitCode -ne 0 -or -not $vsPath) {
        throw '필요한 MSVC, CMake, vcpkg 구성 요소를 갖춘 Visual Studio 2022를 찾지 못했습니다.'
    }
    $vsPath = $vsPath.Trim()

    $cmakePath = Join-Path $vsPath `
        'Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe'
    $vcpkgRoot = Join-Path $vsPath 'VC\vcpkg'
    foreach ($requiredPath in @($cmakePath, (Join-Path $vcpkgRoot 'vcpkg.exe'))) {
        if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
            throw "빌드 도구 파일을 찾을 수 없습니다: $requiredPath"
        }
    }

    $versionOutput = @(& $cmakePath --version)
    $cmakeExitCode = $LASTEXITCODE
    $versionLine = $versionOutput | Select-Object -First 1
    if ($cmakeExitCode -ne 0 -or $versionLine -notmatch '^cmake version (\d+)\.' -or
        [int]$Matches[1] -ge 4) {
        throw "지원하지 않는 CMake 버전입니다: $versionLine"
    }

    return [pscustomobject]@{
        CMake = $cmakePath
        CMakeVersion = $versionLine
        VcpkgRoot = $vcpkgRoot
    }
}

function Get-LanguageList {
    $poDirectory = Join-Path $script:SourceRoot 'lang\po'
    if (-not (Test-Path -LiteralPath $poDirectory -PathType Container)) {
        return ''
    }
    $languages = Get-ChildItem -LiteralPath $poDirectory -Filter '*.po' -File |
        Where-Object { $_.BaseName -ne 'placeholder' } |
        Sort-Object BaseName |
        Select-Object -ExpandProperty BaseName
    return $languages -join ';'
}

function Get-GettextPath {
    $command = Get-Command msgfmt.exe -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }
    $candidates = @(
        (Join-Path $env:LOCALAPPDATA 'Programs\gettext-iconv\bin\msgfmt.exe'),
        (Join-Path $env:ProgramFiles 'gettext-iconv\bin\msgfmt.exe'),
        (Join-Path ${env:ProgramFiles(x86)} 'gettext-iconv\bin\msgfmt.exe')
    )
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            return $candidate
        }
    }
    throw 'msgfmt.exe를 찾지 못했습니다. setup-build-tools.ps1을 먼저 실행하세요.'
}

function Get-PkgconfPath {
    $command = Get-Command pkgconf.exe -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }
    $installed = Get-ChildItem -LiteralPath $env:ProgramFiles -Directory `
        -Filter 'pkgconf*' -ErrorAction SilentlyContinue |
        ForEach-Object { Join-Path $_.FullName 'pkgconf.exe' } |
        Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } |
        Select-Object -First 1
    if ($installed) {
        return $installed
    }
    throw 'pkgconf.exe를 찾지 못했습니다. setup-build-tools.ps1을 먼저 실행하세요.'
}

function Set-ShaderToolEnvironment {
    $toolsRoot = Join-Path $script:CMakeRoot 'vcpkg_installed\x64-windows-static\tools'
    $glslang = Join-Path $toolsRoot 'glslang\glslangValidator.exe'
    $shadercross = Join-Path $toolsRoot 'sdl3-shadercross\shadercross.exe'
    foreach ($requiredPath in @($glslang, $shadercross)) {
        if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
            throw "vcpkg 셰이더 도구를 찾을 수 없습니다: $requiredPath"
        }
    }
    $env:GLSLANG = $glslang
    $env:SDL_SHADERCROSS = $shadercross
}

function Get-TestNames {
    param(
        [Parameter(Mandatory = $true)][string] $Executable,
        [switch] $IncludeHidden
    )

    $arguments = @()
    if ($IncludeHidden) {
        $arguments += '*'
    }
    $arguments += '--list-test-names-only'
    Push-Location -LiteralPath $script:SourceRoot
    try {
        $lines = @(& $Executable @arguments 2>$null)
    } finally {
        Pop-Location
    }
    $names = @($lines | Where-Object {
        $_ -and
        $_ -notmatch '^(All available|Matching) test cases:' -and
        $_ -notmatch '^\d+ (matching )?test cases?$'
    } | ForEach-Object { $_.ToString() })
    if ($names.Count -eq 0) {
        throw "테스트 이름을 열거하지 못했습니다: $Executable"
    }
    return $names
}

$script:RepositoryRoot = [IO.Path]::GetFullPath($PSScriptRoot)
$script:SourceRoot = Join-Path $script:RepositoryRoot 'cataclysm-dda'
$script:BuildRoot = Join-Path $script:RepositoryRoot 'build'
$script:CMakeRoot = Join-Path $script:BuildRoot 'cmake'
$recordsRoot = Join-Path $script:BuildRoot 'test-builds'

if (-not (Test-Path -LiteralPath (Join-Path $script:SourceRoot 'CMakeLists.txt') -PathType Leaf)) {
    throw "CDDA 소스 트리를 찾을 수 없습니다: $script:SourceRoot"
}
New-Item -ItemType Directory -Path $script:BuildRoot -Force | Out-Null
New-Item -ItemType Directory -Path $recordsRoot -Force | Out-Null

$tools = Get-BuildTools
$languages = Get-LanguageList
$gettextPath = Get-GettextPath
$pkgconfPath = Get-PkgconfPath
$env:VCPKG_ROOT = $tools.VcpkgRoot
$env:PKG_CONFIG = $pkgconfPath
$env:VCPKG_KEEP_ENV_VARS = 'PKG_CONFIG'

$configuration = [ordered]@{
    schema_version = 1
    preset = 'windows-tiles-sounds-x64-msvc'
    configuration = 'RelWithDebInfo'
    tests = $true
    use_home_dir = $true
    cmake = $tools.CMake
    cmake_version = $tools.CMakeVersion
    vcpkg_root = $tools.VcpkgRoot
    gettext = $gettextPath
    pkgconf = $pkgconfPath
    languages = $languages
    test_sources = @(Get-ChildItem -LiteralPath (Join-Path $script:SourceRoot 'tests') `
        -Filter '*.cpp' -File | Sort-Object Name | Select-Object -ExpandProperty Name)
}
$configurationJson = $configuration | ConvertTo-Json -Depth 5 -Compress
$configurationHash = Get-Sha256Text -Text $configurationJson
$configurationPath = Join-Path $script:CMakeRoot 'test-configuration.json'
$cachePath = Join-Path $script:CMakeRoot 'CMakeCache.txt'
$configure = -not (Test-Path -LiteralPath $cachePath -PathType Leaf)
if (-not $configure -and (Test-Path -LiteralPath $configurationPath -PathType Leaf)) {
    $priorConfiguration = Read-JsonFile -Path $configurationPath
    $configure = [string]$priorConfiguration.sha256 -ne $configurationHash
} elseif (-not $configure) {
    $configure = $true
}

if ($configure) {
    Invoke-Checked -Command $tools.CMake -Arguments @(
        '-S', $script:SourceRoot,
        '-B', $script:CMakeRoot,
        '--preset', 'windows-tiles-sounds-x64-msvc',
        '-DTESTS:BOOL=ON',
        '-DUSE_HOME_DIR:BOOL=ON',
        ('-DGETTEXT_MSGFMT_BINARY:FILEPATH={0}' -f $gettextPath),
        ('-DPKG_CONFIG_EXECUTABLE:FILEPATH={0}' -f $pkgconfPath),
        ('-DLANGUAGES:STRING={0}' -f $languages)
    )
    Write-JsonFile -Path $configurationPath -Value ([ordered]@{
        sha256 = $configurationHash
        configuration = $configuration
    })
}

Set-ShaderToolEnvironment
Invoke-Checked -Command $tools.CMake -Arguments @(
    '--build', $script:CMakeRoot,
    '--config', 'RelWithDebInfo',
    '--parallel',
    '--target', 'cata_test-tiles'
)

$testExecutable = Get-ChildItem -LiteralPath $script:CMakeRoot -Filter 'cata_test-tiles.exe' `
    -File -Recurse |
    Where-Object { $_.FullName -match '[\\/]RelWithDebInfo[\\/]' } |
    Select-Object -First 1
if (-not $testExecutable) {
    throw 'RelWithDebInfo cata_test-tiles.exe를 찾지 못했습니다.'
}

$regularNames = @(Get-TestNames -Executable $testExecutable.FullName)
$allNames = @(Get-TestNames -Executable $testExecutable.FullName -IncludeHidden)
$regularSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
foreach ($name in $regularNames) {
    if (-not $regularSet.Add($name)) {
        throw "중복 일반 테스트 이름이 있습니다: $name"
    }
}
$allSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
$tests = foreach ($name in $allNames) {
    if (-not $allSet.Add($name)) {
        throw "중복 테스트 이름이 있습니다: $name"
    }
    if ($name -match '[,\*\?\[\]~"\\]') {
        throw "Catch2 필터 문자가 들어간 테스트 이름은 지원하지 않습니다: $name"
    }
    [ordered]@{
        name = $name
        hidden = -not $regularSet.Contains($name)
    }
}
if ($regularNames.Count -eq 0 -or $allNames.Count -lt $regularNames.Count) {
    throw '테스트 목록 계수가 올바르지 않습니다.'
}

$source = Get-SourceFingerprint -SourceRoot $script:SourceRoot
$executableHash = Get-Sha256File -Path $testExecutable.FullName
$buildId = '{0}-{1}' -f [DateTime]::UtcNow.ToString('yyyyMMddTHHmmssfffZ'), $executableHash.Substring(0, 12)
$recordDirectory = Join-Path $recordsRoot $buildId
if (Test-Path -LiteralPath $recordDirectory) {
    throw "빌드 기록 디렉터리가 이미 있습니다: $recordDirectory"
}
New-Item -ItemType Directory -Path $recordDirectory | Out-Null
$recordPath = Join-Path $recordDirectory 'build.json'
$record = [ordered]@{
    schema_version = 1
    build_id = $buildId
    created_at = [DateTime]::UtcNow.ToString('o')
    repository_root = $script:RepositoryRoot
    source_root = $script:SourceRoot
    build_directory = $script:CMakeRoot
    preset = 'windows-tiles-sounds-x64-msvc'
    configuration = 'RelWithDebInfo'
    configuration_sha256 = $configurationHash
    source = $source
    executable = [ordered]@{
        path = $testExecutable.FullName
        bytes = $testExecutable.Length
        sha256 = $executableHash
    }
    regular_test_count = $regularNames.Count
    hidden_test_count = $allNames.Count - $regularNames.Count
    total_test_count = $allNames.Count
    tests = @($tests)
}
Write-JsonFile -Path $recordPath -Value $record

Write-Output 'BUILD: READY'
Write-Output "BUILD_RECORD: $recordPath"
