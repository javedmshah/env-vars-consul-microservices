# Config-as-an-artifact using Hashicorp Consul and Envconsul

This repo demonstrates how to build an envconsul container for the ForgeRock Identity Microservices using base images from Bintray.
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
