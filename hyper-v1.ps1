

$vmname = "srv-"
$ExportPath = "E:\hyper-v\export\1\Virtual Machines\3172ED9E-B3D9-483D-839F-68C9ED63B167.vmcx"
if(!$NameComputer){
    $NameComputer = 'localhost'
}
$vmname = $vmname + (Get-Date).Day.ToString() + "-" + (Get-Date).Hour.ToString() + "-" + (Get-Date).Minute.ToString()
$MachinePath = "E:\hyper-v\$vmname"
"Strarting import $vmname в $MachinePath"
Import-VM -Path $ExportPath -VhdDestinationPath $MachinePath -VirtualMachinePath $MachinePath -Copy -GenerateNewId -ComputerName $NameComputer


#переименовываем машину
$machine = get-vm | select VMNAME,VMId | where {$_.VMName -eq "1"} 
$machine
$machine.VMName | Rename-VM -NewName $vmname
get-vm | select VMNAME,VMId

#меняем имя диска


$addhdd = Get-VHD -VMId $machine.VMId | Select Path
$hddpath = $addhdd.Path -replace "1.vhdx", "$vmname.vhdx"
Get-VHD -VMId $machine.VMId | Select Path | Rename-Item -NewName ($vmname + ".vhdx")
Remove-VMHardDiskDrive -VMName $vmname -ControllerType SCSI -ControllerLocation 0 -ControllerNumber 0

Add-VMHardDiskDrive -VMName $vmname -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 0 -Path $hddpath

Set-VMNetworkAdapter -VMName $vmname -DynamicMacAddress
