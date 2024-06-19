
# Define the function to get the text between startValue and endValue
function Get-TextBetweenValues {
    param (
        [string]$startValue,
        [string]$endValue,
        [string]$text
    )

    # Use regex to extract text between startValue and endValue
    $pattern = [regex]::Escape($startValue) + "(.*?)" + [regex]::Escape($endValue)
    $match = [regex]::Match($text, $pattern)

    if ($match.Success) {
        return $match.Groups[1].Value
    } else {
        return "No text found between the specified values."
    }
}

## Define a function to replace text between two specific values
function ReplaceTextBetweenValues {
    param(
        [string]$text,
        [string]$startValue,
        [string]$endValue,
        [string]$newText
    )

    ## Construct a regular expression pattern to match text between startValue and endValue
    $pattern = [regex]::Escape($startValue) + '(.*?)' + [regex]::Escape($endValue)

    ## Define a script block to process each match found by the regular expression
    
    # $replacement = {
    #     param($match)
    #     return $startValue + $newText + $endValue
    # }
    $replacement = "$startValue$newText$endValue"
    # Use -replace with the pattern and script block to replace text between startValue and endValue
    $updatedText = $text -replace $pattern, $replacement

    return $updatedText
}

## path and infos
# please set your start and end value, between them you want to change the version
# please insert ` before special character like "" 
$startVal = "`"Version`":`""
$endVal = "`""
# path of file 
$filePath = "E:\commands\windows\test\test.json"
# the number of value you want to rais by 1
$hotFix = 2
###################################################

$inputText = @(Get-Content -LiteralPath $filePath -Raw)
$versionString = Get-TextBetweenValues -startValue $startVal -endValue $endVal -text $inputText


$versionArray = $versionString -split '\.'
$hotFix -= 1

if($hotFix -gt 0 -and $versionArray.Count -gt $hotFix){
    
    # debug infos
    Write-Verbose -Message "the selected string is: $versionString" -Verbose
    
    $valToInt = [System.Convert]::ToInt64($versionArray[$hotFix])
    # debug infos
    Write-Verbose -Message "the selected number is: $valToInt" -Verbose
    
    $valToInt ++
    $versionArray[$hotFix] = $valToInt
    
    
    $newTextVal = $versionArray -join '.'
    # debug infos
    Write-Verbose -Message "the new version number is: $newTextVal" -Verbose

    $newTextValue = $newTextVal

    ## Call the function to replace text between [start] and [end] with "new text"

    $updatedText = ReplaceTextBetweenValues -text $inputText -startValue $startVal -endValue $endVal -newText $newTextValue

    ## Save and Output the updated text
    Set-Content $filePath -Value $updatedText
    Write-Host $updatedText -ForegroundColor Magenta

} else {
    Write-Error "inputed hotfix value is greater than numbers `nof version numbersor less than 0!"
}
