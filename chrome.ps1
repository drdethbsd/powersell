$proc = Get-Process -Name "chrome"
if ($proc -ne $null) {
foreach($pro in $proc){
    Stop-Process -name $proc.name
}
}
    Start-Process "chrome.exe"
