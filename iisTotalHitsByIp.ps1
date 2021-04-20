<#
        .SYNOPSIS
        Creates a CSV file with total hit counts per client IP address.

        .DESCRIPTION
        Takes a path to an IIS Log file (UNC paths supported) and returns a CSV file with the total number of hits per client IP (c-ip).

        .PARAMETER logPath
        The path and filename of the IIS Log to parse. This is based on Log Parser 2.2 syntax. This is a mandatory parameter. 

        .PARAMETER resultsPath
        Path and filename for the resulting CSV file. Default value is .\results\totalHitsByIP.csv


        .EXAMPLE
        PS> .\iisTotalHitsByIp.ps1 -logPath \\computerName\iisLogFolder\u_ex21*.log
        
        .EXAMPLE
        PS> .\iisTotalHitsByIp.ps1 -logPath \\computerName\iisLogFolder\u_ex210419.log

        .EXAMPLE
        PS> .\iisTotalHitsByIp.ps1 -logPath "\\computerName1\iisLogFolder\u_ex210419.log,\\computerName2\iisLogFolder\u_ex210419.log,\\computerName3\iisLogFolder\u_ex210419.log"

    #>

Param
(
    
    [parameter(Mandatory=$true)][string]$logPath,  
    [parameter(Mandatory=$false)][string]$resultsPath = ".\results\totalHitsByIP.csv"

)

invoke-command -scriptblock {logparser "select REVERSEDNS(c-ip) as HOSTNAME, c-ip, count(c-ip) as requestCount into $resultsPath from $logPath where cs-uri-stem like '/%' group by c-ip order by count(c-ip) desc" -o:CSV -stats:OFF}