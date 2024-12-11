$comp = Get-WsusComputer
$result = @()
$file = "C:\soft\findcomp.txt"
$updateserver = Get-WmiObject -Class Win32_ComputerSystem -ComputerName 127.0.0.1
$password = '76492d1116743f0423413b16050a5345MgB8AEYARwB3AFQAWQBrAEYATgBCADEAcAB6AGQATABJAEMAMgBiAHUAWgBFAGcAPQA9AHwANQBlADcANAA4ADkAYgAzAGEAMwAyADYAOAA5ADMAZgAyAGUAYwBjADUANgBjAGMAYQA3ADQAZQAyADMAOQBhAGMAMAA1ADQAMgA4ADgANAA4ADcAMQBjADcANAA2ADMAMgA0ADYAOABkAGEANgAxADEANAA4AGMAMAAwAGMAYQA='
[Byte[]] $key = (1,22,45,16,140,22,65,14,55,22,54,18,56,81,43,16)
foreach($comps in $comp) {
    if($comps.FullDomainName -like "*95561*") {
      $result += $comps
    }
}

if($result.Count -gt 0){
        $result | Out-String | Set-Content $file
        #отправляем письма счастья
        $serverSmtp = "mail.snackprod.com"
        $port = 587
        $From = "esetpuppet@snackprod.com"
        $To = "voronao@snackprod.com"
        $CC = "snowman@snackprod.com"
        $subject = "Искомый комп найден на " + $updateserver.Name
        $user = "esetpuppet"
        $pass = $password | ConvertTo-SecureString -Key $key        
        $att = New-object Net.Mail.Attachment($file)
        $mes = New-Object System.Net.Mail.MailMessage
        $mes.From = $from
        $mes.To.Add($to)
        $mes.CC.Add($CC)
        $mes.Subject = $subject
        $mes.IsBodyHTML = $true
        $mes.Body = "<h1>Нашелся голубчик</h1> Дополнительная информация есть во вложении"
        $mes.Attachments.Add($att)
        $smtp = New-Object Net.Mail.SmtpClient($serverSmtp, $port)
        $smtp.EnableSSL = $true
        $smtp.Credentials = New-Object System.Net.NetworkCredential($user, $pass)
        $smtp.Send($mes) 
        $att.Dispose()
    }
