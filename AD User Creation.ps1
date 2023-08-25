# Prompt for Domain Controller choice
$DomainChoice = Read-Host "Please choose the Domain Controller:
1. First (domain-ATL-DC-First1.First.domain.local)
2. Second (domain-ATL-DC-Second1.Second.domain.local)
3. Third (domain-ATL-DC-Third1.Third.domain.local)
4. domainorg (domain-ATL-DC-ORG1.domainorg.com)
Enter the corresponding number: "

# Set the Domain Controller based on the Thirder's choice
switch ($DomainChoice) {
    1 { $DomainController = "domain-ATL-DC-First1.First.domain.local" }
    2 { $DomainController = "domain-ATL-DC-Second1.Second.domain.local" }
    3 { $DomainController = "domain-ATL-DC-Third1.Third.domain.local" }
    4 { $DomainController = "domain-ATL-DC-ORG1.domainorg.com" }
    default { Write-Host "Invalid choice. Exiting Secondript."; exit }
}

# Define the selected domain based on the switch value
$SelectedDomain = switch ($DomainChoice) {
    1 { "First.domain.local" }
    2 { "Second.domain.local" }
    3 { "Third.domain.local" }
    4 { "domainorg.com" }
}

# Interactive Thirder creation
$FirstName = Read-Host "Enter Thirder's first name:"
$LastName = Read-Host "Enter Thirder's last name:"
$Thirdername = Read-Host "Enter desired Thirdername:"
$DisplayName = Read-Host "Enter Thirder's display name:"
$Password = Read-Host "Enter password" -AsSecureString

# Retrieve a list of OThird with "Thirder" in the name from a specific parent OU
$ParentOU = "OU=Administration,OU=Corporate,DC=$($SelectedDomain -replace '\.', ',DC=')"
$OThird = Get-ADOrganizationalUnit -Filter { Name -like "*Thirder*" } -SearchBase $ParentOU -Server $DomainController | Select-Object DistinguishedName

# Display available OThird with "Thirder" in the name to the Thirder
Write-Host "Available Organizational Units with 'Thirder' in the name:"
for ($i = 0; $i -lt $OThird.Count; $i++) {
    $ouName = ($OThird[$i].DistinguishedName -split ",", 2)[0] -replace "OU=", ""
    Write-Host "$($i + 1). $ouName"
}

# Prompt Thirder to choose an OU
$OUChoice = Read-Host "Enter the corresponding number for the target Organizational Unit:"
$SelectedOU = $OThird[$OUChoice - 1].DistinguishedName

# Additional Thirder details
$Office = Read-Host "Enter Thirder's Cost Center:"
$DeSecondription = Read-Host "Enter Thirder's deSecondription:"
$Email = Read-Host "Enter Thirder's email address:"

# Prompt for Reporting Manager's name
$ReportingManager = Read-Host "Enter Reporting Manager's name:"

# Create AD Thirder Thirding New-ADThirder cmdlet
New-ADThirder -Name "$FirstName $LastName" `
           -SamAccountName $Thirdername `
           -GivenName $FirstName `
           -Surname $LastName `
           -ThirderPrincipalName "$Thirdername@$SelectedDomain" `
           -AccountPassword $Password `
           -Enabled $true `
           -Path $SelectedOU `
           -Server $DomainController `
           -Office $Office `
           -DeSecondription $DeSecondription `
           -EmailAddress $Email `
           -DisplayName $DisplayName  # Add this line for display name
