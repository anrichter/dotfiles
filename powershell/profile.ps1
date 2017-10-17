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

function Start-VisualStudio2012Environment {
  load-environment "${env:VS110COMNTOOLS}\VsDevCmd.bat"
  Write-Host "Visual Studio 2012 Environment Variables set." -ForegroundColor Yellow
  add-windowtitle "Visual Studio 2012"
}

function Start-VisualStudio2013Environment {
  load-environment "${env:VS120COMNTOOLS}\VsDevCmd.bat"
  Write-Host "Visual Studio 2013 Environment Variables set." -ForegroundColor Yellow
  add-windowtitle "Visual Studio 2013"
}

function Start-VisualStudio2015Environment {
  load-environment "${env:VS140COMNTOOLS}\VsDevCmd.bat"
  Write-Host "Visual Studio 2015 Environment Variables set." -ForegroundColor Yellow
  add-windowtitle "Visual Studio 2015"
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

prepend-path "${env:UserProfile}\.dnx\bin"

append-path "${env:ProgramFiles(x86)}\vim\vim74"
append-path "${env:ProgramFiles}\Git\cmd"
append-path "${env:ProgramFiles}\Git\usr\bin"
append-path "${env:UserProfile}\bin"
append-path "${env:UserProfile}\bin\GitTfs"
append-path "${env:LocalAppData}\atom\bin"
append-path "${env:LocalAppData}\Code\bin"

#
# Posh-Git
#

Import-Module $modulesPath\posh-git\src\posh-git.psd1

function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

#
# Aliases
#

Set-Alias vi vim
