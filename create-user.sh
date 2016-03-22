#!/usr/bin/env bash

set -e
set -o pipefail

mongod --dbpath=${MONGO_DBPATH} &
counter=10
while ! mongo admin --eval 'db.getSiblingDB("$external").runCommand({createUser: "CN=admin,OU=JSDev,O=Jaspersoft,L=San Francisco,ST=CA,C=US", roles: [{ role: "root", db: "admin"}]});'; do   
    ((counter--))
    if [[ $counter = 0 ]];then
        break
    fi
    sleep 5
done

mongo admin --eval "db.shutdownServer({timeoutSecs: 3});"
sleep 3
