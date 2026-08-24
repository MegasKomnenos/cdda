#requires -Version 5.1

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

function Invoke-Checked {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Command,

        [Parameter(Mandatory = $true)]
        [string[]] $Arguments
    )

    Write-Host "> $Command $($Arguments -join ' ')"
    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "명령이 종료 코드 $LASTEXITCODE`(으`)로 실패했습니다: $Command"
    }
}

function Assert-ChildPath {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string] $Parent
    )

    $resolvedPath = [IO.Path]::GetFullPath($Path).TrimEnd('\', '/')
    $resolvedParent = [IO.Path]::GetFullPath($Parent).TrimEnd('\', '/')
    $prefix = $resolvedParent + [IO.Path]::DirectorySeparatorChar
    if (-not $resolvedPath.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "삭제 대상이 build 디렉터리 밖에 있습니다: $resolvedPath"
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
    if ($cmakeExitCode -ne 0 -or $versionLine -notmatch '^cmake version (\d+)\.' -or `
            [int]$Matches[1] -ge 4) {
        throw "지원하지 않는 CMake 버전입니다: $versionLine"
    }

    return @{
        CMake = $cmakePath
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
        Sort-Object -Property BaseName |
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
    param(
        [Parameter(Mandatory = $true)]
        [string] $CMakeRoot
    )

    $toolsRoot = Join-Path $CMakeRoot 'vcpkg_installed\x64-windows-static\tools'
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

$script:RepositoryRoot = [IO.Path]::GetFullPath($PSScriptRoot)
$script:SourceRoot = Join-Path $script:RepositoryRoot 'cataclysm-dda'
$script:BuildRoot = Join-Path $script:RepositoryRoot 'build'
$cmakeRoot = Join-Path $script:BuildRoot 'cmake'
$testUserRoot = Join-Path $script:BuildRoot 'test-user'
$testArtifactNames = @(
    'test_jsonl_rebase.jsonl',
    'test_trace_rotate.jsonl',
    'test_trace_rotate.jsonl.1',
    'test_trace_rotate.jsonl.2',
    'test_trace_rotate.jsonl.2.tmp'
)

$cmakeLists = Join-Path $script:SourceRoot 'CMakeLists.txt'
if (-not (Test-Path -LiteralPath $cmakeLists -PathType Leaf)) {
    throw "CDDA 소스 트리를 찾을 수 없습니다: $cmakeLists"
}
foreach ($artifactName in $testArtifactNames) {
    $artifactPath = Join-Path $script:SourceRoot $artifactName
    if (Test-Path -LiteralPath $artifactPath) {
        throw "테스트가 덮어쓸 기존 파일이 있습니다. 파일을 옮긴 뒤 다시 실행하세요: $artifactPath"
    }
}
New-Item -ItemType Directory -Path $script:BuildRoot -Force | Out-Null
Assert-ChildPath -Path $testUserRoot -Parent $script:BuildRoot
if (Test-Path -LiteralPath $testUserRoot) {
    Remove-Item -LiteralPath $testUserRoot -Recurse -Force
}

$tools = Get-BuildTools
$env:VCPKG_ROOT = $tools.VcpkgRoot
$languages = Get-LanguageList
$gettextPath = Get-GettextPath
$pkgconfPath = Get-PkgconfPath
$env:PKG_CONFIG = $pkgconfPath
$env:VCPKG_KEEP_ENV_VARS = 'PKG_CONFIG'

Invoke-Checked -Command $tools.CMake -Arguments @(
    '-S', $script:SourceRoot,
    '-B', $cmakeRoot,
    '--preset', 'windows-tiles-sounds-x64-msvc',
    '-DTESTS:BOOL=ON',
    '-DUSE_HOME_DIR:BOOL=ON',
    ('-DGETTEXT_MSGFMT_BINARY:FILEPATH={0}' -f $gettextPath),
    ('-DPKG_CONFIG_EXECUTABLE:FILEPATH={0}' -f $pkgconfPath),
    ('-DLANGUAGES:STRING={0}' -f $languages)
)
Set-ShaderToolEnvironment -CMakeRoot $cmakeRoot
Invoke-Checked -Command $tools.CMake -Arguments @(
    '--build', $cmakeRoot,
    '--config', 'RelWithDebInfo',
    '--parallel',
    '--target', 'cata_test-tiles'
)

$testExecutable = Get-ChildItem -LiteralPath $cmakeRoot -Filter 'cata_test-tiles.exe' `
    -File -Recurse |
    Where-Object { $_.FullName -match '[\\/]RelWithDebInfo[\\/]' } |
    Select-Object -First 1
if (-not $testExecutable) {
    throw 'RelWithDebInfo cata_test-tiles.exe를 찾지 못했습니다.'
}

$testSucceeded = $false
Push-Location $script:SourceRoot
try {
    Invoke-Checked -Command $testExecutable.FullName -Arguments @(
        '--rng-seed', 'time',
        '--user-dir', $testUserRoot
    )
    $testSucceeded = $true
} finally {
    Pop-Location
    $artifactDestination = Join-Path $testUserRoot 'source-artifacts'
    foreach ($artifactName in $testArtifactNames) {
        $artifactPath = Join-Path $script:SourceRoot $artifactName
        if (Test-Path -LiteralPath $artifactPath -PathType Leaf) {
            New-Item -ItemType Directory -Path $artifactDestination -Force | Out-Null
            Move-Item -LiteralPath $artifactPath -Destination $artifactDestination -Force
        }
    }
    if ($testSucceeded -and (Test-Path -LiteralPath $testUserRoot)) {
        Remove-Item -LiteralPath $testUserRoot -Recurse -Force
    }
}

Write-Host ''
Write-Host '전체 단위 테스트를 통과했습니다.'
