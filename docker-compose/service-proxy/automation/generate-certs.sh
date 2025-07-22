#!/usr/bin/env bash
openssl genrsa -out ./configuration/authelia/keys/oidc-jwks/private.pem 4096
openssl rsa -in ./configuration/authelia/keys/oidc-jwks/private.pem -outform PEM -pubout -out ./configuration/authelia/keys/oidc-jwks/public.pem


