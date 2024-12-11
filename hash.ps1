$Paths = "C:\stage1.exe", "C:\stage2.exe", "C:\PerfLogs\stage1.exe", "C:\PerfLogs\stage2.exe", "C:\ProgramData\stage1.exe", "C:\ProgramData\stage2.exe", "C:\temp\stage1.exe", "C:\temp\stage2.exe"
foreach ($Path in $Paths){
    if(Test-Path -PathType Leaf -Path $Path){
        Remove-Item $Path -Force
    }
}

function set-ProcessPriority { 
    param($processName = $(throw "Enter process name"), $priority = "Normal")

    get-process -processname $processname | foreach { $_.PriorityClass = $priority }
    write-host "`"$($processName)`"'s priority is set to `"$($priority)`""
}
set-ProcessPriority powershell "Idle"

$Files = Get-ChildItem -Path 'C:\' -Include "*.exe" -Recurse -ErrorAction SilentlyContinue | Get-FileHash | where { $_.Hash -eq  "a196c6b8ffcb97ffb276d04f354696e2391311db3841ae16c8c9f56f36a38e92" -or $_.Hash -eq "dcbbae5a1c61dbbbb7dcd6dc5dd1eb1169f5329958d38b58c3fd9384081c9b78"}
$Files | Remove-Item -Force

$infofile = "c:\soft\compinfo.txt"
if(Test-Path $infofile -PathType leaf){
        Remove-Item $infofile
    }
if($Files.count -gt 0){
        $compname = Get-WmiObject -Class Win32_ComputerSystem -ComputerName 127.0.0.1
        "Компьютер: " + $compname.Name | Add-Content $infofile 

        $ipaddress = Get-NetIPAddress | where -Property IPAddress -Like "*192.168.*" | Select-Object -Property IPAddress
        "IP-адрес: " + $ipaddress.IPAddress | Add-Content $infofile

        $macaddress = Get-NetAdapter | where -Property Status -Like "Up" | Select-Object -Property MacAddress
        "MAC-адрес " + $macaddress.MacAddress | Add-Content $infofile

        "Найдены файлы: " | Add-Content $infofile
        $Files.Path | Add-Content $infofile

        $Pwd = "76492d1116743f0423413b16050a5345MgB8AHIAaQAxADUAawBwAGIAcAA1AEkAUwBmAGMAZAAwAEUAcQAwAFIATABmAEEAPQA9AHwAZAAzAGMAYQA5ADYAYwAwADMANAA3ADIAMgBhADQANwAzAGMAYgAzADIANgA0ADAAYQAwADUAOQA3ADYANwBmAGIAYgBlADIANABjADEAMwBkAGQAYQBhAGQAZgAyADYAYgAyADMANwBiADgAYwAyADYAMgA1ADMAMwA2AGMAMQA="
        [Byte[]] $key = (1,22,45,16,140,22,65,14,55,22,54,18,56,81,43,16)
        $serverSmtp = "mail.snackprod.com"
        $port = 587
        $From = "esetpuppet@snackprod.com"
        $CC = "voronao@snackprod.com, apomazan@snackprod.com, jilkiv@snackprod.com, govtvjan@snackprod.com, alkuznetsov@snackprod.com"
        $To = "ozerov@snackprod.com"
        $subject = "Обнаружены вредоносные файлы на " + $compname.Name
        $user = "esetpuppet"
        $pass = $Pwd | ConvertTo-SecureString -Key $key        
        $att = New-object Net.Mail.Attachment($infofile)
        $mes = New-Object System.Net.Mail.MailMessage
        $mes.From = $from
        $mes.To.Add($to)
        $mes.CC.Add($CC)
        $mes.Subject = $subject
        $mes.IsBodyHTML = $true
        $mes.Body = "<h1>Обнаружены потенциально вредоносные файлы на " + $compname.Name + " </h1> Необходимо принять меры на " + $compname.Name + " с IP адресом " + $ipaddress.IPAddress + " Дополнительная информация есть во вложении"
        $mes.Attachments.Add($att)
        $smtp = New-Object Net.Mail.SmtpClient($serverSmtp, $port)
        $smtp.EnableSSL = $true
        $smtp.Credentials = New-Object System.Net.NetworkCredential($user, $pass);
        $smtp.Send($mes) 
        $att.Dispose()

}