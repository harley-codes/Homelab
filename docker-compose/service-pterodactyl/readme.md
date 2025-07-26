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
