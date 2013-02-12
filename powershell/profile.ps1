#
# Script functions
#

function script:append-path([string] $path)
{
  if ( -not [string]::IsNullOrEmpty($path) )
  {
    if ( (Test-Path $path) -and ( -not $env:PATH.contains($path) ) )
    {
      $env:PATH += ';' + $path
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

function New-Gitignore ([string] $environment) {
  $source = "$HOME\.gitignores\$environment.gitignore"
  if (Test-Path $source) {
    Copy-Item $source .gitignore
  }
}

#
# Path
#

append-path "${env:ProgramFiles(x86)}\vim\vim73"
append-path "${env:ProgramFiles(x86)}\Git\cmd"
append-path "${env:ProgramFiles(x86)}\Git\bin"

#
# Posh-Git
#

Import-Module posh-git
Import-Module posh-svn

function prompt {
    $realLASTEXITCODE = $LASTEXITCODE
    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host($pwd) -nonewline

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Enable-GitColors

#
# Aliases
#

Set-Alias vi vim
