#!/bin/bash

if [ "$API_KEY" == "" ]; then
    echo "API_KEY not set!"
    exit 1
fi
echo "API_KEY: $API_KEY"

if [ "$API_SECRET" == "" ]; then
    echo "API_SECRET not set!"
    exit 1
fi
echo "API_SECRET: $API_SECRET"

if [ "$REGISTER_EMAIL" == "" ]; then
    echo "REGISTER_EMAIL not set!"
    exit 1
fi
echo "REGISTER_EMAIL: $REGISTER_EMAIL"

if [ "$ROOT_DOMAIN" == "" ]; then
    echo "ROOT_DOMAIN not set!"
    exit 1
fi
echo "ROOT_DOMAIN: $ROOT_DOMAIN"

STAGING=""
if [ "$TEST" == "true" ]; then
    echo "Staging/Test mode activated!"
    STAGING="--staging"
fi

stop() {
    echo "Received SIGINT or SIGTERM. Shutting down ..."
    exit 0
}
trap stop SIGINT SIGTERM

certbot certonly $STAGING -n --agree-tos --email $REGISTER_EMAIL \
    --manual --preferred-challenges=dns --manual-auth-hook /authenticator.sh -d "*.$ROOT_DOMAIN" || exit 2

while true
do 
    # do renewals 1-2 times a day 
    sleep $[ ( $RANDOM % 6 )  + 12 ]h
    echo "Renewing ..."
    certbot renew $STAGING
done

echo "Finished ..."
