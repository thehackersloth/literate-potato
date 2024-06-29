#no warranty the sloth is not responsable for any problems
#updatedregentries
#works Widnows 11
#must type enable to enable and disable to disable
param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("Disable", "Enable")]
    [string]$Action
)

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
$onedriveExePath = Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Filter "OneDrive.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 | Select-Object -ExpandProperty FullName

if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath | Out-Null
}

if ($Action -eq "Disable") {
    Write-Output "Disabling OneDrive..."
    Set-ItemProperty -Path $registryPath -Name "DisableFileSyncNGSC" -Value 1 -Type DWord
    
    # Stop OneDrive Process
    taskkill /f /im OneDrive.exe
    
    # Reset and shutdown OneDrive (in the background)
    Start-Process -FilePath $onedriveExePath -ArgumentList "/reset"
    Start-Process -FilePath $onedriveExePath -ArgumentList "/shutdown"
}
elseif ($Action -eq "Enable") {
    Write-Output "Enabling OneDrive..."
    Remove-ItemProperty -Path $registryPath -Name "DisableFileSyncNGSC" -ErrorAction SilentlyContinue
    
    # Start OneDrive (if found)
    if ($onedriveExePath) {
        Start-Process -FilePath $onedriveExePath
    } else {
        Write-Warning "Could not find OneDrive.exe. Please reinstall OneDrive if necessary."
    }
}
else {
    Write-Output "Invalid action. Use 'Disable' or 'Enable'."
}
