cd "c:\Program Files\WinRAR\"
$CurrentDate = Get-Date
$PathDestination = "c:\intel\base\"
$PathToFolder = "c:\intel\base\"
$PathToCopy = "c:\intel\arch\"

if($CurrentDate.Month -eq 1 -and $CurrentDate.Day -eq 1)
{
#архивируем папку текущего мес€ца
$PathDestination = $PathDestination + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + ".rar"
$PathToFolder = $PathToFolder + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString()
.\Rar.exe a -r -m5 $PathDestination $PathToFolder
$dir_exist = Test-Path($PathToCopy + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + "\" + $CurrentDate.day.toString())
if($dir_exist -eq $false){
$dir =  $PathToCopy + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + "\" + $CurrentDate.day.toString()
New-Item -Path $dir -ItemType "directory"
}
$PathToCopy = $PathToCopy + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + "\" + $CurrentDate.Day.toString() + "\" + $CurrentDate.Day.toString() +".rar"

Move-Item -Path $PathDestination -Force -ErrorAction SilentlyContinue -Destination $PathToCopy
#сдвигаем дату и архивируем папку 12 мес€ца предыдущего года
$CurrentDate = $CurrentDate.AddYears(-1)
$CurrentDate = $CurrentDate.AddMonths(11)
$PathDestination = $PathDestination + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + ".rar"
$PathToFolder = $PathToFolder + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString()
.\Rar.exe a -r -m5 $PathDestination $PathToFolder
Move-Item -Path $PathDestination -Force -ErrorAction SilentlyContinue -Destination $PathToCopy 
}
elseif($CurrentDate.Day -eq 1)
{
#архивируем папку текущего мес€ца
$PathDestination = $PathDestination + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + ".rar"
$PathToFolder = $PathToFolder + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString()
.\Rar.exe a -r -m5 $PathDestination $PathToFolder
$dir_exist = Test-Path($PathToCopy + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + "\" + $CurrentDate.day.toString())
if($dir_exist -eq $false){
$dir =  $PathToCopy + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + "\" + $CurrentDate.day.toString()
New-Item -Path $dir -ItemType "directory"
}
$PathToCopy = $PathToCopy + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + "\" + $CurrentDate.Day.toString() + "\" + $CurrentDate.Day.toString() +".rar"
Move-Item -Path $PathDestination -Force -ErrorAction SilentlyContinue -Destination $PathToCopy
#сдвигаем дату и архивируем папку предыдущего мес€ца
$CurrentDate = $CurrentDate.AddMonths(-1)
$PathDestination = $PathDestination + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + ".rar"
$PathToFolder = $PathToFolder + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString()
.\Rar.exe a -r -m5 $PathDestination $PathToFolder
Move-Item -Path $PathDestination -Force -ErrorAction SilentlyContinue -Destination $PathToCopy
}
else{
$PathDestination = $PathDestination + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + ".rar"
$PathToFolder = $PathToFolder + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString()
.\Rar.exe a -r -m5 $PathDestination $PathToFolder
$dir_exist = Test-Path($PathToCopy + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + "\" + $CurrentDate.day.toString())
if($dir_exist -eq $false){
$dir =  $PathToCopy + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + "\" + $CurrentDate.day.toString()
New-Item -Path $dir -ItemType "directory"
}
$PathToCopy = $PathToCopy + $CurrentDate.Year.toString() + "\" + $CurrentDate.month.toString() + "\" + $CurrentDate.Day.toString() + "\" + $CurrentDate.Day.toString() +".rar"

Move-Item -Path $PathDestination -Force -ErrorAction SilentlyContinue -Destination $PathToCopy
}