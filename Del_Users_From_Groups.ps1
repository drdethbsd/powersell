$Search = "OU=_Deleted,DC=sp,DC=local"
$Del_Users = Get-ADUser -SearchBase $Search -Filter * | Sort-Object  SamAccountName 
$PathTo = "U:\user_data\_deleted"
$ImportUsers = Get-ADUser -Filter {MemberOf -like "CN=Пользователи RDP-FARM,OU=Глобальные группы безопасности,DC=sp,DC=local"} -SearchBase "OU=Import,OU=wp,DC=sp,DC=local"

# Перемещение отключеных учеток в _Deleted 
Get-ADUser -SearchBase ‘OU=Users,OU=wp,DC=sp,DC=local’ -Filter {Enabled -eq "False"} | Move-ADObject -TargetPath "OU=_Deleted,DC=sp,DC=local"

# Перемещение из import в users
foreach ($ImportUser in $ImportUsers)
{
Get-ADUser $ImportUser |  Move-ADobject -TargetPath "OU=Users,OU=wp,DC=sp,DC=local"
}

# Перемещение уволенных пользователей в deleted
$Session = New-PSSession -ComputerName DFS-MAIN.sp.local
foreach ($Del_User in $Del_Users.SamAccountName)
{
$PathFrom = "U:\user_data\$Del_User"
Invoke-Command -Session $Session -ScriptBlock {Move-Item -Path $Using:PathFrom -Force -ErrorAction SilentlyContinue -Destination $Using:PathTo}
}
Get-PSSession | Remove-PSSession

# Удаление уволенных пользователей со всех групп
$ConfirmPreference = "None"
foreach ($Del_User in $Del_users)
{
$Group = Get-ADPrincipalGroupMembership -Identity $Del_User |
    Where {$_.SamAccountName -ne "Пользователи домена"} 
Remove-ADPrincipalGroupMembership -Identity $Del_User -MemberOf $Group  
}

# Локальное удаление на DFS-MAIN.sp.local
#$ADPath = "DC=sp, DC=local"
#$Deleted_Users = (Get-ADUser -Filter {Enabled -eq "False"} -SearchBase $ADPath | Select-Object SamAccountName | Sort-Object SamAccountName).SamAccountName
#foreach ($Deleted_User in $Deleted_Users)
#{
#Move-Item -Path "U:\user_data\$Deleted_User" -Force -ErrorAction SilentlyContinue -Destination "U:\user_data\_deleted"
#}