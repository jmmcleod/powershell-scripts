#################################################################
# Powershell code to create a folder based on the time stamp
#################################################################
$path = "D:\JMM\" 
$folderName = "backup" + (Get-Date).tostring("ddMMyyyyhhss") 

#Check to see if the folder exists and create it if it doesn't
If(!(test-path ($path + $folderName)))
    {
        New-Item -ItemType Directory -Path $path -Name $folderName
    }
