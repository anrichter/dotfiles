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

$profileFileInfo = Get-Item -Path $PROFILE
$dotfileSourcePath = Split-Path -Path $profileFileInfo.Target -Parent
$modulesPath = $dotfileSourcePath + "\Modules"
$currentPSModulePath = [Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
[Environment]::SetEnvironmentVariable("PSModulePath", $currentPSModulePath + ";" + $modulesPath)

#
# Path
#

append-path "${env:UserProfile}\bin"
append-path "${env:UserProfile}\bin\JetBrains.ReSharper.CommandLineTools"
append-path "${env:ProgramFiles(x86)}\GnuWin32\bin"
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

#
# Get-ChildItemColors
#

Import-Module $modulesPath\Get-ChildItemColor\src\Get-ChildItemColor.psd1

#
# anrichter-posh
#

Import-Module $modulesPath\anrichter-posh\anrichter-posh.psd1

#
# Aliases
#

Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ll Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope

#
# Import local Profile 
# 

$localProfile = $PROFILE.Replace('.ps1', '.local.ps1')
if (Test-Path $localProfile)
{
  . $localProfile
}

#
# Oh-My-Posh
#

oh-my-posh init pwsh --config "$HOME/.anrichter.omp.json" | Invoke-Expression
