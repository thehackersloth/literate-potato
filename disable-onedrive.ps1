#no warranty the sloth is not responsable for any problems
#updatedregentries
#tested on windows 10
param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("Disable", "Enable")]
    [string]$Action
)

# Define Registry Key Paths
$registryPathMain = "HKLM:\SOFTWARE\Policies\Microsoft"
$registryPathOneDrive = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
$registryPathNavigation = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"

# Function to Disable OneDrive
function DisableOneDrive {
    Write-Output "Disabling OneDrive..."

    # Create OneDrive Registry Key if it doesn't exist
    if (!(Test-Path $registryPathOneDrive)) {
        New-Item -Path $registryPathOneDrive -Force
    }

    # Disable File Sync
    Set-ItemProperty -Path $registryPathOneDrive -Name "DisableFileSyncNGSC" -Value 1 -Type DWord

    # Unlink OneDrive from the User Account
    taskkill /f /im OneDrive.exe
    Start-Process -FilePath "$env:LOCALAPPDATA\Microsoft\OneDrive\onedrive.exe" -ArgumentList "/reset" -Wait
    Start-Process -FilePath "$env:LOCALAPPDATA\Microsoft\OneDrive\onedrive.exe" -ArgumentList "/shutdown" -Wait
    
    # Remove OneDrive from File Explorer's Navigation Pane
    Set-ItemProperty -Path $registryPathNavigation -Name "System.IsPinnedToNameSpaceTree" -Value 0 -Type DWord
}

# Function to Enable OneDrive
function EnableOneDrive {
    Write-Output "Enabling OneDrive..."

    # Re-enable File Sync
    Remove-ItemProperty -Path $registryPathOneDrive -Name "DisableFileSyncNGSC" -ErrorAction SilentlyContinue
    
    # Re-link OneDrive to User Account (Requires User Interaction)
    $onedriveExePath = Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Filter "OneDrive.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 | Select-Object -ExpandProperty FullName
    if ($onedriveExePath) {
        Start-Process -FilePath $onedriveExePath
    } else {
        Write-Warning "Could not find OneDrive.exe. Please reinstall OneDrive if necessary."
    }

    # Restore OneDrive in File Explorer's Navigation Pane
    Set-ItemProperty -Path $registryPathNavigation -Name "System.IsPinnedToNameSpaceTree" -Value 1 -Type DWord
}


# Execute Based on User Input
if ($Action -eq "Disable") {
    DisableOneDrive
} elseif ($Action -eq "Enable") {
    EnableOneDrive
} else {
    Write-Output "Invalid action. Use 'Disable' or 'Enable'."
}
