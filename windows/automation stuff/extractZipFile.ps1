
## path
# please clear this paths properly
# you can spacify a shared file in a share Folder like this
# \\sheredServer\myFolder
$sourceFile = "V:\test\pwsh\temp"
$destination = "V:\test\pwsh\temp\_tm"
$tempDir = "V:\test\pwsh\temp"
# infos about zip file
$zipFileName = "test.zip"
# the folder name in the zip file
# if you want to copy all the file put a astrics * 
$folderName = "test"

## build a name for TempDir 
# the algo is YYYYMMDDHHMMSS
$currentDateTime = Get-Date
# Format the date and time as needed (YYYYMMDDHHMMSS)
$formattedDateTime = $currentDateTime.ToString("yyyyMMddHH")
# Construct the file name

$tempDir = $destination + "_temp-($formattedDateTime)"

######################### testing and making tempArea ###########################
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

##################################################################################


############################## copy zip file #####################################
Copy-Item -Path "$sourceFile\$zipFileName" -Destination $tempDir -Force

##################################################################################


############################## trying to extracting ##############################
try {
    Expand-Archive -Path "$tempDir\$zipFileName" -Destination $tempDir -Force 
    
    Remove-Item -Path "$tempDir\$zipFileName"

    Copy-Item -Path "$tempDir\$folderName" -Destination $destination -Force -Recurse

}
catch {
    Write-Error "extracting diden't work because of following errors:`n"
    $_
}
##################################################################################

############################## deleteing temp folder ##############################
Remove-Item $tempDir -Force -Recurse
##################################################################################

