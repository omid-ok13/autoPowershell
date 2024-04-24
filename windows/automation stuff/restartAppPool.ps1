### Recycle Web application Pool and Restart a service ###
$websiteName = "testv2"




## to recycle all application pools
#Write-Host "App Pool Recycling Started...."
#& $env:windir\system32\inetsrv\appcmd list apppools /state:Started /xml | & $env:windir\system32\inetsrv\appcmd recycle apppools /in 
#Write-Host "App Pool Recycling Completed"

## to restart application pool with website name
#Restart-WebAppPool (Get-Website -Name $websiteName).applicationPool
Restart-WebAppPool $websiteName





##########################################################################################################
## to restart a service uncomment following commands
#$serviceName = "W3SVC"
#Restart-Service $serviceName
##########################################################################################################