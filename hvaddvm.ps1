param(
    [int]$vmncount,    #?????????? VM
    [String]$VMName   #?????? ????? VM
)
$templateVM = "E:\hyper-v\test\test\Virtual Hard Disks\1.vhdx"
$AddVMJobs = @()
$CopyJob = @()
#???????? ?? ?????????? ?????????
if(!$VMName){
    $VMName = "VMNAME"
}
if(!$vmncount){
    $vmncount = 1
}
#??????? VM
for ($i = 1; $i -le $vmncount){
   $VM = @{
   Name = $VMName+$i 
   MemoryStartupBytes = 2147483648
   Generation = 2
   NewVHDPath = "e:\hyper-v\$VMName$i\$VMName$i.vhdx"
   NewVHDSizeBytes = 1687091200
   BootDevice = "VHD"
   Path = "e:\hyper-v\$VMName$i"
   SwitchName = (Get-VMSwitch).Name
}
#???????? ??????(?????? ??????????, ? ?? ?? ????????) ? scriptblock
$AddVMjobs += start-job -scriptblock {param($param1) new-vm @param1} -argumentlist $vm | Get-Job | Receive-Job -Wait
#????????? ???? ???????? ????? ?? templateVM
$CopyJob += Start-Job -scriptblock {param($vm, $templateVM) Copy-Item -Destination $vm.NewVHDPath -Path $templateVM  } -argumentlist $vm, $templateVM | Get-Job
$i++
}
$CopyJob
$b = $CopyJob.count
$i=0
while($i -lt $b){
    Wait-Event -Timeout 2
    foreach($job in $CopyJob){
        if(($job.state -eq "Completed") -or ($job.state -eq "Failed")) {
        $i++
        }
    }
    Clear-Host
    "Copying VM: "
    Get-Job | where {$_.state -eq "Running"}
}
"All VM copied"

