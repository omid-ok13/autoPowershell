# Path to your JSON file
$jsonFilePath = "C:\Users\Administrator.OK\Documents\json\testjson.json"

# Key path you want to update (use dot notation for nested keys)
$keyPathToUpdate = "apples"

# New value for the specified key
$newValue = 15

# Function to recursively find and update a key in a nested JSON object
function UpdateNestedKey($obj, $keyPath, $newValue) {
    $keys = $keyPath -split '\.'
    $currentObj = $obj
    
    # Traverse the nested structure based on the key path
    for ($i = 0; $i -lt $keys.Length; $i++) {
        $key = $keys[$i]
        
        # Check if the current key exists in the current object
        if ($currentObj.PSObject.Properties.Name -contains $key) {
            # Move deeper into the nested structure
            $currentObj = $currentObj.$key
            
            # If we've reached the final key in the path, update its value
            if ($i -eq $keys.Length - 1) {
                $currentObj = $newValue
            }
        } else {
            Write-Host "Key '$key' not found in the specified path '$keyPath'."
            return $obj
        }
    }
    
    return $obj
}

# Read the JSON content from file
$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

# Update the nested key path with the new value
$jsonContent = UpdateNestedKey $jsonContent $keyPathToUpdate $newValue

# Convert the modified object back to JSON
$updatedJson = $jsonContent | ConvertTo-Json -Depth 10

# Write the updated JSON back to the file
Set-Content -Path $jsonFilePath -Value $updatedJson

Write-Host "Value of nested key $keyPathToUpdate updated successfully."

