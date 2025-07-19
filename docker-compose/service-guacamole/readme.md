# service-guacamole

## 🌍 Installation 🌍

Apache Guacamole does not initialize the database with the required tables.  
You will need to do this yourself, fortunately they provide a script to initialize the database.

The official steps are probably more straight forward:  
https://guacamole.apache.org/doc/gug/guacamole-docker.html.

But I like to do it this way.

Once **apache-guacamole-db** has been deployed. The following steps will be:  
~ Extract the script from guacamole docker image.  
~ Copy to your apache-guacamole-db container.  
~ Enter the container terminal and run the script.

```bash
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > ./tmp/guacinitdb.sql

docker cp /tmp/guacinitdb.sql service-guacamole-db:/guacinitdb.sql

docker exec -it apache-guacamole-db bash

cat /guacinitdb.sql | mysql -u guacamole_user -p guacamole_db
```

**Now you can restart your services.**

🤫 Your super secret default username and password will be **guacadmin**

## 🔑 OIDC 🔑

There is a current issue opened with Apache Guacamole to resolve newer security recommendations set out by OpenAuth. Currently, when making an authorization request, the query param _'state'_ is not provided.

This will result in failure from several OIDC Providers, such as Authelia and OKTA.

Apache Guacamole have an open issue for this, but don't seem to have any plans to upgrade yet:  
https://issues.apache.org/jira/browse/GUACAMOLE-808

This is an important security feature as described here:  
https://auth0.com/docs/secure/attack-protection/state-parameters

With a little more reading here:  
3.1.2.1 https://openid.net/specs/openid-connect-core-1_0.html#AuthRequest  
3.2.2.5 https://openid.net/specs/openid-connect-core-1_0.html#ImplicitAuthResponse

#### 🔥 Warning 🔥

You should not attempt to workaround this by manually putting something like _'?state=ralphmoment'_ into your client configuration. You risk exposure by a bad actor.

#### ✌️ Alternative ✌️

Unfortunately, they are limited. You can either go:  
~ Barebone with normal authentication.  
~ Bareback with authorization server routes.  
~ Full Bundy with both. 🌮🤷‍♀️🌮

#### ⌚ Future Configuration ⌚

When fixed, this configuration will allow the enablement of OIDC.

```yml
services:
  service-guacamole-client:
    image: guacamole/guacamole:1.6.0
    environment:
      - OPENID_AUTHORIZATION_ENDPOINT=${VAR_OIDC_ROUTE_AUTH}
      - OPENID_JWKS_ENDPOINT=${VAR_OIDC_ROUTE_JKWS}
      - OPENID_ISSUER=${VAR_OIDC_ENDPOINT}
      - OPENID_CLIENT_ID=service-guacamole
      - OPENID_REDIRECT_URI=${VAR_OIDC_REDIRECT_URI}
      - OPENID_USERNAME_CLAIM_TYPE=preferred_username
      - OPENID_GROUPS_CLAIM_TYPE=groups
      - OPENID_SCOPE=openid profile groups email
```
