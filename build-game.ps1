#requires -Version 5.1

[CmdletBinding()]
param(
    [switch] $Clean
)

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
        throw "삭제 또는 교체 대상이 build 디렉터리 밖에 있습니다: $resolvedPath"
    }
}

function Remove-BuildChild {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    Assert-ChildPath -Path $Path -Parent $script:BuildRoot
    if (Test-Path -LiteralPath $Path) {
        Remove-Item -LiteralPath $Path -Recurse -Force
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
    $vcpkgPath = Join-Path $vcpkgRoot 'vcpkg.exe'
    foreach ($requiredPath in @($cmakePath, $vcpkgPath)) {
        if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
            throw "빌드 도구 파일을 찾을 수 없습니다: $requiredPath"
        }
    }

    $versionOutput = @(& $cmakePath --version)
    $cmakeExitCode = $LASTEXITCODE
    $versionLine = $versionOutput | Select-Object -First 1
    if ($cmakeExitCode -ne 0 -or $versionLine -notmatch '^cmake version (\d+)\.') {
        throw "CMake 버전을 판독할 수 없습니다: $versionLine"
    }
    if ([int]$Matches[1] -ge 4) {
        throw "CDDA의 현재 vcpkg 기준선은 CMake 4와 호환되지 않습니다: $versionLine"
    }

    return @{
        CMake = $cmakePath
        VcpkgRoot = $vcpkgRoot
        VisualStudio = $vsPath
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

function Copy-RuntimeFiles {
    param(
        [Parameter(Mandatory = $true)]
        [string] $StagePath
    )

    $executable = Get-ChildItem -LiteralPath $script:CMakeRoot -Filter 'cataclysm-tiles.exe' `
        -File -Recurse |
        Where-Object { $_.FullName -match '[\\/]RelWithDebInfo[\\/]' } |
        Select-Object -First 1
    if (-not $executable) {
        throw 'RelWithDebInfo cataclysm-tiles.exe를 CMake 산출물에서 찾지 못했습니다.'
    }

    Copy-Item -LiteralPath $executable.FullName -Destination $StagePath -Force
    Get-ChildItem -LiteralPath $executable.DirectoryName -Filter '*.dll' -File |
        Copy-Item -Destination $StagePath -Force
    Get-ChildItem -LiteralPath $executable.DirectoryName -Filter 'cataclysm-tiles*.pdb' -File |
        Copy-Item -Destination $StagePath -Force

    $copyright = Get-ChildItem -LiteralPath $script:CMakeRoot -Filter 'copyright' -File -Recurse |
        Where-Object { $_.FullName -match '[\\/]share[\\/]mpg123[\\/]copyright$' } |
        Select-Object -First 1
    if (-not $copyright) {
        throw 'mpg123 라이선스 파일을 찾지 못했습니다.'
    }
    Copy-Item -LiteralPath $copyright.FullName `
        -Destination (Join-Path $StagePath 'LICENSE-mpg123.txt') -Force
}

function Copy-GameData {
    param(
        [Parameter(Mandatory = $true)]
        [string] $StagePath,

        [string] $LanguageList
    )

    foreach ($directoryName in @('data', 'doc', 'gfx')) {
        $sourcePath = Join-Path $script:SourceRoot $directoryName
        if (-not (Test-Path -LiteralPath $sourcePath -PathType Container)) {
            throw "게임 데이터 디렉터리를 찾을 수 없습니다: $sourcePath"
        }
        Copy-Item -LiteralPath $sourcePath -Destination $StagePath -Recurse -Force
    }

    foreach ($fileName in @(
        'README.md', 'LICENSE.txt', 'LICENSE-OFL-Terminus-Font.txt', 'VERSION.txt'
    )) {
        $sourcePath = Join-Path $script:SourceRoot $fileName
        if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
            throw "배포 문서 파일을 찾을 수 없습니다: $sourcePath"
        }
        Copy-Item -LiteralPath $sourcePath -Destination $StagePath -Force
    }

    if ($LanguageList) {
        $localeDestination = Join-Path $StagePath 'lang\mo'
        New-Item -ItemType Directory -Path $localeDestination -Force | Out-Null
        foreach ($language in ($LanguageList -split ';')) {
            $localeSource = Join-Path $script:SourceRoot "lang\mo\$language"
            if (-not (Test-Path -LiteralPath $localeSource -PathType Container)) {
                throw "컴파일된 번역 디렉터리를 찾을 수 없습니다: $localeSource"
            }
            Copy-Item -LiteralPath $localeSource -Destination $localeDestination `
                -Recurse -Force
        }
    }
}

$script:RepositoryRoot = [IO.Path]::GetFullPath($PSScriptRoot)
$script:SourceRoot = Join-Path $script:RepositoryRoot 'cataclysm-dda'
$script:BuildRoot = Join-Path $script:RepositoryRoot 'build'
$script:CMakeRoot = Join-Path $script:BuildRoot 'cmake'
$gameRoot = Join-Path $script:BuildRoot 'game'
$saveRoot = Join-Path $script:BuildRoot 'save'
$stageRoot = Join-Path $script:BuildRoot ('.game-stage-{0}' -f $PID)
$backupRoot = Join-Path $script:BuildRoot ('.game-backup-{0}' -f $PID)

$cmakeLists = Join-Path $script:SourceRoot 'CMakeLists.txt'
if (-not (Test-Path -LiteralPath $cmakeLists -PathType Leaf)) {
    throw "CDDA 소스 트리를 찾을 수 없습니다: $cmakeLists"
}

New-Item -ItemType Directory -Path $script:BuildRoot -Force | Out-Null
if ($Clean) {
    Write-Host "CMake 중간 산출물을 삭제합니다: $script:CMakeRoot"
    Remove-BuildChild -Path $script:CMakeRoot
}
Remove-BuildChild -Path $stageRoot
Remove-BuildChild -Path $backupRoot

$tools = Get-BuildTools
$env:VCPKG_ROOT = $tools.VcpkgRoot
$languages = Get-LanguageList
$gettextPath = Get-GettextPath
$pkgconfPath = Get-PkgconfPath
$env:PKG_CONFIG = $pkgconfPath
$env:VCPKG_KEEP_ENV_VARS = 'PKG_CONFIG'
if ($languages) {
    Write-Host "포함할 번역: $($languages -replace ';', ', ')"
} else {
    Write-Warning 'cataclysm-dda\lang\po에 실제 번역 파일이 없습니다. 영어만 포함합니다.'
}
Write-Host "Visual Studio: $($tools.VisualStudio)"
Write-Host "CMake 산출물: $script:CMakeRoot"
Write-Host "게임 배포본: $gameRoot"
Write-Host "저장 파일: $saveRoot"

$configureArguments = @(
    '-S', $script:SourceRoot,
    '-B', $script:CMakeRoot,
    '--preset', 'windows-tiles-sounds-x64-msvc',
    '-DTESTS:BOOL=ON',
    '-DUSE_HOME_DIR:BOOL=ON',
    ('-DGETTEXT_MSGFMT_BINARY:FILEPATH={0}' -f $gettextPath),
    ('-DPKG_CONFIG_EXECUTABLE:FILEPATH={0}' -f $pkgconfPath),
    ('-DLANGUAGES:STRING={0}' -f $languages)
)
Invoke-Checked -Command $tools.CMake -Arguments $configureArguments
Set-ShaderToolEnvironment

$buildArguments = @(
    '--build', $script:CMakeRoot,
    '--config', 'RelWithDebInfo',
    '--parallel',
    '--target', 'cataclysm-tiles', 'locale', 'compile_shaders'
)
Invoke-Checked -Command $tools.CMake -Arguments $buildArguments

try {
    New-Item -ItemType Directory -Path $stageRoot -Force | Out-Null
    Copy-RuntimeFiles -StagePath $stageRoot
    Copy-GameData -StagePath $stageRoot -LanguageList $languages

    $launcher = @'
#requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]] $GameArguments
)

$ErrorActionPreference = 'Stop'
$gameDirectory = [IO.Path]::GetFullPath($PSScriptRoot)
$saveDirectory = [IO.Path]::GetFullPath((Join-Path $gameDirectory '..\save'))
$executable = Join-Path $gameDirectory 'cataclysm-tiles.exe'

if (-not (Test-Path -LiteralPath $executable -PathType Leaf)) {
    throw "게임 실행 파일을 찾을 수 없습니다: $executable"
}
New-Item -ItemType Directory -Path $saveDirectory -Force | Out-Null

Push-Location $gameDirectory
try {
    & $executable --userdir $saveDirectory @GameArguments
    exit $LASTEXITCODE
} finally {
    Pop-Location
}
'@
    Set-Content -LiteralPath (Join-Path $stageRoot 'run-game.ps1') `
        -Value $launcher -Encoding UTF8

    foreach ($requiredRelativePath in @(
        'cataclysm-tiles.exe', 'data', 'gfx', 'run-game.ps1', 'LICENSE-mpg123.txt'
    )) {
        $requiredPath = Join-Path $stageRoot $requiredRelativePath
        if (-not (Test-Path -LiteralPath $requiredPath)) {
            throw "배포본 검증에 실패했습니다. 항목이 없습니다: $requiredRelativePath"
        }
    }

    New-Item -ItemType Directory -Path $saveRoot -Force | Out-Null
    if (Test-Path -LiteralPath $gameRoot) {
        Move-Item -LiteralPath $gameRoot -Destination $backupRoot
    }
    try {
        Move-Item -LiteralPath $stageRoot -Destination $gameRoot
    } catch {
        if (Test-Path -LiteralPath $backupRoot) {
            Move-Item -LiteralPath $backupRoot -Destination $gameRoot
        }
        throw
    }
    Remove-BuildChild -Path $backupRoot
} finally {
    Remove-BuildChild -Path $stageRoot
}

Write-Host ''
Write-Host '게임 빌드와 배포를 완료했습니다.'
Write-Host "실행: & '$gameRoot\run-game.ps1'"
