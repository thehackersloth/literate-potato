# Prompt for the new local account username
$username = Read-Host -Prompt "Enter the new local account username:"

# Prompt for the new local account password
$password = Read-Host -AsSecureString -Prompt "Enter the new local account password:"

# Create the new local user account
New-LocalUser -Name $username -Password $password

# Convert the password to a usable format
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $password 

# Remove the Azure AD work or school account from the device
Remove-AzureADDeviceRegisteredUser -Credential $credential -Confirm:$false

# Switch the current user to the newly created local account
Switch-AzureADUser -Credential $credential -TargetUser $username -Confirm:$false
