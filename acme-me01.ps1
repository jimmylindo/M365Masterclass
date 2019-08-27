$url = "https://deploymentimages.blob.core.windows.net/windows10/_W10REF1903.vhdx"
$output = "C:\VMS\Templates\W10REF.vhdx"
$start_time = Get-Date
Import-Module BitsTransfer
Start-BitsTransfer -Source $url -Destination $output
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

$url2 = "https://deploymentimages.blob.core.windows.net/windows10/module4-create-vm.ps1"
$output2 = "C:\VMS\Scripts\module4-create-vm.ps1"
$start_time = Get-Date
Import-Module BitsTransfer
Start-BitsTransfer -Source $url2 -Destination $output2
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

New-VMSwitch -Name "InternalNATSwitch" -SwitchType Internal
$NatSwitch = Get-NetAdapter -Name "vEthernet (InternalNATSwitch)"
New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex $NatSwitch.ifIndex
New-NetNat -Name MyNetwork -InternalIPInterfaceAddressPrefix 192.168.0.0/24

Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerV4Scope -Name "Nested VMs" -StartRange 192.168.0.11 -EndRange 192.168.0.254 -SubnetMask 255.255.255.0
Set-DhcpServerV4OptionValue -DnsServer 8.8.8.8 -Router 192.168.0.1