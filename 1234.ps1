$Date = Get-Date
$PathToDate = Get-Date


if($Date.Month -eq 1 -and $Date.Day -eq 1)
{

	$PathToDate = $Date.addYears(-1)
	$PathToDate = $PathToDate.AddMonths(+11)
	MakeArchive2 $Date $Date
	MakeArchive2 $PathToDate $Date
}
elseif($Date.Day -eq 1)
{
	$PathToDate=$PathToDate.addMonths(-1)
	MakeArchive2 $Date $Date
	MakeArchive2 $PathToDate $Date
}

else{
	MakeArchive2 $Date $Date
}

function global:MakeArchive2 {
param (
		$Date,
		$DatePath
	)
	
	$PathDestination = "c:\intel\base\" #имя архива
	$PathToFolder = "c:\intel\base\" #что архивируем
	$PathToCopy = "c:\intel\arch\" #куда копировать архив
#как будет называтся архив
$dir_exist1 = Test-Path($PathDestination + $Date.Year.toString() + "\" + $Date.month.toString() + "\" + $Date.Day.toString())
if($dir_exist1 -eq $false){
	$dir = $PathDestination + $Date.Year.toString() + "\" + $Date.month.toString() + "\" + $Date.Day.toString() 
	New-Item -Path $dir -ItemType "directory"
}
$PathDestination = $PathDestination + $Date.Year.toString() + "\" + $Date.month.toString() + "\" + $Date.Day.toString() + "\" + $Date.Day.ToString() + ".rar"
#что архивируем
$PathToFolder = $PathToFolder + $Date.Year.toString() + "\" + $Date.month.toString()
cd "c:\Program Files\WinRAR\"
.\Rar.exe a -r -m5 $PathDestination $PathToFolder | Out-Null

$dir_exist = Test-Path($PathToCopy + $DatePath.Year.toString() + "\" + $DatePath.month.toString() + "\" + $DatePath.day.toString())

if($dir_exist -eq $false){
	$dir =  $PathToCopy + $Date.Year.toString() + "\" + $Date.month.toString() + "\" + $Date.day.toString() + "\"
	New-Item -Path $dir -ItemType "directory"
}

$PathToCopy = $PathToCopy + $DatePath.Year.toString() + "\" + $DatePath.month.toString() + "\" + $DatePath.day.toString() + "\" + $Date.Month.toString() + ".rar"

Move-Item -Path $PathDestination -Force -ErrorAction SilentlyContinue -Destination $PathToCopy
}