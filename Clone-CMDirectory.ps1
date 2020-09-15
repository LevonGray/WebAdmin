Import-Module WebAdministration
do {
    try {
        $Sourceinput = Read-Host "Enter Web Application Name you want to get the data from"
	    $UserOutput1 = Get-Webapplication -name $SourceInput
	}
    catch {
        $Null -ne $UserOutput1
	}
}
until ($UserOutput1)


do {
    try {
        $Destinput = Read-Host "Enter Web Application Name you want to put the data into"
	    $UserOutput2 = Get-Webapplication -name $DestInput
	}
    catch {
        $Null -ne $UserOutput2
	}
}
until ($UserOutput2)

$Sourceapp = Get-Webapplication -name $SourceInput
$Destapp = Get-Webapplication -name $DestInput

Copy-item -path $Sourceapp.physicalpath -destination "$($Destapp.physicalpath)\" -Recurse -force


## Change config files
$SourceID = Read-Host "Enter DatasetID in Source e.g. CL"
$DestID = Read-Host "Enter DatasetID for Destination e.g. CL"

## CM Mobile and CM
## $File = Get-ChildItem $Webapp.PhysicalPath hprmServiceAPI.config

## WebDrawer and ServiceAPI
## $File = Get-ChildItem $Webapp.PhysicalPath hptrim.config

$Test = (Get-ChildItem $Webapp.PhysicalPath hprmserviceapi.config).fullname
if ($Test -ne $null){
	$File = Get-ChildItem $Webapp.PhysicalPath hprmServiceAPI.config
}
	$File = Get-ChildItem $Webapp.PhysicalPath hptrim.config

(get-content $File.fullname).Replace("$SourceID","$DestID") |Set-Content $File.FullName