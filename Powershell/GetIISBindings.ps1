Param
(
    [string]$Serverlist = ".\inputs\p2IisServers.txt", 
    [string]$WebreportPath = ".\results\p2IisBindingReport.txt"
)

$serverNames = Get-Content $Serverlist
Foreach($serverName in $serverNames)
    {
        
        if(Test-Connection -ComputerName $serverName -Count 1 -Quiet)
        {        
            Try
            {
                Out-File -append $WebreportPath -InputObject "***BEGIN***"
                Out-File -append $WebreportPath -InputObject $serverName
                Invoke-Command  -ComputerName $serverName { Import-Module WebAdministration; Get-ChildItem -path IIS:\Sites | Format-Table} | Out-File -append $WebreportPath
                Out-File -append $WebreportPath -InputObject "***END***"
            } # try
            
            Catch
            {
                Out-File -append $WebreportPath -InputObject "Failed to get IIS Bindings from $($serverName.toUpper()). $($_.Exception.message)"
            }#catch
        } # end if

        
   } # foreach
