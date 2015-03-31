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

function Start-VisualStudio2013Environment {
  load-environment "${env:VS120COMNTOOLS}\VsDevCmd.bat"
  Write-Host "Visual Studio 2013 Environment Variables set." -ForegroundColor Yellow
  add-windowtitle "Visual Studio 2013"
}

function New-Gitignore ([string] $environment) {
  $source = "$HOME\.gitignores\$environment.gitignore"
  if (Test-Path $source) {
    Copy-Item $source .gitignore
  }
}

#
# Posh-Git
#

Import-Module posh-git

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
# Path
#

append-path "${env:ProgramFiles(x86)}\vim\vim74"
append-path "${env:ProgramFiles(x86)}\Git\cmd"
append-path "${env:ProgramFiles(x86)}\Git\bin"
append-path "${env:HOME}\bin"
append-path "${env:LocalAppPath}\atom\bin"
append-path "${env:LocalAppPath}\Pandoc"

#
# Aliases
#

Set-Alias vi vim
