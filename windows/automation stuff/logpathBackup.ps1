### find all files in last inserted month and copy it in diffrent path in a same directory structure ###

## Define source and destination paths
$sourceRoot = "HostingSpaces"
$destinationRoot = "z:\WebServer-01"

## Specify the number of months ago 
# in (Get-Date).AddMonths(-1) <<===== just change -1 
$oneMonthAgo = (Get-Date).AddMonths(-1)

# Function to move files and create directories if needed
function MoveAndCreateDirectoryIfNeeded($sourcePath, $destinationPath) {
    if (!(Test-Path $destinationPath)) {

        ## just create directory in destination path
        New-Item -ItemType Directory -Path $destinationPath | Out-Null
    }
    #                                   ## find files here ##                           ## find last modified date here ##                   ## move the item ##
    Get-ChildItem -Path $sourcePath | Where-Object { $_.PSIsContainer -eq $false } | Where-Object {$_.LastWriteTime -gt $oneMonthAgo } | Move-Item -Destination $destinationPath
}

# Process LogFile directories
Get-ChildItem -Path $sourceRoot | ForEach-Object {
    # save subfolder path as variable
    $subFolder = $_.Name

    Get-ChildItem -Path "$sourceRoot\$subFolder" | ForEach-Object {

        # save subfolder path as variable
        $innerSubFolder = $_.Name
        $sourceLogFileDir = "$sourceRoot\$subFolder\$innerSubFolder\wwwroot\LogFile"

        if (Test-Path $sourceLogFileDir) {
            $destinationLogFileDir = "$destinationRoot\$subFolder\$innerSubFolder\wwwroot\LogFile"
            MoveAndCreateDirectoryIfNeeded $sourceLogFileDir $destinationLogFileDir
        }

        $sourceLogFilesDir = "$sourceRoot\$subFolder\$innerSubFolder\wwwroot\LogFiles"

        if (Test-Path $sourceLogFilesDir) {
            $destinationLogFilesDir = "$destinationRoot\$subFolder\$innerSubFolder\wwwroot\LogFiles"
            MoveAndCreateDirectoryIfNeeded $sourceLogFilesDir $destinationLogFilesDir
        }

        # for hardnames of folders
        $additionalLogDirs = @("Raja", "Fadak", "Bonrail")

        foreach ($logDir in $additionalLogDirs) {
            $sourceLogDir = "$sourceRoot\$subFolder\$innerSubFolder\wwwroot\LogFile\$logDir"

            if (Test-Path $sourceLogDir) {
                $destinationLogDir = "$destinationRoot\$subFolder\$innerSubFolder\wwwroot\LogFile\$logDir"
                MoveAndCreateDirectoryIfNeeded $sourceLogDir $destinationLogDir
            }
        }
        # for hardnames of folders
        $sourceLogsDir = "$sourceRoot\$subFolder\$innerSubFolder\logs"

        if (Test-Path $sourceLogsDir) {
            Get-ChildItem -Path $sourceLogsDir | ForEach-Object {
                $logType = $_.Name
                $destinationLogsDir = "$destinationRoot\$subFolder\$innerSubFolder\logs\$logType"
                MoveAndCreateDirectoryIfNeeded $sourceLogsDir\$logType $destinationLogsDir
            }
        }

        # for hardnames of folders
        $sourceNestedLogFileDir = "$sourceRoot\$subFolder\$innerSubFolder\wwwroot\wwwroot\LogFile"

        if (Test-Path $sourceNestedLogFileDir) {
            $destinationNestedLogFileDir = "$destinationRoot\$subFolder\$innerSubFolder\wwwroot\wwwroot\LogFile"
            MoveAndCreateDirectoryIfNeeded $sourceNestedLogFileDir $destinationNestedLogFileDir
        }
    }
}