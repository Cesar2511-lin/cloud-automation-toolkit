# Enterprise Cloud & IT Automation Toolkit ⚡

[![PowerShell](https://img.shields.io/badge/PowerShell-7.4+-5391FE?style=flat&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)
[![Microsoft 365](https://img.shields.io/badge/Microsoft%20365-Admin-0078D4?style=flat&logo=microsoft)](https://admin.microsoft.com/)
[![Azure Entra ID](https://img.shields.io/badge/Entra%20ID-Azure%20AD-0089D6?style=flat&logo=microsoft-azure)](https://entra.microsoft.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A curated collection of production-grade automation scripts and modules designed to streamline user lifecycle governance, enforce identity security policies, and automate administrative routines across **Microsoft 365, Microsoft Entra ID (Azure AD), and hybrid Active Directory** environments.

---

## 📂 Modules & Tooling

```
cloud-automation-toolkit/
├── IdentityGovernance/
│   ├── New-M365UserOnboarding.ps1       # Automated provisioning, licensing & group assignment
│   └── Disable-OffboardedUser.ps1       # Secure revocation, mailbox preservation & session revocation
├── SecurityCompliance/
│   ├── Audit-MFAConditionalAccess.ps1   # Multi-factor authentication compliance auditor & CSV report
│   └── Check-StaleAccounts.ps1          # Detects dormant active accounts older than 90 days
└── GraphApiIntegration/
    ├── graph_client.py                  # Resilient Python client with OAuth2 token caching
    └── requirements.txt
```

---

## 🚀 Key Implementations

### 1. Identity Governance & User Lifecycle
* **`New-M365UserOnboarding.ps1`**: Standardizes onboarding by creating cloud identities via Microsoft Graph, assigning usage locations, attaching specific SKU license tiers, and placing users into department security groups without manual admin intervention.
* **`Disable-OffboardedUser.ps1`**: Enforces strict Zero-Trust offboarding: resets credentials, revokes active refresh tokens, blocks sign-in, removes group memberships, converts mailboxes to shared mailboxes, and preserves litigation hold if required.

### 2. Security & Compliance Automation
* **`Audit-MFAConditionalAccess.ps1`**: Scans tenant directory for authentication methods registered per user. Generates automated compliance metrics and outputs actionable CSV reports for audit readiness.
* **`Check-StaleAccounts.ps1`**: Identifies active user objects with `lastSignInDateTime` exceeding 90 days to eliminate unmonitored attack vectors and optimize licensing costs.

### 3. Microsoft Graph API Python Client
* **`graph_client.py`**: A robust Python wrapper utilizing `MSAL` (Microsoft Authentication Library) implementing:
  - Automated client credential OAuth2 authentication.
  - Secure in-memory token caching with proactive expiry refresh.
  - Exponential backoff retry logic for HTTP `429 (Too Many Requests)` rate-limit resilience.

---

## 🛠️ Security Best Practices
- **Zero Hardcoded Credentials**: All scripts consume parameters via environment variables or Azure Key Vault / PSCredential objects.
- **Least Privilege Access**: Requires only scoped Microsoft Graph application permissions (`User.ReadWrite.All`, `Directory.Read.All`).
- **Audit Logging**: Structured JSON / CSV logging for administrative action traceability.

---

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
