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

function CreatePowerShellProfile {
  $psprofilePath = "$dotfilePath\powershell\profile.ps1"
  $dotProfile = ". $psprofilePath"

  if (!(Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE
  }

  $oldContent = Get-Content $PROFILE
  if (($oldContent -eq $null) -or !$oldContent.Contains($dotProfile)) {
    Set-Content -Path $PROFILE -Value "#"
    Add-Content -Path $PROFILE -Value "# Source profile.ps1 from dotfiles"
    Add-Content -Path $PROFILE -Value "#"
    Add-Content -Path $PROFILE -Value $dotProfile
    Add-Content -Path $PROFILE -Value ""
    Add-Content -Path $PROFILE -value $oldContent
  }
}

InstallDotFilesIn "independent"
InstallDotFilesIn "bash"
InstallDotFile "$dotfilePath\independent\vim" "$HOME\vimfiles"
CreatePowerShellProfile
InstallDotFile "$dotfilePath\gitignores" "$HOME\.gitignores"
