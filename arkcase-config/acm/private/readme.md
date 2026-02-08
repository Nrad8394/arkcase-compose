# Keystore and Truststore files
In this folder we keep the **keystore** and **truststore** files used for the following Arkcase features (in brackets the file where the setting is stored and can be changed when needed for locations or passwords):
1. Tomcat keystore (_<catalina.home>/conf/server.xml_)
2. ActiveMQ TLS (_<user.home>/.arkcase/acm/websockets.properties_)
3. SAML SSO feature (_<user.home>/.arkcase/acm/spring-security/spring-security-config-saml.xml_)
4. Property encryption (_<user.home>/.arkcase/acm/encryption/spring-properties-encryption.xml_)
5. Java runtime (_???_)

Follow the next steps to setup the **keystore** and **truststore** files on different environments.

## Create server private key
The private key must be 2048 bit RSA key pair. Use the following command to create the private key for the server:
```
openssl genrsa -aes256 -out intermediate/private/{serverName}.key.pem 2048
```

## Create a certificate
To create the certificate signed by an intermediate CA use the following commands (be sure to set the certificate *Common Name* to {serverName}, since the SSL handshake will compare it to the server URL):
```
openssl req -config intermediate/openssl.cnf -key intermediate/private/{serverName}.key.pem -new -sha256 -out intermediate/csr/{serverName}.csr.pem
openssl ca -config intermediate/openssl.cnf -extensions server_cert -days 3650 -notext -md sha256 -in intermediate/csr/{serverName}.csr.pem -out intermediate/certs/{serverName}.cert.pem
```

## Create the _keystore_ file
The **_keystore_** file should contain the server' private key and certificate along with the whole certificate chain used to create the server certificate.
To create this file having the _{serverName}.cert.pem_, _{serverName}.key.pem_ and _ca-chain.cert.pem_ files, use the following commands (note that the appropriate passwords will have to be set in the settings files mentioned at the top):
```
openssl pkcs12 -export -in acm-arkcase.cert.pem -inkey acm-arkcase.key.pem -out keystore.p12 -name armedia -CAfile ca-chain.cert.pem -caname root -chain
keytool -importkeystore -srckeystore keystore.p12 -srcstoretype PKCS12 -destkeystore keystore -deststoretype JKS
```

## Create the _truststore_ file
The **_trusstore_** file should contain all self signed certificates that are used in the communication between Arkcase and other connected systems. These include the Root CA certificate used to generate the server certificate, the Root CA certificate for the LDAP server (when LDAP profile is used), the Root CA certificate for the ADFS server (when SAML profile is used). To create this file having the _ca-chain.cert.pem_ and _ldap.cert.pem_ files, use the following commands (note that the appropriate passwords will have to be set in the settings file above):
```
keytool -import -trustcacerts -alias arkcase -keystore truststore -file ca-chain.cert.pem
keytool -import -trustcacerts -alias arkcaseIntermediate -keystore truststore -file intermediate.cert.pem
keytool -import -trustcacerts -alias ldap -keystore truststore -file ldap.cert.pem
```