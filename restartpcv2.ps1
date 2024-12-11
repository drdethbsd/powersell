#если компьютер не перезагружался 10 дней и более
$daysCount = (get-date) – (gcim Win32_OperatingSystem).LastBootUpTime

if($daysCount.Days -ge 10){
# если существует файл с датой перезагрузки то переходим часть отвечающую за проверку времени перезагрузки    
    if(!(Test-Path -PathType Leaf -Path "C:\soft\restartpc\date.txt")){
# если такого файла нет и комп. не перезагружался более 10 дней то создаем задание на перезагрузку и информируем пользователя давая выбор
# отложить перезагрузку или перезагрузиться сейчас
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        
        $form = New-Object System.Windows.Forms.Form
        $form.Size = New-Object System.Drawing.Size(500,200)
        $form.StartPosition = 'CenterScreen'
    
        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Location = New-Object System.Drawing.Point(20,110)
        $okButton.Size = New-Object System.Drawing.Size(130,40)     
        $okButton.Font = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Regular)
        $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
        

        $cancelButton = New-Object System.Windows.Forms.Button
        $cancelButton.Location = New-Object System.Drawing.Point(340,110)
        $cancelButton.Size = New-Object System.Drawing.Size(130,40)
        $cancelButton.Font = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Regular)
        $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        

        $restartButton = New-Object System.Windows.Forms.Button
        $restartButton.Location = New-Object System.Drawing.Point(180,110)
        $restartButton.Size = New-Object System.Drawing.Size(130,40)
        $restartButton.Font = New-Object System.Drawing.Font("Arial",10,[System.Drawing.FontStyle]::Regular)
        $restartButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes
        

        $label = New-Object System.Windows.Forms.Label
        $label.Location = New-Object System.Drawing.Point(30,20)
        $label.Size = New-Object System.Drawing.Size(460,80)
        $label.Font = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Regular)
        
        

######## в зависимости от языка системы выдаем сообщение
        $Lang = Get-Culture
        if($Lang.Name -eq "uk-UA"){
            $form.Text = 'Необхідно перезавантажити Ваш ПК '
            $okButton.Text = 'OK'
            $cancelButton.Text = 'Перенести на 2 години'
            $restartButton.Text = 'Перезавантажити зараз'
            $label.Text = 'Ваш комп''ютер буде перезавантажений через 1 годину. Ваш комп''ютер не перезавантажувався більше 10 днів. Для встановлення важливих оновлень він буде перезавантажений через 1 годину.'
        }
        else{
            $form.Text = 'Требуется перезагрузка компьютера'
            $okButton.Text = 'OK'
            $cancelButton.Text = 'Отложить на 2 часа'
            $restartButton.Text = 'Перезагрузить сейчас'
            $label.Text = 'Компьютер будет перезагружен через 1 час. Компьютер не перезагружался более 10 дней. Для установки важных обновлений через 1 час он будет перезагружен.'
        }
        $form.AcceptButton = $okButton
        $form.Controls.Add($okButton)
        $form.CancelButton = $cancelButton
        $form.Controls.Add($cancelButton)
        $form.AcceptButton = $restartButton
        $form.Controls.Add($restartButton)
        $form.Controls.Add($label)


        $form.Topmost = $true

    
        $cancleShutdown = "shutdown"
        $argcancelShutdown = @('/a')
        & $cancleShutdown $argcancelShutdown > $null 2>&1
        $restartDate = (Get-Date).AddHours(1) 
        $restartDate | Set-Content "c:\soft\restartpc\date.txt"
        $File = Get-Item "c:\soft\restartpc\date.txt" -Force
        $File.attributes = 'Hidden'
        $restart60mCMD = "shutdown"
        $ArgsCMD = @('/r', '/t', '3600')
        & $restart60mCMD $ArgsCMD
        


        $result = $form.ShowDialog()
