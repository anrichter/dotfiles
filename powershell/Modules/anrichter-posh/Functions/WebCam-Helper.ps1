function Get-WebCams()
{
    ffmpeg -list_devices true -f dshow -i dummy -hide_banner
}

function Get-WebCamSettings(
    # Name der einzustellenden WebCam
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]
    $webCamName)
{
    ffmpeg -f dshow -show_video_device_dialog true -i video="$webCamName"
}
