$scriptPath = $MyInvocation.MyCommand.Path
$dotfilePath = Split-Path $scriptPath
$installAll = $false

function CanInstall([string] $path) {
  if ((!$installAll) -and (Test-Path $path)) {
    $key = Read-Host "Dotfile $destination already exists. Overwrite it? [Y/n/a]"

    if ($key -eq "n") {
      return $false
    }
    if ($key -eq "a") {
      $script:installAll = $true
    }
  }
  return $true
}

function InstallDotFile([string] $source, [string] $destination) {
  if (CanInstall $destination) {
    Write-Host "Install dotfile $destination"
    if (Test-Path $destination) {
      Remove-Item $destination -Recurse
    }
    Copy-Item $source $destination -Recurse
  }
}

function InstallDotFilesIn([string] $path) {
  $sourcePath = $dotfilePath + '\' + $path;
  foreach($file in Get-ChildItem -Exclude "vim" $sourcePath -Name) {
    InstallDotFile "$sourcePath\$file" "$HOME\.$file"
  }
}

function InstallPowerShellFiles {
  $psfilePath = "$dotfilePath\powershell"
  $psmodulesPath = "$psfilePath\Modules"
  $psmodulesDestPath = Split-Path $PROFILE
  $psmodulesDestPath += "\Modules"

  if (!(Test-Path $psmodulesDestPath -PathType Container)) {
    New-Item $psmodulesDestPath -ItemType Container
  }

  InstallDotFile "$psfilePath\profile.ps1" "$PROFILE"

  foreach($module in Get-ChildItem "$psmodulesPath" -Name)
  {
    InstallDotFile "$psmodulesPath\$module" "$psmodulesDestPath\$module"
  }
}

InstallDotFilesIn "independent"
InstallDotFilesIn "bash"
InstallDotFile "$dotfilePath\independent\vim" "$HOME\vimfiles"
InstallPowerShellFiles
InstallDotFile "$dotfilePath\gitignores" "$HOME\.gitignores"
