$serverNames = Get-Content ".\inputs\iisServers.txt"
$WebreportPath = ".\results\iisBindingReport.txt"
Foreach($serverName in $serverNames)
    {
        Try
        {
            Out-File -append $WebreportPath -InputObject "***BEGIN***"
            Out-File -append $WebreportPath -InputObject $serverName
            Invoke-Command  -ComputerName $serverName { Import-Module WebAdministration; Get-ChildItem -path IIS:\Sites | Format-Table} | Out-File -append $WebreportPath
            Out-File -append $WebreportPath -InputObject "***END***"
        }#try
        
        Catch
        {
            Out-File -append $WebreportPath -InputObject "Failed to get IIS Bindings from $($serverName.toUpper()). $($_.Exception.message)"
        }#catch
        
   }#foreach
