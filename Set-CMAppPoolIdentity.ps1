## This changes the username and password based on the credentials put in on the prompt for all app pools in Content Manager. 
## Make sure to put the username in the form Domain\Username
## Needs to be run on an IIS Web Server
## Created by Levon for Rowan 07/09/2020

Import-module webadministration
$Credentials = (Get-Credential -Message "Please enter the Login credentials including Domain Name").GetNetworkCredential()

## If you want to modify this script for different app pools do it based on the name filter below
$CM = get-childitem IIS:\AppPools\ | Where-Object {$_.name -like "CM*" -or $_.name -like "ContentManager*"}

$Username = $credentials.Domain + '\' + $credentials.UserName
foreach ($Pool in $CM) {
    Set-ItemProperty "IIS:\AppPools\$($Pool.name)\" -Name processmodel -value @{username=$Username;password=$credentials.Password;identitytype=3} 
}

