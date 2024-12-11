#https://gallery.technet.microsoft.com/scriptcenter/PowerShell-FTP-Client-db6fe0cb#content
Import-Module PSFTP

#создаем фтп-сессию
$user = "test"
$passwd = "test"
$secpasswd = ConvertTo-SecureString $passwd -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential ($user, $secpasswd)
$Server = "ftp://192.168.11.57"
Set-FTPConnection -Credentials $Credentials -Server $Server -Session ftpSes | Out-Null
$Session = Get-FTPConnection -Session ftpSes

#пути к локальным папкам
$LocalFolderUpload = "e:\ps\ftp\toftp"
$LocalFolderDownload = "e:\ps\ftp\withftp"

#пути на фтп
$FtpUpload = "/upload"
$FtpDownload = "/download"

#получаем список нужных файлов для копирования с фтп на пк
$data = Get-FTPChildItem -Session $ftpSes -Path $FtpDownload | where {$_.name -like "*.xml" } 
$data
#копируем нужные файлы с фтп на пк и удаляем их на фтп
if($data){
    foreach($item in $data){
        Get-FTPItem -Session $ftpSes -Path $item.fullName -LocalPath $LocalFolderDownload
        Remove-FTPItem -Session $ftpSes -Path $item.fullName
    }
}
#получаем список нужных файлов для копирования с фтп на пк
$data2 = Get-ChildItem -Path $LocalFolderUpload -Recurse | Where-Object { -not $_.PSIsContainer -and $_.name -like "*.xml" }
#загружаем нужные файлы с пк на фтп и удаляем их на пк
if ($data2) {
    foreach($item in $data2){
        $item | Add-FTPItem -Session ftpSes -Path $FtpUpload -Overwrite
        $item | Remove-Item
    }
    
}

