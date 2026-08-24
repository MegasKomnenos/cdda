#requires -Version 5.1

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Invoke-Winget {
    param(
        [Parameter(Mandatory = $true)]
        [string[]] $Arguments
    )

    & $script:WingetPath @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "winget 명령이 종료 코드 $LASTEXITCODE`(으`)로 실패했습니다: winget $($Arguments -join ' ')"
    }
}

function Test-WingetPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Id
    )

    $null = & $script:WingetPath list --id $Id --exact --source winget `
        --accept-source-agreements
    $exitCode = $LASTEXITCODE
    return $exitCode -eq 0
}

function Install-WingetPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Id,

        [string] $Override
    )

    if (Test-WingetPackage -Id $Id) {
        Write-Host "이미 설치됨: $Id"
        return
    }

    Write-Host "설치 중: $Id"
    $arguments = @(
        'install', '--id', $Id, '--exact', '--source', 'winget',
        '--accept-package-agreements', '--accept-source-agreements',
        '--disable-interactivity'
    )
    if ($Override) {
        $arguments += @('--override', $Override)
    }
    Invoke-Winget -Arguments $arguments
}

function Get-VswherePath {
    $candidate = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
    if (Test-Path -LiteralPath $candidate -PathType Leaf) {
        return $candidate
    }
    return $null
}

function Get-VisualStudio2022Path {
    param(
        [string] $VswherePath,
        [string[]] $RequiredComponents = @()
    )

    if (-not $VswherePath) {
        return $null
    }

    $arguments = @(
        '-products', '*', '-version', '[17.0,18.0)', '-latest',
        '-property', 'installationPath'
    )
    if ($RequiredComponents.Count -gt 0) {
        $arguments += '-requires'
        $arguments += $RequiredComponents
    }

    $paths = @(& $VswherePath @arguments)
    $exitCode = $LASTEXITCODE
    $path = $paths | Select-Object -First 1
    if ($exitCode -ne 0 -or -not $path) {
        return $null
    }
    return $path.Trim()
}

function Add-VisualStudioComponents {
    param(
        [Parameter(Mandatory = $true)]
        [string] $InstallationPath
    )

    $setupPath = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\setup.exe'
    if (-not (Test-Path -LiteralPath $setupPath -PathType Leaf)) {
        throw "Visual Studio Installer를 찾을 수 없습니다: $setupPath"
    }

    Write-Host "기존 Visual Studio 2022에 C++ 빌드 구성 요소를 추가합니다."
    $argumentLine = @(
        'modify',
        '--installPath', ('"{0}"' -f $InstallationPath),
        '--add', 'Microsoft.VisualStudio.Workload.NativeDesktop',
        '--includeRecommended',
        '--add', 'Microsoft.VisualStudio.Component.Vcpkg',
        '--quiet', '--wait', '--norestart'
    ) -join ' '

    $process = Start-Process -FilePath $setupPath -ArgumentList $argumentLine `
        -Wait -PassThru -WindowStyle Hidden
    if ($process.ExitCode -ne 0 -and $process.ExitCode -ne 3010) {
        throw "Visual Studio 구성 요소 설치가 종료 코드 $($process.ExitCode)`(으`)로 실패했습니다."
    }
    if ($process.ExitCode -eq 3010) {
        $script:RestartRequired = $true
    }
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
    return $null
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
    return $installed
}

