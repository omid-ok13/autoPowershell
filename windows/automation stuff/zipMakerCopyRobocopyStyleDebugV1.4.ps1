###################################################################
# the path, that script would be run, (best the directory before source folder)
# please add a backslash (\) at the end of workPath 
$workPath = "E:\commands\windows\test\test area\HostingSpaces\"
# name of source folder, it must be in $workPath directory 
$sourceDir =  "IIS_Alaki.ir" # just name of 
# destination for saving zip file
$destinationPath = "E:\commands\windows\test\test area"
#temp directory for needed process (better to be in same disk as $sourceDir)


###################################################################
# list of files and folders to exclude
$excludeList = @(
    "appsettings.json",
    "aspnet_client\system_web",
    "testdir3"
)



function Copy-itemsWithRobocopy {
    param (
        $sourceRobo,
        $destinationRobo,
        $excludeListRobo
    )

    # Construct the exclusion parameters for Robocopy
    $exclusionParams = @()
    foreach ($exclusion in $excludeListRobo) {
        $exclusionParams += "/XD $sourceRobo\$exclusion"  # For directories
        $exclusionParams += "/XF $sourceRobo\$exclusion"  # For files
    }

    # Construct the full Robocopy command
    $robocopyCmd = @(
        "Robocopy",
        "`"$sourceRobo`"",
        "`"$destinationRobo`"",
        "/E",                   # Copy all subdirectories, including empty ones
        "/COPYALL",             # Copy all file information
        "/R:3",                 # Retry 3 times on failed copies
        "/W:5",                 # Wait 5 seconds between retries
        "/MT:32"                # Multi-threaded copy with 32 threads
    ) + $exclusionParams

    # Join the command components into a single string
    $robocopyCmdString = $robocopyCmd -join " "

    Write-Output "Executing Robocopy command: $robocopyCmdString"
    # Execute the Robocopy command

    Invoke-Expression $robocopyCmdString -ErrorAction Stop

    Write-Output "Robocopy completed successfully.`n"

    ## Debug comments 
    #Write-Output "Working Path: $workPath" 
    #Write-Output "Source Directory: $sourcePath"
    #Write-Output "Destination Directory: $destinationPath"
    #Write-Output "Temporary Directory: $tempDir`n"
    ###################################################################
}




## build a name for zip file 
# the algo is YYYYMMDDHHMMSS
$currentDateTime = Get-Date
# Format the date and time as needed (YYYYMMDDHHMMSS)
$formattedDateTime = $currentDateTime.ToString("yyyyMMddHHmmss")
# Construct the file name

$tempDir = $destinationPath + "_temp-$formattedDateTime"
$sourcePath =  $workPath + $sourceDir

    try {
        switch ($false) {
            (Test-Path $workPath) { 
                if ($true) {throw "work Path not found! "}
             }
             (Test-Path $sourcePath) { 
                if ($true) {throw 'sourceDir not found in $workPath!'}
             }
             (Test-Path $destinationPath) { 
                if ($true) {throw '$destinationPath not found!'} 
             }
            Default {
                
                Write-Output "Script started at: $($currentDateTime.ToString("yyyy-MM-dd HH:mm:ss"))"
                Write-Output "Work path: $workPath"
                Write-Output "Source directory: $sourceDir"
                Write-Output "Destination path: $destinationPath"
                Write-Output "Temporary directory: $tempDir"


                ################### checking prerequisites ########################

                # Testing and creating temporary directory 
                if (Test-Path $tempDir) {
                    # There is a directory with the same name 
                    Write-Warning "There is another temp folder, it would be replaced with an empty one!`n"
                    Remove-Item $tempDir -Recurse -ErrorAction Stop
                    Write-Output "Old temporary directory removed.`n"
                    try {
                        # There is no directory with the same name 
                        New-Item -ItemType Directory $tempDir -ErrorAction Stop
                        New-Item -ItemType Directory $tempDir\$sourceDir -ErrorAction Stop
                        Write-Output "Temporary directory has been created!`n"

                        ## copy with robocopy
                        Copy-itemsWithRobocopy -sourceRobo $sourcePath -destinationRobo $tempDir -excludeListRobo $excludeList
                        
                    }
                    catch {
                        Write-Output $_.Exception.Message
                        Remove-Item $tempDir -Recurse -Force -ErrorAction Stop
                        exit 1
                    } 
                } else {
                    try {
                        # There is no directory with the same name 
                        New-Item -ItemType Directory $tempDir -ErrorAction Stop
                        New-Item -ItemType Directory $tempDir\$sourceDir -ErrorAction Stop
                        Write-Output "Temporary directory has been created!`n"

                        ## copy with robocopy
                        Write-Output "copying started!"
                        Copy-itemsWithRobocopy -sourceRobo $sourcePath -destinationRobo $tempDir -excludeListRobo $excludeList
                        Write-Output "copying Ended!"
                    }
                    catch {
                        Write-Output $_.Exception.Message
                        Remove-Item $tempDir -Recurse -Force -ErrorAction Stop
                        exit 1
                    } 
                }
            
                ################### phase 2 : create archive ########################
                $tempfiles = "$tempDir\$sourceDir"
                $backupName = "($formattedDateTime)" + ".zip"
            
                Write-Output "Starting compression of files to $destinationPath\$sourceDir-$backupName`n"
            
                $files = Get-ChildItem -Path $tempfiles -Recurse -ErrorAction Stop
                $totalFiles = $files.Count
                $counter = 0
                try {
                    foreach ($file in $files) {
                        $counter++
                        Write-Progress -Activity "Compressing files" -Status "$counter of $totalFiles files processed" -PercentComplete (($counter / $totalFiles) * 100)
                        Start-Sleep -Milliseconds 50  # Simulating work, remove or adjust as necessary
                    }
                
                    Compress-Archive -Path $tempfiles -DestinationPath "$destinationPath\$sourceDir-$backupName" -Force -ErrorAction Stop
                    Write-Output "Compression completed successfully.`n"
                    Write-Output "Compress File path: $destinationPath\$sourceDir-$backupName"
                
                }
                catch {
                    Write-Output "compression failed with following Error message: $_"
                    Remove-Item "$destinationPath\$sourceDir-$backupName" -Force -ErrorAction Stop
                    Remove-Item -ItemType directory -Path $tempDir
                    exit 1
                }
                
                
                ###################################################################
            
                Write-Output "Cleaning up temporary files...`n"
                Remove-Item $tempDir -Recurse -Force -ErrorAction Stop
                Write-Output "Temporary files removed. Script completed.`n"
            }
        }
    }
    catch { 
        Write-Host $_.Exception.Message
        exit 1
    }

