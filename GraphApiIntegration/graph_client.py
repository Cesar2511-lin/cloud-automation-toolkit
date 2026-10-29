"""
GraphApiIntegration/graph_client.py
Resilient Microsoft Graph API Client with OAuth2 Token Caching and Retry Handling.
"""

import os
import time
import requests
import msal
import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("GraphClient")

class MicrosoftGraphClient:
    def __init__(self, tenant_id: str, client_id: str, client_secret: str):
        self.tenant_id = tenant_id
        self.client_id = client_id
        self.client_secret = client_secret
        self.authority = f"https://login.microsoftonline.com/{tenant_id}"
        self.scope = ["https://graph.microsoft.com/.default"]
        self._app = msal.ConfidentialClientApplication(
            client_id=self.client_id,
            client_credential=self.client_secret,
            authority=self.authority
        )
        self._token = None
        self._token_expires_at = 0

    def get_valid_token(self) -> str:
        """Acquires or refreshes application token using MSAL in-memory cache."""
        now = time.time()
        if self._token and now < self._token_expires_at - 60:
            return self._token

        result = self._app.acquire_token_silent(self.scope, account=None)
        if not result:
            result = self._app.acquire_token_for_client(scopes=self.scope)

        if "access_token" in result:
            self._token = result["access_token"]
            self._token_expires_at = now + result.get("expires_in", 3600)
            return self._token
        else:
            raise PermissionError(f"Failed to acquire Graph API token: {result.get('error_description')}")

    def get_users(self, top: int = 25) -> list:
        """Fetches directory users with automatic retry on throttling (HTTP 429)."""
        token = self.get_valid_token()
        url = f"https://graph.microsoft.com/v1.0/users?$top={top}&$select=id,displayName,userPrincipalName,department"
        headers = {
            "Authorization": f"Bearer {token}",
            "Accept": "application/json"
        }

        for attempt in range(3):
            resp = requests.get(url, headers=headers, timeout=10)
            if resp.status_code == 200:
                return resp.json().get("value", [])
            elif resp.status_code == 429:
                retry_after = int(resp.headers.get("Retry-After", 2 ** attempt))
                logger.warning(f"Throttled (429). Backing off for {retry_after}s...")
                time.sleep(retry_after)
            else:
                resp.raise_for_status()
        return []

if __name__ == "__main__":
    logger.info("Microsoft Graph Client initialized. Ready for scoped automation.")
