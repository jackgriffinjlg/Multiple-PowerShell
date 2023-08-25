# List of domain controllers in different domains along with their credentials
$DomainControllers = @(
    @{
        Controller = "first.domain.local"
        Credential = Get-Credential -Message "Enter credentials for First"
    },
    @{
        Controller = "second.domain.local"
        Credential = Get-Credential -Message "Enter credentials for Second"
    },
    @{
        Controller = "third.domain.local"
        Credential = Get-Credential -Message "Enter credentials for Third"
    }
)

# Prompt for First and Last name
$FirstName = Read-Host "Enter the First Name"
$LastName = Read-Host "Enter the Last Name"

# Loop through each domain controller
foreach ($DC in $DomainControllers) {
    try {
        # Query Active Directory for user accounts matching the First and Last name
        $users = Get-ADUser -Filter {(GivenName -eq $FirstName) -and (Surname -eq $LastName)} -Server $DC.Controller -Credential $DC.Credential -ErrorAction Stop

        if ($users) {
            Write-Host "Users found in $($DC.Controller):"
            foreach ($user in $users) {
                Write-Host "User Properties:"
                $user | Format-List *
            }
        } else {
            Write-Host "No users found in $($DC.Controller)."
        }
    } catch {
        Write-Host "Error occurred while querying $($DC.Controller): $_"
    }
}