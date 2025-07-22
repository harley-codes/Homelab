# service-proxy

## 🌍 Installation 🌍

Due to the complexity of this stack. All configuration files names are appended with '\*.template.\*', and need to be parsed into there '\*.\*\' counterpart.

The '\*.template.\*' files have some key values that need substituting from the environment.  
There is an automation script that will handle this, so long as the environment files exist.  
~ ./.env  
~ ../.env

```bash
# From the docker-compose\service-proxy directory.
bash ./automation/pars-configurations.sh
```

### Traefik Cert Resolver

Unfortunately, there is no way around this extra step in order to keep certs on a persistent volume. Traefik will not make the file for you.

```
cd /var/lib/docker/volumes/service-proxy_service-proxy-traefik-output/_data/
sudo mkdir certs
sudo touch certs/cloudflare-acme.json
sudo chmod 600 certs/cloudflare-acme.json
sudo chown root:root certs/cloudflare-acme.json
```
