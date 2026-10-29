<#
.SYNOPSIS
    Audits MFA registration status for all active tenant users and exports a compliance report.
#>

[CmdletBinding()]
param(
    [string]$ReportPath = "./MFA_Compliance_Report_$(Get-Date -Format 'yyyyMMdd').csv"
)

Write-Host "[*] Auditing tenant MFA registration status..." -ForegroundColor Cyan

try {
    $users = Get-MgUser -Filter "accountEnabled eq true" -Property Id, DisplayName, UserPrincipalName, Department -All
    $report = @()

    foreach ($u in $users) {
        $authMethods = Get-MgUserAuthenticationMethod -UserId $u.Id -ErrorAction SilentlyContinue
        $hasMfa = ($authMethods | Where-Object { $_.AdditionalProperties['@odata.type'] -ne '#microsoft.graph.passwordAuthenticationMethod' }).Count -gt 0

        $report += [PSCustomObject]@{
            UserPrincipalName = $u.UserPrincipalName
            DisplayName       = $u.DisplayName
            Department        = $u.Department
            MFA_Registered    = $hasMfa
            Status            = if ($hasMfa) { "COMPLIANT" } else { "ACTION_REQUIRED" }
        }
    }

    $report | Export-Csv -Path $ReportPath -NoTypeInformation -Encoding utf8
    Write-Host "[+] Audit complete. Report exported to: $ReportPath" -ForegroundColor Green

} catch {
    Write-Error "[-] Audit failed: $_"
}
