# service-pterodactyl

## 🥇 First Time Setup 🥇

### New User

After you have deployed the Pterodactyl Panel, you will need to make a user so you can login. Check the container logs to see how its progress is going, you should see the database migration occur on startup.

Once done, connect to the panels container and run this command.  
As per the [official documentation](https://pterodactyl.io/panel/1.0/getting_started.html#add-the-first-user) the password "must meet the following requirements: 8 characters, mixed case, at least one number".

```sh
php artisan p:user:make
```

The output should look something like this.

```
+----------+--------------------------------------+
| Field    | Value                                |
+----------+--------------------------------------+
| UUID     | cee2deaf-8f50-4941-acba-f04dca34b2b9 |
| Email    | user@example.com                     |
| Username | user                                 |
| Name     | Bilbo Swaggins                       |
| Admin    | Yes                                  |
+----------+--------------------------------------+
```

<hr/>

### Wing Configuration

After you have logged into the Pterodactyl Panel, you will need to create a location and a node. The name of these can be whatever you want.

In the node setup, configure these settings.

```properties
Node: Visibility: public
FQDN: hot-wings.contoso.com # this is an example
CommunicateOverSSL: Use SSL Connection
BehindProxy: Behind Proxy
DaemonPort: 443
DaemonSFTPPort: 2020
```

For the IP Allocations, this will be the host IP, meaning whatever is hosting the docker containers; despite recommended settings.

<hr/>

### Wing Deploy

Now you will need to copy across the generated configuration, but first make some changes.

In the panel we configure DaemonPort to be 443, but **Traefik** is being used to provide access with a FQDN to port 8080.

```
api:
  host: 0.0.0.0
  port: 8080
```

We need some additional setup so the wing can successfully manage the auto created docker network. By default it will try and use a subnet that is already taken.

_This only becomes an issue as we are shoving everyone onto one host. Typically a wing would be installed by itself on a separate server._

```
docker:
  network:
    interfaces:
      v4:
        subnet: 172.32.0.0/16
        gateway: 172.32.0.1
```

Overall, the configuration you copy over should look like this.

```config
debug: false
uuid: ********************************
token_id: ****************************
token: *******************************
api:
  host: 0.0.0.0
  port: 8080
  ssl:
    enabled: false
    cert: /etc/letsencrypt/live/gameserver-wing.tornet.casa/fullchain.pem
    key: /etc/letsencrypt/live/gameserver-wing.tornet.casa/privkey.pem
  upload_limit: 100
system:
  data: /var/lib/pterodactyl/volumes
  sftp:
    bind_port: 2020
allowed_mounts: []
remote: 'https://hot-wings.contoso.com'
docker:
  network:
    interfaces:
      v4:
        subnet: 172.32.0.0/16
        gateway: 172.32.0.1
```
