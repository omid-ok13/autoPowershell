
## Define source and destination paths
$sourceRoot = "C:\raw"
$destinationRoot = "\\dc\back"

## Specify the number of months ago 
# for Days set value in (Get-Date).AddDays(-1) <<===== just change -1 
#$oneMonthAgo = (Get-Date).AddDays(-1)
# for months set value in (Get-Date).AddMonths(-1) <<===== just change -1 
$oneMonthAgo = (Get-Date).AddMonths(-3)
# for years set value in (Get-Date).AddYears(-1) <<===== just change -1 
#$oneMonthAgo = (Get-Date).AddYears(-1)


Write-Host "from $sourceRoot `nto $destinationRoot`n all file since $oneMonthAgo will be transfered!`n"

# Function to move files and create directories if needed
function MoveAndCreateDirectoryIfNeeded($sourcePath, $destinationPath) {
    if (!(Test-Path $destinationPath)) {
        ## just create directory in destination path
        New-Item -ItemType Directory -Path $destinationPath | Out-Null   
        Write-Host "no directory found in $destinationPath, so it is created!`n"
    }

    #                                   ## find files here ##                           ## find last modified date here ##                   ## Copy the item ##
    Get-ChildItem -Path $sourcePath | Where-Object { $_.PSIsContainer -eq $false } | Where-Object {$_.LastWriteTime -gt $oneMonthAgo} | Copy-Item -Destination $destinationPath -Verbose

    Write-Host "`n`n`n"
    ## for move the items uncomment it, but becareful
    # Get-ChildItem -Path $sourcePath | Where-Object { $_.PSIsContainer -eq $false } | Where-Object {$_.LastWriteTime -gt $oneMonthAgo} | Move-Item -Destination $destinationPath
}

# Process LogFile directories
Get-ChildItem -Path $sourceRoot | ForEach-Object {
    # save subfolder path as variable
    $subFolder = $_.Name

    Get-ChildItem -Path "$sourceRoot\$subFolder" | ForEach-Object {
        
## stage 1 ##############################################################################################
        # save subfolder path as variable
        $innerSubFolder = $_.Name
        $sourceLogFileDir = "$sourceRoot\$subFolder\$innerSubFolder\wwwroot\LogFile"

        if (Test-Path $sourceLogFileDir) {
            $destinationLogFileDir = "$destinationRoot\$subFolder\$innerSubFolder\wwwroot\LogFile"
            MoveAndCreateDirectoryIfNeeded $sourceLogFileDir $destinationLogFileDir
        }
        #################################################################################################

## stage 2 ##############################################################################################
        $sourceLogFilesDir = "$sourceRoot\$subFolder\$innerSubFolder\wwwroot\LogFiles"

        if (Test-Path $sourceLogFilesDir) {
            $destinationLogFilesDir = "$destinationRoot\$subFolder\$innerSubFolder\wwwroot\LogFiles"
            MoveAndCreateDirectoryIfNeeded $sourceLogFilesDir $destinationLogFilesDir
        }
        ################################################################################################

## stage 3 #############################################################################################
        # for hardnames of folders
        $additionalLogDirs = @("Raja", "Fadak", "Bonrail")

        foreach ($logDir in $additionalLogDirs) {
            $sourceLogDir = "$sourceRoot\$subFolder\$innerSubFolder\wwwroot\LogFile\$logDir"

            if (Test-Path $sourceLogDir) {
                $destinationLogDir = "$destinationRoot\$subFolder\$innerSubFolder\wwwroot\LogFile\$logDir"
                MoveAndCreateDirectoryIfNeeded $sourceLogDir $destinationLogDir
            }
        }
        ################################################################################################
      
## stage 4 ##############################################################################################
        # for hardnames of folders
        $sourceLogsDir = "$sourceRoot\$subFolder\$innerSubFolder\logs"

        if (Test-Path $sourceLogsDir) {
            Get-ChildItem -Path $sourceLogsDir | ForEach-Object {
                $logType = $_.Name
                $checkSource = Get-Item -Path "$sourceLogsDir\$logType"
                # check if source path is a file or a folder
                if($checkSource -is [System.IO.DirectoryInfo]){
                    $destinationLogsDir = "$destinationRoot\$subFolder\$innerSubFolder\logs\$logType"
                }else {
                    $destinationLogsDir = "$destinationRoot\$subFolder\$innerSubFolder\logs\"
                }
                
                MoveAndCreateDirectoryIfNeeded $sourceLogsDir\$logType $destinationLogsDir
            }
        }
        ################################################################################################


## stage 5 #############################################################################################

        # for hardnames of folders
        $sourceNestedLogFileDir = "$sourceRoot\$subFolder\$innerSubFolder\wwwroot\wwwroot\LogFile"

        if (Test-Path $sourceNestedLogFileDir) {
            $destinationNestedLogFileDir = "$destinationRoot\$subFolder\$innerSubFolder\wwwroot\wwwroot\LogFile"
            MoveAndCreateDirectoryIfNeeded $sourceNestedLogFileDir $destinationNestedLogFileDir
        }
    }
    ##############################################################################################
    


    ##############################################################################################
    ##############################################################################################
    ################## you can follow thit structure to add move paths ###########################
    ##############################################################################################
    ##############################################################################################
}