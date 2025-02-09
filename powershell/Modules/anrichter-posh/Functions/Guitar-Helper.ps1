<#
.Description
Startet eine Übesession
#>
function Start-GuitarPractice()
{
    # Überprüfen, ob Platform Nano angeschaltet ist
    $midiDevice = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Name -like "*PlatformNano*" }

    if ($midiDevice) {
        # Windows-Mobiltitätscenter starten
        Start-Process "mblctr.exe"

        # Präsentation einschalten
        Start-Process "PresentationSettings.exe" -ArgumentList "/start"

        # Reaper starten
        Start-Process "C:\Program Files\REAPER (x64)\reaper.exe"

        # Windows Uhr App starten
        Start-Process "explorer.exe" shell:appsfolder\Microsoft.WindowsAlarms_8wekyb3d8bbwe!App
        
    } else {
        Write-Output "Bitte erst Platform Nano anschließen."
    }
}
