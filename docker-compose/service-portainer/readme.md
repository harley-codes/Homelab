# service-portainer

## 🌍 Installation 🌍

There is only one variable set in the docker compose file.

It can be set on the host, but for a more simple approach, you can run the **_compose up -d_** command with the variable piped through.

```bash
VAR_PROXY_HOST_ROUTE=this.contoso.com docker compose up -d
```

## 🔑 OIDC 🔑

When your ready to enable single sign on. This can be done from the Portainer web interface.

Authelia has a community written document that converts the setup:  
https://www.authelia.com/integration/openid-connect/portainer/

Goto https://portainer.contoso.com/#!/settings/auth  
~ Set authentication method to OAuth  
~ Toggle **Use SSO** if not already enabled.  
~ Enter client details as follows:

```
ClientID=service-portainer
ClientSecret=iTunesForLyfe
AuthorizationURL=https://<auth-endpoint>/api/oidc/authorization
AccessTokenURL=https://<auth-endpoint>/api/oidc/token
ResourceURL=https://<auth-endpoint>/api/oidc/userinfo
RedirectURL=https://<portainer-endpoint>
UserIdentifier=preferred_username
Scopes=openid profile groups email
AuthStyle=InParams
```

NOTE: Scopes should not be separated by commas.
