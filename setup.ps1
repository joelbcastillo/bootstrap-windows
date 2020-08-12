# Description: Boxstarter Script
# Author: Joel Castillo
# Developer settings for Windows + WSL

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
Write-Host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#------ Setting up Windows --------
executeScript "FileExplorerSettings.ps1";
executeScript "SystemConfiguration.ps1";
executeScript "DevTools.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "Docker.ps1";
executeScript "WSL.ps1";
executeScript "Browsers.ps1";

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula

# Join Computer to Domain
$computerName = Read-Host -Prompt 'Input your computer name'
$domain = Read-Host -Prompt "Enter Domain to Join"
$domainUser = Read-Host -Prompt "Enter the user with permission to join this computer to the domain (<domain>\<username>)"
$ouPath = Read-Host -Prompt "Enter OU Path"

Write-Host "The computer will be renamed to '$computerName' and will be joined to the $domain Domain (OU = $ouPath) using the account $domainUser"

Add-Computer -NewName $computerName -DomainName $domain -Credential $domain\$domainUser -OUPath "$ouPath" -Force -Restart
