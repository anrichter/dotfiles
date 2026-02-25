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
append-path "${env:UserProfile}\bin\JetBrains.ReSharper.CommandLineTools"

#
# Git
#

append-path "${env:ProgramFiles}\Git\cmd"
append-path "${env:ProgramFiles}\Git\usr\bin"

#
# Git in local AppData
#

append-path "${env:LOCALAPPDATA}\Programs\Git\cmd"
append-path "${env:LOCALAPPDATA}\Programs\Git\usr\bin"

# enable git logs with umlauts
[Environment]::SetEnvironmentVariable("LESSCHARSET", "UTF-8")

Import-Module $modulesPath\posh-git\src\posh-git.psd1
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $false

#
# Get-ChildItemColors
#

Import-Module $modulesPath\Get-ChildItemColor\src\Get-ChildItemColor.psd1

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
# anrichter-posh
#

Import-Module $modulesPath\anrichter-posh\anrichter-posh.psd1

#
# Aliases
#

Set-Alias vi vim
