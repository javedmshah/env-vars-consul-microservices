# Config-as-an-artifact using Hashicorp Consul and Envconsul

This repo demonstrates how to build an envconsul container for the ForgeRock Identity Microservices using base images from Bintray.

This repo supplements the blog [here](https://forum.forgerock.com/2018/04/runtime-config-for-forgerock-microservices-consul/).
It is required that the starting base images have no entrypoint defined and as such the images tagged BASE-ONLY are used and not the ones tagged 1.0.0-SNAPSHOT. The latter are running jetty containers and therefore cannot be used since we are unable to overlay the envconsul process on to them. The base images are also publicly available.

## about envconsul

Envconsul spawns a child process with environment variables populated from HashiCorp Consul and Vault. 
The tool works with no runtime requirements and is also separately available via a Docker container but not used like that in this repo.

Envconsul supports 12-factor applications which get their configuration via the environment. 
Environment variables are dynamically populated from Consul or Vault, but the microservice is unaware.

ForgeRock Identity Microservices simply read environment variables as an override to file-based config. 
This enables extreme flexibility and portability for services across systems.

## vault
Although vault integration is not yet part of this repo, it is coming soon. The demo will show how secrets can be sourced from Vault and made available to the microservice as an environment variable. These would include service accounts used by microservices for connecting
to OpenAM for example.

## Base image
The image uses the public base-only images for the microservices which do not contain an entrypoint command. This is necessary to spawn the microservice from a parent envconsul process.

# Demo
I setup a consul pod in minikube by following these steps:

```docker pull consul
kubectl create -f kube-consul.yaml
```
Next, I ran a basic configuration check to ensure Consul started up correctly. The nodePort is of course from the yaml file in this repo.
```
curl http://192.168.99.100:31100/v1/health/service/consul?pretty
```
Next, you load the key-value export, also provided in this repo:
```
docker cp consul-export.json 28449566632f:/consul-export.json
docker exec -it 28449566632f /bin/sh
cp consul-export.json ./bin
./consul kv import @consul-export.json
```

Now we can check if it loaded correctly.
```
./envconsul -pristine -consul-addr=192.168.99.100:31100 -prefix ms-authn env
TOKEN_ISSUER=https://frauthn.example.com
TOKEN_SUPPORTED_ADDITIONAL_CLAIMS=customClaim
CLIENT_SECRET_SECURITY_SCHEME=none
TOKEN_SIGNATURE_JWK_BASE64=ewogICAgImtpZCIgOiAibXlfaG1hY19rZXkiLAogICAgImt0eSIgOiAiT0NUIiwKICAgICJhbGciIDogIkhTMjU2IiwKICAgICJrIiA6ICJGZEZZRnpFUndDMnVDQkI0NnBaUWk0R0c4NUx1alI4b2J0LUtXUkJJQ1ZRIgp9Cg==
TOKEN_AUDIENCE=https://resource.example.com,https://validation.example.com
TOKEN_DEFAULT_EXPIRATION_SECONDS=3600
CLIENT_CREDENTIALS_STORE=json
INFO_ACCOUNT_PASSWORD=info
METRICS_ACCOUNT_PASSWORD=metrics
ISSUER_JWK_STORE=json

./envconsul -pristine -consul-addr=192.168.99.100:31100 -prefix token-validation env
INTROSPECTION_OPENAM_ID_TOKEN_INFO_URL=http://openam.example.com:8080/openam/oauth2/realms/root/realms/test/idtokeninfo
INTROSPECTION_SERVICES=json,openam
METRICS_ACCOUNT_PASSWORD=metrics
INTROSPECTION_REQUIRED_SCOPE=introspect
ISSUER_JWK_JSON_ISSUER_URI=https://example.com
INTROSPECTION_OPENAM_CLIENT_ID=myoauthclient
INFO_ACCOUNT_PASSWORD=info
INTROSPECTION_OPENAM_SESSION_URL=http://openam.example.com:8080/openam/json/sessions
INTROSPECTION_OPENAM_CLIENT_SECRET=myoauthclient
INTROSPECTION_OPENAM_URL=http://openam.example.com:8080/openam/oauth2/realms/root/realms/test/introspect
ISSUER_JWK_JSON_JWK_BASE64=ewogICAgImtpZCIgOiAibXlfaG1hY19rZXkiLAogICAgImt0eSIgOiAiT0NUIiwKICAgICJhbGciIDogIkhTMjU2IiwKICAgICJrIiA6ICJGZEZZRnpFUndDMnVDQkI0NnBaUWk0R0c4NUx1alI4b2J0LUtXUkJJQ1ZRIgp9Cg==
ISSUER_JWK_STORE=json

./envconsul -pristine -consul-addr=192.168.99.100:31100 -prefix token-exchange env
EXCHANGE_OPENAM_AUTH_URL=http://openam.example.com:8080/openam/json/realms/root/authenticate
TOKEN_SIGNATURE_JWK_BASE64=ewogICAgImtpZCIgOiAibXlfaG1hY19rZXkiLAogICAgImt0eSIgOiAiT0NUIiwKICAgICJhbGciIDogIkhTMjU2IiwKICAgICJrIiA6ICJGZEZZRnpFUndDMnVDQkI0NnBaUWk0R0c4NUx1alI4b2J0LUtXUkJJQ1ZRIgp9Cg==
ISSUER_JWK_JSON_ISSUER_URI=https://frauthn.example.com
EXCHANGE_OPENAM_POLICY_ALLOWED_ACTORS_ATTR=may_actors
EXCHANGE_OPENAM_POLICY_SET_ID=resource_policies
EXCHANGE_OPENAM_POLICY_SUBJECT_ATTR=uid
EXCHANGE_OPENAM_POLICY_COPY_ADDITIONAL_ATTR=true
EXCHANGE_OPENAM_AUTH_SUBJECT_PASSWORD=cangetinam
EXCHANGE_JWT_INTROSPECT_URL=http://192.168.99.100:30103/service/introspect
INFO_ACCOUNT_PASSWORD=info
TOKEN_EXCHANGE_REQUIRED_SCOPE=exchange
ISSUER_JWK_STORE=json
ISSUER_JWK_OPENID_URL=http://openam.example.com:8080/openam/oauth2/.well-known/openid-configuration
METRICS_ACCOUNT_PASSWORD=metrics
EXCHANGE_OPENAM_POLICY_SCOPE_ATTR=scp
EXCHANGE_OPENAM_AUTH_SUBJECT_ID=amadmin
TOKEN_EXCHANGE_POLICIES=openam,json
ISSUER_JWK_JSON_JWK_BASE64=ewogICAgImtpZCIgOiAibXlfaG1hY19rZXkiLAogICAgImt0eSIgOiAiT0NUIiwKICAgICJhbGciIDogIkhTMjU2IiwKICAgICJrIiA6ICJGZEZZRnpFUndDMnVDQkI0NnBaUWk0R0c4NUx1alI4b2J0LUtXUkJJQ1ZRIgp9Cg==
EXCHANGE_OPENAM_POLICY_AUDIENCE_ATTR=aud
EXCHANGE_OPENAM_POLICY_URL=http://openam.example.com:8080/openam/json/realms/root/policies
TOKEN_ISSUER=https://frtokenexchange.example.com
```
