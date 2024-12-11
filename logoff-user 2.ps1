Import-Module RemoteDesktop
$username = Read-Host 'Enter username to logoff?'
Write-Host
$Session = Get-RDUserSession -CollectionName RemoteCollection -ConnectionBroker rd-broker2.sp.local | where {$_.UserName -eq $username}
if($Session -eq $null){
$Session = Get-RDUserSession -CollectionName ScrewCollection -ConnectionBroker rd-broker2.sp.local | where {$_.UserName -eq $username}
}
if(($Session -ne $null) -and ($Session.UserName -eq $username) )
{
Write-Host
$Session
Write-Host
$choice = Read-Host 'Введите "Y" если хотите выбросить пользователя' $Session.UserName  "с фермы: "
Write-Host	
	if(($choice -eq "y") -or ($choice -eq "Y"))
	{
	Invoke-RDUserLogoff -HostServer $Session.HostServer -UnifiedSessionID $Session.UnifiedSessionId -Force
	"Готово!"
	Write-Host
	}
	else{
	"Никого не выбрасываем"
	Write-Host
	}
}
else{
"Сеанс пользователя не найден на ферме"
Write-Host
}