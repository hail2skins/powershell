$vms = Get-AzureRmVM | where location -eq 'eastasia'

    foreach ($vm in $vms) {
       
       $reference = get-azurermvm -name $vm.name -ResourceGroupName $vm.ResourceGroupName 
       
       if ($reference.availabilitysetreference)
       {
          
          $array = $reference.availabilitysetreference.id.split("/")
          $availability_set_name = $array[-1]
       }
       else
       {
           $availability_set_name = "NULL"
       }

       if ($reference.StorageProfile.ImageReference)
       {
            $ostype = $reference.StorageProfile.ImageReference.offer
            $osversion = $reference.StorageProfile.ImageReference.sku
       }
       else
       {
            $ostype = $reference.StorageProfile.osdisk.ostype
            $osversion = "NULL"
       }

       if ($reference.diagnosticsprofile.BootDiagnostics.StorageUri)
       {
            $storage = $reference.diagnosticsprofile.BootDiagnostics.StorageUri
       }
       else
       {
            $storage = "NULL"
       }

       $networkinterfacearray = $vm.NetworkInterfaceIDs.split('/')
       $networkinterfacename = $networkinterfacearray[-1]
       $networkreference = get-azurermnetworkinterface -name $networkinterfacename -resourcegroupname $vm.ResourceGroupName

       $ip = $networkreference.ipconfigurations.privateipaddress
       $subnetcompare = $networkreference.ipconfigurations.subnet.id
       $subnetarray = $networkreference.ipconfigurations.subnet.id.split("/")
       $subnet = $subnetarray[-1]

       $nsgreference = get-azurermnetworksecuritygroup | where {$_.subnets.id -contains $subnetcompare}
       $nsg = $nsgreference.Name
       $nsgresourcegroup = $nsgreference.ResourceGroupName
       
       
       #below two are broken
       #$nsgarray = $networkreference.NetworkSecurityGroup.id.split("/")
       #$nsg = $nsgarray[-1]


       $vmsize = $reference.HardwareProfile.vmsize

       $props = @{'Name' = $vm.name;
                  'ResourceGroup' = $vm.resourcegroupname;
                  'AvailabilitySet' = $availability_set_name;
                  'OS' = $ostype;
                  'VMSize' = $vmsize;
                  'OSVersion' = $osversion;
                  'Storage' = $storage;
                  'IP' = $ip;
                  'Subnet' = $subnet;
                  'NSG' = $nsg;
                  'NSGResourceGroup' = $nsgresourcegroup
                 }

       $obj = New-Object -TypeName PSObject -Property $props
       #$obj.PSObject.TypeNames.Insert(0,'Art.SystemInfo')
       export-csv -InputObject $obj -path c:\github\scripts\apacazure.csv -append
       write-host $obj 
    }