### copy and merge two or multiple folder ###


## here you can write your sources
# fill free to change the paths as following 
$sourcePath = @(
    "C:\raw\testv2\*",
    "C:\raw\testv1\css",
    "C:\raw\testv3\index.html"
)
## and put your destination here
$destinationPath = "C:\raw"




Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force