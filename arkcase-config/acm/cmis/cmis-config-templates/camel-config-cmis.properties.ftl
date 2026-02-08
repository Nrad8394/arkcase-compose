<#setting number_format="computer">
# do not change this value once configured, it is used as a discriminator in acm_file and acm_folder tables
cmis.id=${id}
cmis.baseUrl=${baseUrl}
cmis.username=${username}
cmis.password=${password}
cmis.useAlfrescoExtension=${useAlfrescoExtension}
## endpoint is either ATOM or SOAP
cmis.endpoint=${endpoint}
cmis.maxIdle=${maxIdle}
cmis.maxActive=${maxActive}
cmis.maxWait=${maxWait}
cmis.minEvictionMillis=${minEvictionMillis}
cmis.evictionCheckIntervalMillis=${evictionCheckIntervalMillis}
cmis.reconnectCount=${reconnectCount}
cmis.reconnectFrequency=${reconnectFrequency}
## For Alfresco: leave cmis.repositoryId blank. 
## For Documentum: set cmis.repositoryId to the docbase name.
cmis.repositoryId=${repositoryId}
# document versioning support: NONE (OpenCMIS Fileshare), NONE/MINOR/MAJOR (Alfresco, Documentum)
cmis.cmisVersioningState=${cmisVersioningState}
