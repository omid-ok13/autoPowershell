
###################################################################
# the path, that script would be run, (best the directory before source folder)
# please add a backslash (\) at the end of workPath 
$workPath = "V:\test\pwsh\temp\"
# name of source folder, it must be in $workPath directory 
$sourceDir =  "test" # just name of 
# destination for saving zip file
$destinationPath = "V:\test\pwsh\temp\_tm"
#temp directory for needed process (better to be in same disk as $sourceDir)

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
    "testdir1\tsetin\ok\testin1.txt",
    "testdir2\tsetin\ok",
    "testdir3"
)

################### checking prerequirties ########################

#testing and creating temprory directory 
if (Test-Path $tempDir) {
    #there is a directory with same Name 
    Write-Host "there is another temp folder, it would be replaced with empty one!"
    Remove-Item $tempDir -Recurse
    New-Item -ItemType Directory $tempDir 
    New-Item -ItemType Directory $tempDir\$sourceDir
} else {

    #there is no directory with same Name 
    New-Item -ItemType Directory $tempDir 
    New-Item -ItemType Directory $tempDir\$sourceDir
    
    Write-Host "temp directory has been created!"
}

# Construct the exclusion parameters for Robocopy
$exclusionParams = @()
foreach ($exclusion in $excludeList) {
    $exclusionParams += "/XD $sourcePath\$exclusion"  # For directories
    $exclusionParams += "/XF $sourcePath\$exclusion"  # For files
}

# Construct the full Robocopy command
$robocopyCmd = @(
    "Robocopy",
    "`"$sourcePath`"",
    "`"$tempDir\$sourceDir`"",
    "/E"                    # Copy all subdirectories, including empty ones
    "/COPYALL"              # Copy all file information
    "/R:3"                  # Retry 3 times on failed copies
    "/W:5"                  # Wait 5 seconds between retries
    "/MT:32"                # Multi-threaded copy with 32 threads
) + $exclusionParams

# Join the command components into a single string
$robocopyCmdString = $robocopyCmd -join " "

# Execute the Robocopy command
Invoke-Expression $robocopyCmdString

## debug comments 
write-host "working Path = $workPath`n source dir = $sourcePath`n destination dir = $destinationPath`n temperory dir = $tempDir"
###################################################################

################### phase 2 : create archive ########################
$tempfiles = "$tempDir\$sourceDir"
$tempfiles
$destinationPath

$backupName = "($formattedDateTime)" + ".zip"


Compress-Archive -Path $tempfiles -DestinationPath "$destinationPath\$sourceDir-$backupName" -Force
###################################################################

Remove-Item $tempDir -Recurse
