$serverNames = Get-Content ".\inputs\p2IisServers.txt"
Foreach($serverName in $serverNames)
    {
        if(Test-Connection -ComputerName $serverName -Count 1 -Quiet)
        {
            Try
            {
                Write-host "$serverName"
            }#try
        
            Catch
            {
                Out-File -append $WebreportPath -InputObject "Failed to get IIS Bindings from $($serverName.toUpper()). $($_.Exception.message)"
            }#catch
        } # end if

        else
        {
            write-host "$serverName won't ping"
        } # end else
    } # end foreach