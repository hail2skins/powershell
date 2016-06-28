$ap1resourcegroups = Get-AzureRmResourceGroup | where resourcegroupname -like '*ap1*' | select -expand resourcegroupname

foreach ($ap1resourcegroup in $ap1resourcegroups) {
    $vms = get-azurermvm -ResourceGroupName $ap1resourcegroup

    foreach ($vm in $vms) {
       
       $reference = get-azurermvm -name $vm.name -ResourceGroupName $ap1resourcegroup 
       
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

       $vmsize = $reference.HardwareProfile.vmsize

       $props = @{'Name' = $vm.name;
                  'Resource Group' = $vm.resourcegroupname;
                  'Availability Set' = $availability_set_name;
                  'OS' = $ostype;
                  'VM Size' = $vmsize;
                  'OS Version' = $osversion
                 }

       $obj = New-Object -TypeName PSObject -Property $props
       #$obj.PSObject.TypeNames.Insert(0,'Art.SystemInfo')
       export-csv -InputObject $obj -path c:\github\scripts\apacazure.csv -append
    }
}