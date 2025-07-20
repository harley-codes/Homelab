# service-portainer

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
