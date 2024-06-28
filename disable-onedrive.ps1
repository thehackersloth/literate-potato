#no warranty the sloth is not responsable for any problems

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("Disable", "Enable")]
    [string]$Action
)

# Define Registry Key Paths
$registryPathMain = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
$registryPathNavigation = "HKLM:\SOFTWARE\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"

# Function to Disable OneDrive
function DisableOneDrive {
    Write-Output "Disabling OneDrive..."

    # Disable File Sync
    Set-ItemProperty -Path $registryPathMain -Name "DisableFileSyncNGSC" -Value 1 -Type DWord

    # Unlink OneDrive from the User Account
    taskkill /f /im OneDrive.exe
    Start-Process -FilePath "$env:LOCALAPPDATA\Microsoft\OneDrive\onedrive.exe" -ArgumentList "/reset" -Wait
    Start-Process -FilePath "$env:LOCALAPPDATA\Microsoft\OneDrive\onedrive.exe" -ArgumentList "/shutdown" -Wait
    
    # Remove OneDrive from File Explorer's Navigation Pane
    Set-ItemProperty -Path $registryPathNavigation -Name "System.IsPinnedToNameSpaceTree" -Value 0 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Classes\Wow6432Node\$registryPathNavigation" -Name "System.IsPinnedToNameSpaceTree" -Value 0 -Type DWord
}

# Function to Enable OneDrive
function EnableOneDrive {
    Write-Output "Enabling OneDrive..."
    # Re-enable File Sync
    Remove-ItemProperty -Path $registryPathMain -Name "DisableFileSyncNGSC" -ErrorAction SilentlyContinue
    
    # Re-link OneDrive to User Account (Requires User Interaction)
    Start-Process -FilePath "$env:LOCALAPPDATA\Microsoft\OneDrive\onedrive.exe" 
    
    # Restore OneDrive in File Explorer's Navigation Pane
    Set-ItemProperty -Path $registryPathNavigation -Name "System.IsPinnedToNameSpaceTree" -Value 1 -Type DWord
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Classes\Wow6432Node\$registryPathNavigation" -Name "System.IsPinnedToNameSpaceTree" -Value 1 -Type DWord
}


# Execute Based on User Input
if ($Action -eq "Disable") {
    DisableOneDrive
} elseif ($Action -eq "Enable") {
    EnableOneDrive
} else {
    Write-Output "Invalid action. Use 'Disable' or 'Enable'."
}
