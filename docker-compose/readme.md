# docker-compose

## 📶 Network 📶

Before deploying any compose files, a shared network will need to be defined for all containers to connect on.

None of these compose files generate their own network. This is so the compose manager UI can be deployed before a reverse-proxy, and docker labels that use docker host names can be resolved with said compose manager UI.

```bash
docker network create hotbox
# Why hotbox? - Because we all stuck in here together; D.O. Double G! 😶‍🌫️
```

## 📦 Environment 📦

Make note of the global [.env.template](./.env.template). Apart from Portainer or Komodo, other services will make use of them. It is the expectation that these be set on the host, or via other means (Komodo Global Vars); and available to all other stacks.
