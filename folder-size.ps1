param (
    [String]$Path,
    [String]$File
)
$Session = New-PSSession 192.168.11.154 -Credential TEST\Admin

$media = "*.a52", "*.aac", "*.ac3", "*.aiff", "*.au", "*.aup", "*.dts", "*.flac", "*.itdb", "*.itl", "*.m3u", "*.m4a", "*.m4b", "*.m4r", "*.mka", "*.mp1", "*.mp2", "*.mp3", "*.mpa", "*.nra", "*.ogg", "*.rm", "*.spx", "*.wav", "*.wma", "*.wmdb", "*.wpk", "*.wpl", "*.mp4", "*.mov", "*.avi", "*.mts", "*.flv", "*.mpg", "*.swf", "*.wmv", "*.fla"

$SubFolders = Invoke-Command -Session $Session -ScriptBlock {Get-ChildItem $Using:Path | where {$_.PSIsContainer -eq $true}}
[System.Collections.ArrayList]$Result = @()

#получаем размер всех каталогов в корневом каталоге
foreach($folder in $SubFolders){
    $SubFolderSize = Invoke-Command -Session $Session -ScriptBlock {((Get-ChildItem -Path $Using:folder.FullName -Recurse | Where-Object { -not $_.PSIsContainer } | Measure-Object -Property Length -Sum).Sum/1024)/1024}
    $Media_size = Invoke-Command -Session $Session -ScriptBlock {((Get-ChildItem -Path $Using:folder.FullName -Include $Using:media -Recurse | Where-Object { -not $_.PSIsContainer } | Measure-Object -Property Length -Sum).Sum/1024)/1024}
    $Result.Add((New-Object PsObject -Property @{Name = $folder.FullName ; Size = [double][Math]::Round($SubFolderSize , 2); Media =  [double][Math]::Round($Media_size , 2) })) | out-null   

}
$sort = "Name", "Size", "Media"
$Result | Sort-Object -Property Size -Descending | select $sort | Export-Csv $File -NoTypeInformation -Append -Delimiter ";"
Get-PSSession | Remove-PSSession