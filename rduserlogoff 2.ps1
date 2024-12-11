$Collections = @("RemoteCollection" , "ScrewCollection")
$Sessions = @()
[String]$Result = @()
$i=1
$username = Read-Host 'Enter username to logoff?'
#�������� ��� ������ �� ���� ���������
foreach($Collection in $Collections){
    $Session = Get-RDUserSession -CollectionName $Collection.toString() -ConnectionBroker rd-broker2.sp.local | where {$_.UserName -eq $username}
    foreach($Sessio in $Session){
    $Result += [System.Environment]::NewLine + $i.ToString() + " " + $Sessio.UserName.toString() + "     " + $Sessio.HostServer.toString()
    $i++
    }
   
    $Sessions +=$Session
}

$SesLength = $Sessions.Length
if($Sessions -ne $null) {
    Write-Host "������� ��������� ������ ������������: "
    $Result
    $choice = Read-Host "������� ����� ������ ��� ���������� �� 1 �� $SesLength, ���� ������ ��������� ��� ������, �� ������� ""A"" "
    if (($choice -eq "a") -or ($choice -eq "A")) {
        foreach($Session in $Sessions){
            Invoke-RDUserLogoff -HostServer $Session.HostServer -UnifiedSessionID $Session.UnifiedSessionId -Force
        }
        }elseif (([int]$choice -gt 0) -and ([int]$choice -le $SesLength)) {
            Invoke-RDUserLogoff -HostServer $Sessions[[int]$choice-1].HostServer -UnifiedSessionID $Sessions[[int]$choice-1].UnifiedSessionId -Force 
        }else {Write-Host "�� ����� �������� ��������"}
    }else {Write-Host "������ �� ����������"}
