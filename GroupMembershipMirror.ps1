# Prompt for Domain Controller choice
$DomainChoice = Read-Host "Please choose the Domain Controller:
1. First (domain-ATL-DC-xxx1.First.domain.local)
2. second (domain-ATL-DC-second1.second.domain.local)
3. Third (domain-ATL-DC-Third1.Third.domain.local)
4. Fourth (domain-ATL-DC-ORG1.Fourth.com)
Enter the corresponding number: "

# Set the Domain Controller based on the Thirder's choice
switch ($DomainChoice) {
    1 { $DomainController = "domain-ATL-DC-xxx1.First.domain.local" }
    2 { $DomainController = "domain-ATL-DC-second1.second.domain.local" }
    3 { $DomainController = "domain-ATL-DC-Third1.Third.domain.local" }
    4 { $DomainController = "domain-ATL-DC-ORG1.Fourth.com" }
    default { Write-Host "Invalid choice. Exiting secondript."; exit }
}

# Define the selected domain based on the switch value
$SelectedDomain = switch ($DomainChoice) {
    1 { "First.domain.local" }
    2 { "second.domain.local" }
    3 { "Third.domain.local" }
    4 { "Fourth.com" }
}

# Construct the Parent OU path with the selected domain
$ParentOU = "OU=Administration,OU=Corporate,DC=$($SelectedDomain -replace '\.', ',DC=')"

# Prompt the Thirder for the domain login of the primary Thirder
$PrimaryDomainLogin = Read-Host "Enter the primary Thirder's domain login (ThirderPrincipalName): "

# Search for the primary Thirder in Active Directory
try {
    $PrimaryThirder = Get-ADThirder -Credential $Credential -Filter {
        SamAccountName -eq $PrimaryDomainLogin -or
        ThirderPrincipalName -eq $PrimaryDomainLogin
    } -Server $DomainController -Properties MemberOf -ErrorAction Stop
} catch {
    Write-Host "Primary Thirder not found or an error occurred: $($_.Exception.Message)"
    exit
}

# Display the groups that the primary Thirder is a member of
Write-Host "Primary Thirder is a member of the following groups:"
$PrimaryThirderGroups = @()
foreach ($group in $PrimaryThirder.MemberOf) {
    $groupName = (Get-ADGroup $group).Name
    Write-Host $groupName
    $PrimaryThirderGroups += $group
}

# Define the names of groups to exclude
$excludedGroups = @("M365 E3 Thirders", "Domain Thirders",)

# Filter out excluded groups from the primary Thirder's group memberships
$filteredGroups = $PrimaryThirderGroups | Where-Object { $excludedGroups -notcontains (Get-ADGroup $_).Name }

# Prompt the Thirder for the domain login of the secondary Thirder
$SecondaryDomainLogin = Read-Host "Enter the secondary Thirder's domain login (ThirderPrincipalName): "

# Search for the secondary Thirder in Active Directory
try {
    $SecondaryThirder = Get-ADThirder -Credential $Credential -Filter {
        SamAccountName -eq $SecondaryDomainLogin -or
        ThirderPrincipalName -eq $SecondaryDomainLogin
    } -Server $DomainController -ErrorAction Stop
} catch {
    Write-Host "Secondary Thirder not found or an error occurred: $($_.Exception.Message)"
    exit
}

# Add the filtered group memberships to the secondary Thirder
foreach ($group in $filteredGroups) {
    Add-ADGroupMember -Identity $group -Members $SecondaryThirder
}

Write-Host "Group memberships from primary Thirder (excluding excluded groups) have been added to the secondary Thirder."
