$ap1resourcegroups = Get-AzureRmResourceGroup | where resourcegroupname -like '*ap1*' | select -expand resourcegroupname

foreach ($ap1resourcegroup in $ap1resourcegroups) {
    $vms = get-azurermvm -ResourceGroupName $ap1resourcegroup

    foreach ($vm in $vms) {
       
        $availabilitysetreference = get-azurermvm -name $vm.name -ResourceGroupName $ap1resourcegroup | select -expand availabilitysetreference
       
       if ($availabilitysetreference)
       {
          
          $string = $availabilitysetreference.id.split("/")
          $availability_set_name = $string[-1]
       }

       $props = @{'Name' = $vm.name;
                  'Availability Set' = $availability_set_name
                 }

       $obj = New-Object -TypeName PSObject -Property $props
       #$obj.PSObject.TypeNames.Insert(0,'Art.SystemInfo')
       Write-Output $obj       
        
    }
}