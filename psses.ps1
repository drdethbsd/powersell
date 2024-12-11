$path = "c:\users"
$path2 = "c:\intel\"
$Session = New-PSSession 192.168.11.154 -Credential TEST\Admin
$dir = Invoke-Command -Session $Session -ArgumentList $path, $path2 -ScriptBlock {Param($1,$2)Get-ChildItem $1;
New-Item -Path $2 -Name "test3" -ItemType Directory;}

$dir