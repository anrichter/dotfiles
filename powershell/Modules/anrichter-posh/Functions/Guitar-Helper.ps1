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

<#
.Description
Startet eine Recording Session
#>
function Start-GuitarRecording()
{
    # Überprüfen, ob Platform Nano angeschaltet ist
    $midiDevice = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Name -like "*PlatformNano*" }

    if ($midiDevice) {
        Stop-ProcessIfRunning "thunderbird"
        Stop-ProcessIfRunning "firefox"
        
        # Windows-Mobiltitätscenter starten
        Start-Process "mblctr.exe"

        # Energiesparplan auf DAW setzen - powercfg /L
        powercfg /S 3c6e97a1-825c-44e4-a5cb-1d6da272e609

        # Präsentation einschalten
        Start-Process "PresentationSettings.exe" -ArgumentList "/start"

        # LoopMidi starten
        Start-Process "C:\Program Files (x86)\Tobias Erichsen\loopMIDI\loopMIDI.exe"
        WaitForProcessRunning "loopMIDI"

        # MIDI-OX starten
        Start-Process "C:\Program Files (x86)\MIDIOX\midiox.exe"
        WaitForProcessRunning "MIDIOX"

        # OBS starten
        Start-Process "C:\Program Files\obs-studio\bin\64bit\obs64.exe" -WorkingDirectory "C:\Program Files\obs-studio\bin\64bit"
        
        # Reaper starten
        Start-Process "C:\Program Files\REAPER (x64)\reaper.exe"

        # Warten, bis OBS gestartet ist und danach WebCam einstellen, da OBS die Einstellung verändert
        Start-Sleep -Seconds 5
        Push-Location "D:\Gitarre\Recording"
        Start-Process ".\WebCameraConfig.exe" -ArgumentList "--profile record"

    } else {
        Write-Output "Bitte erst Platform Nano anschließen."
    }
}

function script:Stop-ProcessIfRunning([string] $processname)
{
    $process = Get-Process -Name $processname -ErrorAction SilentlyContinue
    if ($process) {
        Stop-Process -Name $processname -Force
    }
}

function script:WaitForProcessRunning([string] $processname)
{
    $process = Get-Process -Name $processname -ErrorAction SilentlyContinue
    while (-not $process) {
        Start-Sleep -Seconds 1
        $process = Get-Process -Name $processname -ErrorAction SilentlyContinue
    }
}
