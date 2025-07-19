# docker-compose

Before deploying an compose files, a shared network will need to be defined for all containers to connect on.

None of these compose files generate their own network. This is so Portainer can be deployed before a reverse-proxy, and docker labels that use docker host names can be resolved with Portainer.

```bash
docker network create hotbox
# Why hotbox? - Because we all stuck in here together; D.O. Double G! 😶‍🌫️
```
