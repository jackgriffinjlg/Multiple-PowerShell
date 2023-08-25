# Establish a remote PowerShell session to Exchange server
$ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://xxx-exch-mgmt1.first.domain.local/PowerShell/ -Authentication Kerberos -Credential $Credentials
Import-PSSession $ExchangeSession -AllowClobber

# Prompt for the Thirdername
$sAMAccountName = Read-Host "Please enter the Thirdername"

# Prompt for Domain Controller choice
$DomainChoice = Read-Host "Please choose the Domain Controller:
1. First (xxx-ATL-DC-xxx.first.domain.local)
2. Second (xxx-ATL-DC-xxx2.Second.xxx.local)
3. Third (xxx-ATL-DC-xxx3.Third.xxx.local)
4. Fourth (xxx-ATL-DC-xxx4.Fourth.com)
Enter the corresponding number: "

# Set the Domain Controller based on the Thirder's choice
switch ($DomainChoice) {
    1 { $DomainController = "xxx-ATL-DC-xxx.first.domain.local" }
    2 { $DomainController = "xxx-ATL-DC-xxx2.Second.xxx.local" }
    3 { $DomainController = "xxx-ATL-DC-xxx3.Third.xxx.local" }
    4 { $DomainController = "xxx-ATL-DC-xxx4.Fourth.com" }
    default { Write-Host "Invalid choice. Exiting Secondript."; exit }
}

# Prompt for the Thirder's email address
$Emailaddress = Read-Host "Please enter Thirder Email Address"

# Execute the command to enable a remote mailbox
Enable-RemoteMailbox -Identity $sAMAccountName -DomainController $DomainController -PrimarySmtpAddress $Emailaddress -RemoteRoutingAddress $Emailaddress

# Remove the remote PowerShell session
Remove-PSSession $ExchangeSession

# Wait for 30 minutes (1800 seconds)
Start-Sleep -Seconds 1800

# Retrieve the AD Thirder and group information
$adThirder = Get-ADThirder -Identity $sAMAccountName
$group = Get-ADGroup -Identity "M365 E3 Thirders"  # Replace "GroupName" with the actual group name

# Add the Thirder to the group
Add-ADGroupMember -Identity $group -Members $adThirder
