$Date = Get-Date
$PathToDate = Get-Date


if($Date.Month -eq 1 -and $Date.Day -eq 1)
{

	$PathToDate = $Date.addYears(-1)
	$PathToDate = $PathToDate.AddMonths(+11)
	c:\intel\MakeArchive2.ps1 $Date $Date
	c:\intel\MakeArchive2.ps1 $PathToDate $Date
}
elseif($Date.Day -eq 1)
{
	$PathToDate=$PathToDate.addMonths(-1)
	c:\intel\MakeArchive2.ps1 $Date $Date
	c:\intel\MakeArchive2.ps1 $PathToDate $Date
}

else{
	c:\intel\MakeArchive2.ps1 $Date $Date
}
