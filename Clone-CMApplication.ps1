## The following will clone an applicaiton and it's data a new application in the same Site and files in the same parent path. 
## Also creates the appropriate App Pool and assigns a service account to it.
Import-Module WebAdministration
$DBName = Read-Host "Enter DB Name e.g CMLive"

do {
    try {
        $Userinput = Read-Host "Enter Web Application Name you want to Clone"
	    $UserOutput = Get-Webapplication -name $UserInput
	}
    catch {
        $Null -ne $UserOutput
	}
}
until ($UserOutput)

$WebApp = Get-Webapplication -name $UserInput
Write-Host "Application Found. Details are" -foregroundcolor Yellow
$WebApp

## Copy WebApp Path
$Folder = get-item $WebApp.PhysicalPath
$SourceFiles= "$($Folder.FullName)"
$DestinationFolder = ($Folder.Parent.FullName+"\"+$Folder.Name+" - "+$DBName+"\")
Write-Host "Copying Application Directory to New path of $($DestinationFolder)" -foregroundcolor Yellow
Copy-item -path $SourceFiles -Destination $DestinationFolder -Recurse
Write-Host "Done." -ForegroundColor Green

## Webappname variable used to create app pool and application
$WebAppName = $UserInput+$DBName 

Write-host "Creating new App Pool $($WebAppName) and applying service Account credentials" -ForegroundColor Yellow
$Credentials = (Get-Credential -Message "Please enter the Login credentials including Domain Name").GetNetworkCredential()
$Username = $credentials.Domain + '\' + $credentials.UserName

$Pool = New-WebAppPool $WebAppName
Set-ItemProperty "IIS:\AppPools\$($Pool.name)\" -Name processmodel -value @{username=$Username;password=$credentials.Password;identitytype=3} 
Write-Host "Done." -ForegroundColor Green

Write-host "Creating New Web Application in the same site as the old one" -ForegroundColor Yellow
New-WebApplication -Name $WebAppName -site ($Webapp).GetParentElement().Attributes['name'].Value -physicalpath $DestinationFolder -ApplicationPool $Pool.Name
Write-Host "All Done!" -ForegroundColor Green