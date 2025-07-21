# service-portainer

## 🌍 Installation 🌍

Default Komodo setup takes the approach of using environment file over a standard _configuration.yml_ file. This is actually a pretty neat implementation when setting up from scratch.

From a configuration perspective though. It would be nice to have a deployment template where things like secrets are separate from the overall configuration. As most of those values wont change over time, or across re-deployments.

It appears that Komodo is doing some env parsing on the file, based on _PERIPHERY_PASSKEYS=${KOMODO_PASSKEY}_ being set inside the env file itself.

So with that, we should be able to easily double up and wrap additional variable from a custom env template.

```bash
# CD into docker-compose\service-komodo
sudo chmod 600 .env
sudo chown root:root .env
sudo chmod 600 .env.merged
sudo chown root:root .env.merged

sudo cat .env .env.config > .env.merged

sudo docker compose -p service-komodo -f service-komodo.compose.yml --env-file .env.merged up -d
```
