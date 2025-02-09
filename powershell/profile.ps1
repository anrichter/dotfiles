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
  $installationPath = & "${vswhere}" -latest -property installationPath
  $displayName = & "${vswhere}" -latest -property displayName
  load-environment "${installationPath}\Common7\Tools\VsDevCmd.bat"
  Write-Host "${displayName} Environment loaded." -ForegroundColor Yellow
  add-windowtitle "${displayName}"
}

<#
.Description
Search for Visual Studio Solutions recursiveley and let you choose which to open in the latest Visual Studio.
#>
function Open-VisualStudioSolutions()
{
    param
    (
        [string] $rootFolder
    )

    if(-not $rootFolder)
    {
        $rootFolder=Get-Location;
    }

    $solutionsFound = Get-ChildItem -Path $rootFolder -Recurse -File -Filter '*.sln' | Select-Object -ExpandProperty FullName;
    $chosenSolutions = $solutionsFound | Out-GridView -OutputMode Multiple -Title "Choose Solutions to open";

    $chosenSolutions | ForEach-Object {
        Write-Host "Starte ""$_""";
        Invoke-Item -Path "$_";
    }
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
