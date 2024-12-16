# This script is provided for educational and informational purposes only. 
# Modifying file timestamps can have unintended consequences. 
# Use it with extreme caution and at your own risk.

# Set the target folder path
$folderPath = "C:\Path\To\Your\Folder" 

# Get all files and folders within the target folder
$items = Get-ChildItem -Path $folderPath -Recurse

# Function to generate a random date and time within a specific range
function Get-RandomDateTime {
    param(
        [int]$Year = (Get-Date).Year,
        [int]$MonthStart = 1,
        [int]$MonthEnd = 12,
        [int]$DayStart = 1,
        [int]$DayEnd = 28 
    )

    $randomDate = Get-Date -Year $Year -Month (Get-Random -Minimum $MonthStart -Maximum $MonthEnd) -Day (Get-Random -Minimum $DayStart -Maximum $DayEnd) -Hour (Get-Random -Minimum 0 -Maximum 23) -Minute (Get-Random -Minimum 0 -Maximum 59) -Second (Get-Random -Minimum 0 -Maximum 59)
    return $randomDate
}

# Loop through each item
foreach ($item in $items) {
    # Generate random dates for CreationTime, LastWriteTime, and LastAccessTime
    $randomCreationTime = Get-RandomDateTime
    $randomLastWriteTime = Get-RandomDateTime
    $randomLastAccessTime = Get-RandomDateTime

    # Update file timestamps (This will automatically update the USN journal)
    $item.CreationTime = $randomCreationTime
    $item.LastWriteTime = $randomLastWriteTime
    $item.LastAccessTime = $randomLastAccessTime
}

