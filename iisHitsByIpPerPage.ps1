<#
        .SYNOPSIS
        Creates a CSV file with all page hit counts per client IP address.

        .DESCRIPTION
        Takes a path to an IIS Log file (UNC paths supported) and returns a CSV file with the page name and number of hits per client IP (c-ip).

        .PARAMETER logPath
        The path and filename of the IIS Log to parse. This is based on Log Parser 2.2 syntax. This is a mandatory parameter. 

        .PARAMETER resultsPath
        Path and filename for the resulting CSV file. Default value is .\results\pageHitsByIP.csv


        .EXAMPLE
        PS> .\iisHitsByIpPerPage.ps1 -logPath \\computerName\iisLogFolder\u_ex21*.log
        
        .EXAMPLE
        PS> .\iisHitsByIpPerPage.ps1 -logPath \\computerName\iisLogFolder\u_ex210419.log

    #>

Param
(
    
    [parameter(Mandatory=$true)][string]$logPath,  
    [parameter(Mandatory=$false)][string]$resultsPath = ".\results\pageHitsByIP.csv"

)

#Building a temp CSV to hold IPs that will be used later
invoke-command -scriptblock {logparser "select REVERSEDNS(c-ip) as HOSTNAME, c-ip, count(c-ip) as requestCount into .\tmpIPs.csv from $logPath where cs-uri-stem like '/%' group by c-ip order by count(c-ip) desc" -o:CSV -stats:OFF}

#Building the CSV with the final result set.
$clientMachines = Import-Csv ".\tmpIPs.csv"
ForEach ($client in $clientMachines) 
{
    $hostname = $($client.HOSTNAME)
    $cip = $($client.'c-ip')
    
    #assuming that we're only interested in IPv4 addresses
    if ($cip -NotLike "::*")
    {
    #$cip
        Invoke-Command -ScriptBlock {logparser "select c-ip, cs-uri-stem, count(cs-uri-stem) from $logPath where c-ip='$cip' group by cs-uri-stem,c-ip order by count(cs-uri-stem) desc" -o:CSV -stats:OFF >> $resultsPath}
    }#if

}#ForEach

