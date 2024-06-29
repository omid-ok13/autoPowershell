
###################################################################
# the path, that script would be run, (best the directory before source folder)
# please add a backslash (\) at the end of workPath 
$workPath = "C:\HostingSpaces\"
# name of source folder, it must be in $workPath directory 
$sourceDir =  "Kestrel_Alaki.ir" # just name of 
# destination for saving zip file
$destinationPath = "C:\"
#temp directory for needed process (better to be in same disk as $sourceDir)

try {
    
    ## build a name for zip file 
    # the algo is YYYYMMDDHHMMSS
    $currentDateTime = Get-Date
    # Format the date and time as needed (YYYYMMDDHHMMSS)
    $formattedDateTime = $currentDateTime.ToString("yyyyMMddHHmmss")
    # Construct the file name

    $tempDir = $workPath + "_temp-$formattedDateTime"


    ###################################################################
    $sourcePath =  $workPath + $sourceDir

    # list of files and folders to exclude
    $excludeList = @(
        "tfolder",
        "Ardalis.GuardClauses.dll",
        "Identity.UI.runtimeconfig.json"
    )

    ################### checking prerequirties ########################

    #testing and creating temprory directory 
    if (Test-Path $tempDir) {
        #there is a directory with same Name 
        Write-Host "there is another temp folder, it would be replaced with empty one!"
        Remove-Item $tempDir -Recurse
        New-Item -ItemType Directory $tempDir
    } else {

        #there is no directory with same Name 
        New-Item -ItemType Directory $tempDir 

        Write-Host "temp directory has been created!"
    }

    ## debug comments 
    write-host "working Path = $workPath`n source dir = $sourcePath`n destination dir = $destinationPath`n temperory dir = $tempDir"


    $excludePathList = @()
    foreach ($i in $excludeList) {
        $excludePathList += $sourcePath + "\" + $i
    }

    $includeList = @()
    foreach ($i in (Get-ChildItem $sourcePath).FullName) {
        if (!$excludePathList.Contains($i)){
            $includeList += $i
        } else {
            ## debug comments 
            Write-Host $i + " excluded from list!`n"
        }
    }

    ## debug comments 
    Write-Host "`n`n exclude list is ==> $excludeList"
    ###################################################################

    ################### phase 1 : copy itemList to temp Directory ########################

    try {
        New-Item -Type Directory $tempDir\$sourceDir
    
        Copy-Item -Path $includeList -Destination $tempDir\$sourceDir -Exclude $excludeList -Recurse 
        
    }
    catch {
        Write-Output "copy Items to temp folder is failed: " + $_
        if (Test-Path -LiteralPath "$tempDir\$sourceDir" ) {
            Remove-Item -ItemType Directory -Path $tempDir\$sourceDir
        }
    }
    ###################################################################

    ################### phase 2 : create archive ########################
    $tempfiles = "$tempDir\$sourceDir"
    $tempfiles
    $destinationPath

    $backupName = "($formattedDateTime)" + ".zip"

    
    try {
        Compress-Archive -Path $tempfiles -DestinationPath "$destinationPath\$sourceDir-$backupName" -Force
    }
    catch {
        Write-Output "compression failed: " + $_
        if (Test-Path "$destinationPath\$sourceDir-$backupName") {
            Remove-Item -ItemType file -Path "$destinationPath\$sourceDir-$backupName"
        }
    }

    ###################################################################

    Remove-Item $tempDir -Recurse

}
catch {
    Write-Output $_
}
