


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

$filePath = "E:\commands\windows\test\test.txt"

## Example usage:
$inputText = @(Get-Content -LiteralPath E:\commands\windows\test\test.txt -Raw)
$newTextValue = "12.5.6"

## Call the function to replace text between [start] and [end] with "new text"

$updatedText = ReplaceTextBetweenValues -text $inputText -startValue "`"Version`":`"" -endValue "`"," -newText $newTextValue

## Save and Output the updated text
Set-Content $filePath -Value $updatedText
Write-Output $updatedText