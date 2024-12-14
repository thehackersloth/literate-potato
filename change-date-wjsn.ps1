# This script is provided for educational and informational purposes only. 
# Modifying the USN Journal can lead to data loss or system instability. 
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

    # Update file timestamps
    $item.CreationTime = $randomCreationTime
    $item.LastWriteTime = $randomLastWriteTime
    $item.LastAccessTime = $randomLastAccessTime

    # --- Modify USN Journal Entry (Use with extreme caution!) ---

    # Get the file's USN record
    $fileRecord = Get-WinEvent -FilterHashtable @{LogName = 'Microsoft-Windows-Ntfs/Operational'; Id = 4663; Path = $item.FullName} | Select-Object -Last 1

    # Extract the USN from the record
    $usn = ($fileRecord.Message -split "`n" | Where-Object {$_ -match 'Usn Journal ID:'}).Split(':')[1].Trim()

    # Construct the command to modify the USN record 
    $command = "fsutil usn readdata $item.FullName | ForEach-Object {{ $_.TimeStamp = '$randomLastWriteTime'; fsutil usn writedata $item.FullName $_.Usn $_.FileReferenceNumber $_.ParentFileReferenceNumber $_.Reason $_.SourceInfo $_.SecurityId $_.FileAttributes $_.FileName $_.TimeStamp }}"

    # Execute the command (This modifies the USN journal)
    Invoke-Expression $command
}

Write-Host "Time attributes and USN Journal entries updated!"
