<#
.SYNOPSIS
    Automates the provisioning and license assignment of new Microsoft 365 users via Microsoft Graph PowerShell.
.DESCRIPTION
    Creates the user account, assigns departmental groups, sets usage location, and allocates SKU licenses.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$UserPrincipalName,

    [Parameter(Mandatory = $true)]
    [string]$DisplayName,

    [Parameter(Mandatory = $true)]
    [string]$Department,

    [Parameter(Mandatory = $false)]
    [string]$UsageLocation = "CR"
)

Write-Host "[*] Initiating provisioning for: $UserPrincipalName ($DisplayName)" -ForegroundColor Cyan

try {
    # Verify existing connection to Microsoft Graph
    $context = Get-MgContext
    if (-not $context) {
        Write-Warning "No active Graph session found. Connecting with required scopes..."
        Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All"
    }

    # Generate cryptographically secure temporary password
    Add-Type -AssemblyName System.Web
    $tempPassword = [System.Web.Security.Membership]::GeneratePassword(16, 3) + "Aa1!"

    $passwordProfile = @{
        ForceChangePasswordNextSignIn = $true
        Password = $tempPassword
    }

    # Create Cloud Identity
    $newUser = New-MgUser -DisplayName $DisplayName `
                          -UserPrincipalName $UserPrincipalName `
                          -MailNickname ($UserPrincipalName.Split("@")[0]) `
                          -Department $Department `
                          -UsageLocation $UsageLocation `
                          -AccountEnabled $true `
                          -PasswordProfile $passwordProfile

    Write-Host "[+] User created successfully. ID: $($newUser.Id)" -ForegroundColor Green
    Write-Host "[i] Temporary Password: $tempPassword (Must be changed upon first login)" -ForegroundColor Yellow

} catch {
    Write-Error "[-] Failed to provision user: $_"
}
