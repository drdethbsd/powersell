$Collections = @("RemoteCollection" , "ScrewCollection")
$Sessions = @()
[String]$Result = @()
$i=1
$username = Read-Host 'Enter username to logoff?'
#получаем все сеансы на всех колекциях
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
    Write-Host "Найдены следующие сеансы пользователя: "
    $Result
    $choice = Read-Host "Введите номер сессии для завершения от 1 до $SesLength, если хотите завершить все сеансы, то введите ""A"" "
    if (($choice -eq "a") -or ($choice -eq "A")) {
        foreach($Session in $Sessions){
            Invoke-RDUserLogoff -HostServer $Session.HostServer -UnifiedSessionID $Session.UnifiedSessionId -Force
        }
        }elseif (([int]$choice -gt 0) -and ([int]$choice -le $SesLength)) {
            Invoke-RDUserLogoff -HostServer $Sessions[[int]$choice-1].HostServer -UnifiedSessionID $Sessions[[int]$choice-1].UnifiedSessionId -Force 
        }else {Write-Host "Вы ввели неверное значение"}
    }else {Write-Host "Сеансы не обнаружены"}
