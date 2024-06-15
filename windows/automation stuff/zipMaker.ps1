### making zip file of given folder ###

## this is path, to which zip file would be saved
# feel free to write your ideal path between double quotes
$backupPath = "C:\Users\$Env:USERNAME.$Env:USERDOMAIN\Documents\backup"

## this is path, from which zip file would be created
# feel free to write your ideal path between double quotes
$rawPath = "C:\raw"

## here user will give the folder name 
# you can give a static name with deleting this line and ...
$fileDirectory = Read-Host "please enter folder name: "

# uncommenting this line and write your name between double quotes:
#$fileDirectory = "the name"

## Specify the paths to exclude (can be files or folders)
# or you can comment following loop and uncomment the code and add you path as following
$pathsToExclude = @( )
while ($true){ 
    $i = Read-Host "please give file or folder name you want to exclude or insert x to continue: "
    if ( $i -eq "x")
        {
            break
        }
        else{
            $pathsToExclude += "$rawPath\$fileDirectory\$i"
           
        }
    
}
#$pathsToExclude = @(
#    "C:\raw\testv2\.git",
#    "C:\raw\testv2\css",
#    "C:\raw\testv2\index.html"
#
#)

## just echo some values to make sure everything is allright

echo "
following path are excluded from $rawPath\$fileDirectory : $pathsToExclude

and saved in $backupPath
"


## build a name for zip file 
# the algo is YYYYMMDDHHMMSS
$currentDateTime = Get-Date
# Format the date and time as needed (YYYYMMDDHHMMSS)
$formattedDateTime = $currentDateTime.ToString("yyyyMMddHHmmss")
# Construct the file name
$backupName = $formattedDateTime + ".zip"

## gathering list of subfolder
$dataList = Get-ChildItem -Path $rawPath\$fileDirectory

## and exclude the given files or folders
$dataCol4comp = $dataList | Where-Object { $item = $_ ; -not ($pathsToExclude -contains $item.FullName)}


## and finally make the magic;)
Compress-Archive -Path $dataCol4comp.fullname -DestinationPath $backupPath\$fileDirectory-$backupName