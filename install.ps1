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
      Move-Item $destination "$($destination).dotfile_save"
    }

    New-Item -ItemType SymbolicLink -Path $destination -Target $source
  }
}

function InstallDotFilesIn([string] $path) {
  $sourcePath = $dotfilePath + '\' + $path;
  foreach($file in Get-ChildItem -Exclude "vim" $sourcePath -Name) {
    InstallDotFile "$sourcePath\$file" "$HOME\.$file"
  }
}

function CreatePowerShellProfile {
  $psprofilePath = "$dotfilePath\powershell\profile.ps1"
  InstallDotFile $psprofilePath $PROFILE
}

InstallDotFilesIn "independent"
CreatePowerShellProfile
