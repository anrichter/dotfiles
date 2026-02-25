<#
.Description
Startet das Visual Studio Environment der aktuellsten Visual Studio Installation
#>
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
Sucht nach Visual Studio Solutions und zeigt eine Auswahl zum anschließenden Öffnen im Visual Studio an.
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

function script:add-windowtitle([string] $title) {
  if (!($Host.UI.RawUI.WindowTitle -match $title)) {
    $Host.UI.RawUI.WindowTitle += " | $title"
  }
}
