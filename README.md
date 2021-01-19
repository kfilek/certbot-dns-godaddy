# certbot-dns-godaddy
## Introduction
Docker Image to create and renew LetsEncypt certificates for a wildcard domain using GoDaddy DNS API.   
Currently only a single domain is supported.   
The image is based on debian:buster and rather large (110MB). 

The active container is doing nothing most of the time.  
In random 12-18 hour intervals it wakes up and checks for a certificate renewal.  

## Configuration
Set environment variables to configure your domain name and all other information required.

### Environment Varaibles
- ROOT_DOMAIN ... Your domain name like e.g. "mydomain.com". The resulting certificate domain will be "*.mydomain.com"
- REGISTER_EMAIL ... Your email address for registering with LetsEncrypt.
- API_KEY ... The key for authentication with to the GoDaddy DNS API
- API_SECRET ... The secret for authentication with the GoDaddy DNS API 
- TEST .. Set it to "false" for production opration. If set to "true" (default), certbot will be called with the --staging option for testing.

### Volumes
- /etc/letsencrypt ... contains all LetsEncrypt registrytion data, certficates etc.

If this volume is mounted to a location at the host, the SSL certificates can be accessed by other services.

### Logging
Map container directoy /var/log/letsencrypt to a location on the host to access all certbot logs.

## How to run
Example:
> #!/bin/bash   
> CONTAINER_MOUNT="docker run --mount type=bind,source=/etc/letsencrypt/,target=/etc/letsencrypt/ --mount type=bind,source=/var/log/letsencrypt/,target=/var/log/letsencrypt/"   
> CONTAINER_ENV="-e ROOT_DOMAIN=mydomain.com -e API_KEY=9llkjsdfiuewroisfdkknfriun76236 -e API_SECRET=ljkasdfoiuwenf8734 -e REGISTER_EMAIL=admin@mydomain.com -e TEST=false"   
> DOCKER_CREATE_ARGS="--name mycertbot $CONTAINER_ENV $CONTAINER_MOUNT --restart unless-stopped filek/certbot-dns-godaddy"   
> docker create $DOCKER_CREATE_ARGS   
>   
> docker start mycertbot   

## TODO
- log file rotation
- support multiple domains
- slim image
