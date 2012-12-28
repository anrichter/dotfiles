#
# append Path
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

append-path "${env:ProgramFiles(x86)}\vim\vim73"
append-path "${env:ProgramFiles(x86)}\Git\cmd"

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
