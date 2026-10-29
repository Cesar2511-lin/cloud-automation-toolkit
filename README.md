# Cloud Automation Toolkit

Administrative scripts for Microsoft 365, Microsoft Entra ID (Azure AD), and Active Directory environments. Built with PowerShell and Python.

## Structure

- `IdentityGovernance/New-M365UserOnboarding.ps1`: Creates users via Microsoft Graph PowerShell, configures usage location, temporary password, and department assignments.
- `SecurityCompliance/Audit-MFAConditionalAccess.ps1`: Audits authentication methods across active users and exports a compliance status CSV.
- `GraphApiIntegration/graph_client.py`: Python client for Microsoft Graph API using MSAL for token acquisition, with token caching and retry logic for 429 rate limits.

## Requirements

- PowerShell 7.0+
- Microsoft.Graph PowerShell module (`Install-Module Microsoft.Graph`)
- Python 3.10+ with `msal` and `requests`

## Configuration

Credentials and tenant IDs must be provided via environment variables or interactive prompts. Never commit sensitive credentials or client secrets to source control.

## License

MIT License.
