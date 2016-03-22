# image to test x509 auth
# database: admin
# username: C=US,ST=CA,L=San Francisco,O=Jaspersoft,OU=JSDev,CN=admin
FROM mongo:3.2

# designate a new data directory (the original one is volumized, no data is persisted)
ENV MONGO_DBPATH /data/test-db
RUN mkdir -p ${MONGO_DBPATH} && chown -R mongodb:mongodb ${MONGO_DBPATH}

COPY create-user.sh /
RUN /create-user.sh && chown -R mongodb:mongodb ${MONGO_DBPATH}

RUN mkdir -p /etc/ssl
COPY mongodb-CA.pem /etc/ssl/
COPY mongodb-server.pem /etc/ssl/
# copy these too, so clients can get them from the image
COPY mongodb-client.pem /etc/ssl/
COPY mongodb-client.jks /etc/ssl/

CMD ["mongod", "--dbpath=/data/test-db", "--sslMode", "requireSSL", "--sslPEMKeyFile", "/etc/ssl/mongodb-server.pem", "--sslCAFile", "/etc/ssl/mongodb-CA.pem", "--auth", "--clusterAuthMode", "x509"]
