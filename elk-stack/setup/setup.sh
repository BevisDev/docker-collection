#!/bin/bash

# check exists elasticsearch password
if [ -z $ELASTIC_PASSWORD ]; then
    echo "ELASTIC_PASSWORD is empty";
    exit 1;
fi;

# check exists kibana passoword
if [ -z $KIBANA_PASSWORD ]; then
    echo "KIBANA_PASSWORD is empty";
    exit 1;
fi;

# create CA
if [ ! -f config/certs/ca.zip ]; then
    echo "=========Creating CA";
    yes | bin/elasticsearch-certutil ca --silent --pem -out config/certs/ca.zip;
    
    # check certs
    if [ ! -f config/certs/ca.zip ]; then
        echo "==========Create CA failed";
        exit 1;
    fi
    
    unzip config/certs/ca.zip -d config/certs;
fi;

# create certs
if [ ! -f config/certs/certs.zip ]; then
    echo "=========Creating certs";
    yes | bin/elasticsearch-certutil cert --silent --pem -out config/certs/certs.zip --in instances.yml --ca-cert ${PATH_ES_CA_CERT} --ca-key ${PATH_ES_CA_KEY};
    
    # check certs
    if [ ! -f config/certs/certs.zip ]; then
        echo "==========Create certs failed";
        exit 1;
    fi

    unzip config/certs/certs.zip -d config/certs;
fi;

# Health check elasticsearch
echo "=========Waiting for Elasticsearch availability"
until curl -s https://$ES01_HOST --cacert ${PATH_ES_CA_CERT} | grep -q "missing authentication credentials"; do sleep 30; done;

echo "=========Setting kibana_system password";
until curl -s -X POST https://$ES01_HOST/_security/user/$KIBANA_USERNAME/_password -u "$ELASTIC_USERNAME:$ELASTIC_PASSWORD" -H "Content-Type: application/json" -d "{\"password\":\"$KIBANA_PASSWORD\"}" --cacert ${PATH_ES_CA_CERT}| grep -q "^{}"; do sleep 10; done;  

echo "=========All done!";
