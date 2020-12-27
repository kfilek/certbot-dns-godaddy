#!/bin/bash


URL="https://api.godaddy.com"
CHALLENGE="_acme-challenge"

CREATE_URL="$URL/v1/domains/$ROOT_DOMAIN/records/TXT/$CHALLENGE"

[ "$CERTBOT_VALIDATION" == "" ] && CERTBOT_VALIDATION="not set"

echo "Validation: $CERTBOT_VALIDATION"
echo "Token: $CERTBOT_TOKEN"

# Create TXT record
RESULT=$(curl -s -X PUT "$CREATE_URL" \
     -H     "Authorization: sso-key $API_KEY:$API_SECRET" \
     -H     "accept: application/json" \
     -H     "Content-Type: application/json" \
     --data '[{"type":"TXT","name":"'"$CHALLENGE"'","data":"'"$CERTBOT_VALIDATION"'","ttl":600}]') 

echo "Result: $RESULT"

# wait for the record to actually show up (the builtin time out is WAY too sort)
sleep 5s

COUNT=0
while [[ 5 -gt $COUNT ]]
do
    ((COUNT=COUNT+1))

    RECORDSET=$(dig "$CHALLENGE.$ROOT_DOMAIN" TXT +short | tr -d "\"")
    if [[ $RECORDSET == ${CERTBOT_VALIDATION} ]]
    then
        echo "Record found: $RECORDSET"
        sleep 5s
        break
    else
        echo "Record not found: $RECORDSET"
        sleep 10s
    fi
done
