#!/bin/bash
# Tomcat environment setup script
# This script is sourced by catalina.sh to set CATALINA_OPTS safely

# Set Java memory options
CATALINA_OPTS="-Xms2g -Xmx4g"

# Add Spring datasource properties with proper quoting
CATALINA_OPTS="$CATALINA_OPTS -Dspring.datasource.url='jdbc:mysql://mariadb:3306/arkcase?autoReconnect=true&useUnicode=true&characterEncoding=utf8&serverCharset=utf8mb3'"
CATALINA_OPTS="$CATALINA_OPTS -Dspring.datasource.username=arkcase"
CATALINA_OPTS="$CATALINA_OPTS -Dspring.datasource.password=${DB_PASSWORD:-changeme}"
CATALINA_OPTS="$CATALINA_OPTS -Dspring.datasource.driver-class-name=org.mariadb.jdbc.Driver"

# Add Solr configuration
CATALINA_OPTS="$CATALINA_OPTS -Dsolr.host=solr -Dsolr.port=8983"

# Add ActiveMQ configuration
CATALINA_OPTS="$CATALINA_OPTS -Dactivemq.broker.url=tcp://activemq:61616"

# Add Alfresco configuration
CATALINA_OPTS="$CATALINA_OPTS -Dalfresco.host=alfresco -Dalfresco.port=8080"

# Add Configuration Server properties
CATALINA_OPTS="$CATALINA_OPTS -Dconfig.server.url=http://config-server:9999"
CATALINA_OPTS="$CATALINA_OPTS -Dacm.configurationserver.url=http://config-server:9999"
CATALINA_OPTS="$CATALINA_OPTS -Dacm.configurationserver.propertyfile=/home/arkcase/.arkcase/acm/conf.yml"

# Add SSL configuration
CATALINA_OPTS="$CATALINA_OPTS -Dserver.ssl.enabled=true"
CATALINA_OPTS="$CATALINA_OPTS -Dserver.ssl.key-store=/opt/arkcase/certs/keystore.p12"
CATALINA_OPTS="$CATALINA_OPTS -Dserver.ssl.key-store-password=${KEYSTORE_PASSWORD:-changeme}"
CATALINA_OPTS="$CATALINA_OPTS -Dserver.ssl.keyStoreType=PKCS12"

# Disable LDAP connection pooling to prevent issues and use G1GC
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.jndi.ldap.connect.pool=false -XX:+UseG1GC -XX:MaxGCPauseMillis=200"

# Export to tomcat
export CATALINA_OPTS
