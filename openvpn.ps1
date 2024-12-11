#получаем каталоги пользователей
$Users = Get-ChildItem "C:\Users\" | where { $_.PSIsContainer -eq $true -and $_.Name -ne "Public"} | Select name -ExpandProperty Name
$Users

#формируем пути поиска *.ovpn файлов
$Paths = @()
foreach ($user in $Users) {
    $Paths += "C:\Users\" + $user + "\OpenVPN\config"

}
$Paths += "C:\Program Files\OpenVPN\config"
$Paths

#формируем список найденных файлов для редактирования
$Files = @()

foreach ($path in $Paths){
    $modpath = $path + "\*"
    if(Test-Path $modpath -Include "*.ovpn"){
        $File = Get-ChildItem -Path $path -Include "*.ovpn" -Recurse -Force -ErrorAction SilentlyContinue
        $Files += $File.FullName
    }
}
$Files

#редактируем найденные файлы файлы

foreach ($file in $Files){
    (Get-Content $file) | where {$_ -ne "ncp-ciphers AES-128-GCM" } | set-content $file
}
