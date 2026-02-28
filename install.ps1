$scriptPath = $MyInvocation.MyCommand.Path
$dotfilePath = Split-Path $scriptPath
$installAll = $false

function CanInstall([string] $question) {
  if (!$installAll) {
    # $key = Read-Host "Dotfile $destination already exists. Overwrite it? [Y/n/a]"
    $key = Read-Host "$question [Y/n/a]"

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
  if (CanInstall "Dotfile $destination already exists. Overwrite it?") {
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

function InstallDependencies() {
  Write-Host "In order to use dotfiles in PowerShell you need to install some dependencies"
  
  if (CanInstall "Install Oh My Posh?") {
    winget install JanDeDobbeleer.OhMyPosh
  }
}

InstallDependencies
InstallDotFilesIn "independent"
CreatePowerShellProfile
