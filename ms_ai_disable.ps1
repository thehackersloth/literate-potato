Write-Host "Disabling Windows Copilot, Recall, Tips, and AI Data Analysis..."

# Disable Windows Copilot (Registry Method)
$copilotKeyPath = "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot"
$copilotValueName = "TurnOffWindowsCopilot"
New-Item -Path $copilotKeyPath -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path $copilotKeyPath -Name $copilotValueName -PropertyType DWORD -Value 1 -Force

# Disable Windows Recall (Registry Method)
$recallKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudExperienceHost"
$recallValueName = "DisableCloudOptimizedContent"
New-Item -Path $recallKeyPath -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path $recallKeyPath -Name $recallValueName -PropertyType DWORD -Value 1 -Force

# Disable Windows Tips (Registry Method)
$tipsKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
$tipsValueName = "SilentInstalledAppsEnabled"
New-Item -Path $tipsKeyPath -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path $tipsKeyPath -Name $tipsValueName -PropertyType DWORD -Value 0 -Force

# Disable AI Data Analysis (Registry Method)
$aiKeyPath = "HKCU:\Software\Policies\Microsoft\Windows\WindowsAI"
$aiValueName = "DisableAIDataAnalysis"
New-Item -Path $aiKeyPath -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path $aiKeyPath -Name $aiValueName -PropertyType DWORD -Value 1 -Force

Write-Host "Windows Copilot, Recall, Tips, and AI Data Analysis disabled."

# Prompt to Re-enable (Optional)
$response = Read-Host "Do you want to re-enable Windows Copilot, Recall, Tips, and AI Data Analysis? (yes/no)"
if ($response -eq "yes") {
    Write-Host "Re-enabling Windows Copilot, Recall, Tips, and AI Data Analysis..."

    # Re-enable Windows Copilot (Registry Method)
    Remove-ItemProperty -Path $copilotKeyPath -Name $copilotValueName

    # Re-enable Windows Recall (Registry Method)
    Remove-ItemProperty -Path $recallKeyPath -Name $recallValueName

    # Re-enable Windows Tips (Registry Method)
    Remove-ItemProperty -Path $tipsKeyPath -Name $tipsValueName

    # Re-enable AI Data Analysis (Registry Method)
    Remove-ItemProperty -Path $aiKeyPath -Name $aiValueName

    Write-Host "Windows Copilot, Recall, Tips, and AI Data Analysis re-enabled."
}