if (-not (Test-Administrator)) {
    Write-Host '빌드 도구를 설치하려면 관리자 권한이 필요합니다. UAC 승인을 요청합니다.'
    $hostPath = (Get-Process -Id $PID).Path
    $argumentLine = '-NoProfile -ExecutionPolicy Bypass -File "{0}"' -f $PSCommandPath
    try {
        $process = Start-Process -FilePath $hostPath -Verb RunAs -ArgumentList $argumentLine `
            -Wait -PassThru -WindowStyle Hidden
    } catch {
        throw '관리자 권한 요청이 취소되었거나 실패했습니다.'
    }
    exit $process.ExitCode
}

$winget = Get-Command winget.exe -ErrorAction SilentlyContinue
if (-not $winget) {
    throw 'winget을 찾을 수 없습니다. Microsoft Store에서 App Installer를 설치한 뒤 다시 실행하세요.'
}
$script:WingetPath = $winget.Source
$script:RestartRequired = $false

$requiredComponents = @(
    'Microsoft.VisualStudio.Component.VC.Tools.x86.x64',
    'Microsoft.VisualStudio.Component.VC.CMake.Project',
    'Microsoft.VisualStudio.Component.Vcpkg'
)

$vswherePath = Get-VswherePath
$visualStudioPath = Get-VisualStudio2022Path -VswherePath $vswherePath
if (-not $visualStudioPath) {
    $buildToolsOverride = @(
        '--wait', '--quiet', '--norestart',
        '--add', 'Microsoft.VisualStudio.Workload.NativeDesktop',
        '--includeRecommended',
        '--add', 'Microsoft.VisualStudio.Component.Vcpkg'
    ) -join ' '
    Install-WingetPackage -Id 'Microsoft.VisualStudio.2022.BuildTools' `
        -Override $buildToolsOverride
    $vswherePath = Get-VswherePath
    $visualStudioPath = Get-VisualStudio2022Path -VswherePath $vswherePath
} elseif (-not (Get-VisualStudio2022Path -VswherePath $vswherePath `
        -RequiredComponents $requiredComponents)) {
    Add-VisualStudioComponents -InstallationPath $visualStudioPath
}

if (Get-Command git.exe -ErrorAction SilentlyContinue) {
    Write-Host '이미 설치됨: Git'
} else {
    Install-WingetPackage -Id 'Git.Git'
}
if (Get-GettextPath) {
    Write-Host '이미 설치됨: gettext'
} else {
    Install-WingetPackage -Id 'mlocati.GetText'
}
if (Get-PkgconfPath) {
    Write-Host '이미 설치됨: pkgconf'
} else {
    Install-WingetPackage -Id 'pkgconf.pkgconf'
}

$vswherePath = Get-VswherePath
$readyVisualStudioPath = Get-VisualStudio2022Path -VswherePath $vswherePath `
    -RequiredComponents $requiredComponents
if (-not $readyVisualStudioPath) {
    throw 'Visual Studio 2022 설치 후에도 필요한 MSVC, CMake 또는 vcpkg 구성 요소를 찾지 못했습니다.'
}

$cmakePath = Join-Path $readyVisualStudioPath `
    'Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe'
$vcpkgPath = Join-Path $readyVisualStudioPath 'VC\vcpkg\vcpkg.exe'
foreach ($requiredPath in @($cmakePath, $vcpkgPath)) {
    if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
        throw "설치 검증에 실패했습니다. 파일을 찾을 수 없습니다: $requiredPath"
    }
}
$gettextPath = Get-GettextPath
if (-not $gettextPath) {
    throw 'gettext 설치 후에도 msgfmt.exe를 찾지 못했습니다. 새 PowerShell을 열고 다시 실행하세요.'
}
$pkgconfPath = Get-PkgconfPath
if (-not $pkgconfPath) {
    throw 'pkgconf 설치 후에도 pkgconf.exe를 찾지 못했습니다.'
}

Write-Host ''
Write-Host 'CDDA 빌드 도구 설치를 확인했습니다.'
Write-Host "Visual Studio: $readyVisualStudioPath"
Write-Host "CMake: $cmakePath"
Write-Host "vcpkg: $vcpkgPath"
Write-Host "gettext: $gettextPath"
Write-Host "pkgconf: $pkgconfPath"
if ($script:RestartRequired) {
    Write-Warning 'Visual Studio Installer가 Windows 재시작이 필요하다고 보고했습니다. 작업을 저장한 뒤 직접 재시작하세요.'
}
