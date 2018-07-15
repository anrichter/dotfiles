#
# Script functions
#

function script:append-path([string] $path)
{
  if (-not [string]::IsNullOrEmpty($path))
  {
    if ((Test-Path $path) -and (-not $env:Path.contains($path)))
    {
      $env:Path = [string]::Format("{0};{1}", $env:Path, $path)
    }
  }
}

function script:prepend-path([string] $path)
{
  if (-not [string]::IsNullOrEmpty($path))
  {
    if ((Test-Path $path) -and (-not $env:Path.contains($path)))
    {
      $env:Path = [string]::Format("{0};{1}", $path, $env:Path)
    }
  }
}

function script:load-environment([string] $command) {
  foreach($_ in (cmd /c "`"$command`" & set")) {
    if ($_ -match '^([^=]+)=(.*)') {
      [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2])
    }
  }
}

function script:add-windowtitle([string] $title) {
  if (!($Host.UI.RawUI.WindowTitle -match $title)) {
    $Host.UI.RawUI.WindowTitle += " | $title"
  }
}

#
# Global Functions
#

function Start-VisualStudioEnvironment {
  $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
  $installationPath = & "${vswhere}" -property installationPath
  $displayName = & "${vswhere}" -property displayName
  load-environment "${installationPath}\Common7\Tools\VsDevCmd.bat"
  Write-Host "${displayName} Environment loaded." -ForegroundColor Yellow
  add-windowtitle "${displayName}"
}

function New-Gitignore ([string] $environment) {
  $source = "$HOME\.gitignores\$environment.gitignore"
  if (Test-Path $source) {
    Copy-Item $source .gitignore
  }
}

#
# Set PS Module Path
#

$invocation = (Get-Variable MyInvocation).Value
$directoryPath = Split-Path $invocation.MyCommand.Path
$modulesPath = $directorypath + "\Modules"
$currentPSModulePath = [Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
[Environment]::SetEnvironmentVariable("PSModulePath", $currentPSModulePath + ";" + $modulesPath)

#
# Path
#

append-path "${env:ProgramFiles(x86)}\vim\vim74"
append-path "${env:ProgramFiles}\Microsoft VS Code\bin"
append-path "${env:UserProfile}\bin"

#
# Git
#

append-path "${env:ProgramFiles}\Git\cmd"
append-path "${env:ProgramFiles}\Git\usr\bin"

# enable git logs with umlauts
[Environment]::SetEnvironmentVariable("LESSCHARSET", "UTF-8")

Import-Module $modulesPath\posh-git\src\posh-git.psd1

function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

#
# Get-ChildItemColors
#

Import-Module Get-ChildItemColor

Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ll Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope

#
# Chocolatey
#

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

#
# Aliases
#

Set-Alias vi vim
