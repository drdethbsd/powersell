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
$choice = Read-Host '������� "Y" ���� ������ ��������� ������������' $Session.UserName  "� �����: "
Write-Host	
	if(($choice -eq "y") -or ($choice -eq "Y"))
	{
	Invoke-RDUserLogoff -HostServer $Session.HostServer -UnifiedSessionID $Session.UnifiedSessionId -Force
	"������!"
	Write-Host
	}
	else{
	"������ �� �����������"
	Write-Host
	}
}
else{
"����� ������������ �� ������ �� �����"
Write-Host
}