#если пользователь нажал отложить на 2 часа - пересчитываем с момента запуска скрипта время + 2часа  (такое же поведение на закрытие окна)  
        if ($result -eq [System.Windows.Forms.DialogResult]::CANCEL)
        {
            $restartDate2 = $restartdate.AddHours(1) 
            $restartDate2 | Set-Content "c:\soft\restartpc\date.txt"
            $hold2h = [int]((($restartDate2 - (Get-Date)).TotalHours*60)*60)
            $File = Get-Item "c:\soft\restartpc\date.txt" -Force
            $File.attributes = 'Hidden'
            $cancleShutdown = "shutdown"
            $argcancelShutdown = @('/a')
            & $cancleShutdown $argcancelShutdown > $null 2>&1
            $restart120mCMD = "shutdown"
            $ArgsCMD = @('/r', '/t', $hold2h)
            & $restart120mCMD $ArgsCMD
         }   
#если пользователь нажал перезагрузить сейчас - перезагружаем немедленно       
        if ($result -eq [System.Windows.Forms.DialogResult]::YES)
        {
            $restartnowCMD = "shutdown"
            $ArgsCMD = @('/r', '/t', '0')
            if((Test-Path -PathType Leaf -Path "C:\soft\restartpc\date.txt")){
                Remove-Item "C:\soft\restartpc\date.txt" -Force
            }
            & $restartnowCMD $ArgsCMD
        }
    }else{
# получаем дату перезагрузки из файла и смотрим сколько времени прошло, если комп. напр. был в спящем режиме то коректируеться дата и ставиться новое задание
# для перезагрузки с пересчетеом времени и информируем пользователя
        $planeRestartDate = Get-Date -Date (Get-Content "C:\soft\restartpc\date.txt" -Force)
        $dateX = $planeRestartDate - (Get-Date)
        #если количество минут до перезагрузки больше 0 - значит время перезагрузки не пропущено
        if($dateX.TotalMinutes -gt 0){
            $minutes = [int]$dateX.TotalMinutes
            $cancleShutdown = "shutdown"
            $argcancelShutdown = @('/a')
            & $cancleShutdown $argcancelShutdown > $null 2>&1
            $restartdatexCMD = "shutdown"
            $ArgsCMD = @('/r', '/t', ($minutes * 60))
            & $restartdatexCMD $ArgsCMD
            $Lang = Get-Culture
            if($Lang.Name -eq "uk-UA"){
                "ДО ПЕРЕЗАВАНТАЖЕННЯ ЗАЛИШИЛОСЬ ХВИЛИН: " + $minutes + " ! Не забудьте зберегти відкриті файли!"
            }else{
                "ДО ПЕРЕЗАГРУЗКИ ОСТАЛОСЬ МИНУТ: " + $minutes + " ! Не забудьте сохранить открытые файлы!"
            }
#если время перезагрузки меньше 0 то комп. был в спящем режиме - соответственно время перезагрузки было проущено: перегружаем комп. через 2 минуты
#информируя пользователя
        }else{
            $cancleShutdown = "shutdown"
            $argcancelShutdown = @('/a')
            & $cancleShutdown $argcancelShutdown > $null 2>&1
            $restart2minCMD = "shutdown"
            $ArgsCMD = @('/r', '/t', '120')
            & $restart2minCMD $ArgsCMD
            $Lang = Get-Culture
            if($Lang.Name -eq "uk-UA"){
                "ЧАС ПЕРЕЗАВАНТАЖЕННЯ НАСТАВ. ПЕРЕЗАВАНТАЖЕННЯ БУДЕ ВИКОНАНО ЧЕРЕЗ 2 ХВ.! ЗБЕРЕЖІТЬ ВІДКРИТІ ФАЙЛИ!"
            }else{
                "ВРЕМЯ ДЛЯ ПЕРЕЗАГРУЗКИ НАСТУПИЛО. ПЕРЕЗАГРУЗКА ПРОИЗОЙДЕТ ЧЕРЕЗ 2 МИНУТЫ! СОХРАНИТЕ ОТКРЫТЫЕ ФАЙЛЫ!"
            }
            
            
        }
    }
    
 }else{
#если компьютер перезагружался в последние 10 дней - то просто проверяем есть ли файл с датой плановой перезагрузки и удаляем его    
    if((Test-Path -PathType Leaf -Path "C:\soft\restartpc\date.txt")){
        Remove-Item "C:\soft\restartpc\date.txt" -Force
    }
 }