# rzhilkibaev/mongo-x509-auth-ssl
[![](http://dockeri.co/image/rzhilkibaev/mongo-x509-auth-ssl)](https://registry.hub.docker.com/u/rzhilkibaev/mongo-x509-auth-ssl/)

MongoDB 3.2 with TLS/SSL and x509 authentication.
This image is intended to be used for testing purposes as it contains insecure self-signed certificates and publicly accessible keypairs.

# How to use this image

    docker run --name mongo-x509 -p 27017:27017 rzhilkibaev/mongo-x509-auth-ssl
This will start up MongoDB listening on 27017.

# Connecting from command line using mongo

    $ docker cp mongo-x509:/etc/ssl/mongodb-client.jks mongodb-client.pem
    $ docker cp mongo-x509:/etc/ssl/mongodb-client.jks mongodb-CA.pem
    $ mongo localhost/admin --ssl --sslPEMKeyFile mongodb-client.pem --sslCAFile mongodb-CA.pem \
        --authenticationDatabase '$external' --authenticationMechanism MONGODB-X509 \
        -u "C=US,ST=CA,L=San Francisco,O=Jaspersoft,OU=JSDev,CN=admin"
This will copy client and CA pem files to the host and start mongo client.
      
# Connecting from Java using mongo-java-driver

    $ docker cp mongo-x509:/etc/ssl/mongodb-client.jks mongodb-client.jks
This will copy JKS store file from the image to the host. Now you can use it in java. 
```java
System.setProperty("javax.net.ssl.trustStore", "mongodb-client.jks");
System.setProperty("javax.net.ssl.trustStorePassword", "123456");
System.setProperty("javax.net.ssl.keyStore", "mongodb-client.jks");
System.setProperty("javax.net.ssl.keyStorePassword", "123456");

MongoClientURI connectionString = new MongoClientURI("mongodb://localhost:27017/admin?authMechanism=MONGODB-X509&ssl=true");
MongoClient mongoClient = new MongoClient(connectionString);
```

# How to build this image

You can generate certificates and keys for your own server if localhost doesn't work for you.

    $ ./generate-certs HOSTNAME
    $ docker build -t my-image --no-cache .
