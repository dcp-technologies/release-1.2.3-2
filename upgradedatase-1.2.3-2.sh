#!/bin/bash

# Load environnement variables
. $(pwd)/env/env.sh
. $(pwd)/env/env-sensitive.sh
. $(pwd)/env/env-database.sh
. $(pwd)/env/env-logwatcher.sh
. $(pwd)/env/env-podwatcher.sh
. $(pwd)/env/env-proxy.sh
. $(pwd)/env/env-logstack.sh
. $(pwd)/env/env-redis.sh


# DATABASE
echo '************************ START UPGRADE ' $PREFIX ' DATABASE ************************'

#INIT DATABASE
if [[ $initdatabase == "true" ]]; then
    echo '************************ UPGRADING ' $PREFIX ' DATABASE ************************'
    sed -e "s#{{DIRVALUES}}#$DIRVALUES#g;\
    s#{{UPLOADDIRECTORY}}#$UPLOADDIRECTORY#g;\
    s#{{IMAGEPULLSECRET}}#$IMAGEPULLSECRET#g;\
    s#{{ISOPENSHIFT}}#$ISOPENSHIFT#g;\
    s#{{ENABLEOSROOT}}#$ENABLEOSROOT#g;\
    s#{{NAMESPACE}}#$NAMESPACE#g;\
    s#{{REGISTRY}}#$REGISTRY#g;\
    s#{{REPOSITORY}}#$REPOSITORY#g;\
    s#{{DEFAULT_CLOUD_NAME}}#$DEFAULT_CLOUD_NAME#g;\
    s#{{REDISPASWORD}}#$REDISPASWORD#g;\
    s#{{DCPSTORAGEACCESSKEY}}#$DCPSTORAGEACCESSKEY#g;\
    s#{{DCPSTORAGESECRETKEY}}#$DCPSTORAGESECRETKEY#g;\
    s#{{CREATESPARKHISTORYPATH}}#$CREATESPARKHISTORYPATH#g;\
    s#{{USERKEYCLOAKSERVICENAME}}#$USERKEYCLOAKSERVICENAME#g;\
    s#{{NINXCLASS}}#$NINXCLASS#g;\
    s#{{SECRETNAME}}#$SECRETNAME#g;\
    s#{{PULLPOLICY}}#$PULLPOLICY#g;\
    s#{{DOMAIN}}#$DOMAIN#g;\
    s#{{USEINGRESSCLASSNAME}}#$USEINGRESSCLASSNAME#g;\
    s#{{KUBEHOST}}#$KUBEHOST#g;\
    s#{{KUBEPORT}}#$KUBEPORT#g;\
    s#{{KUBEDNS}}#$KUBEDNS#g;\
    s#{{KUBELOG}}#$KUBELOG#g;\
    s#{{LDAP_URL}}#$LDAP_URL#g;\
    s#{{INGRESSHOSTNAME}}#$INGRESSHOSTNAME#g;\
    s#{{GRAFANA_NAME}}#$GRAFANA_NAME#g;\
    s#{{CLUSTERDOMAIN}}#$CLUSTERDOMAIN#g;\
    s#{{REDIS_SERVICENAME}}#$REDIS_SERVICENAME#g;\
    s#{{STORAGE_ACCESSKEY}}#$STORAGE_ACCESSKEY#g;\
    s#{{STORAGE_SECRETKEY}}#$STORAGE_SECRETKEY#g;\
    s#{{PGS_SERVICENAME}}#$PGS_SERVICENAME#g;\
    s#{{PGS_DATABASE}}#$PGS_DATABASE#g;\
    s#{{PGS_USERNAME}}#$PGS_USERNAME#g;\
    s#{{PGS_PASSWORD}}#$PGS_PASSWORD#g;\
    s#{{PREFIX}}#$PREFIX#g;\
    s#{{GRAFANA_INGRESS_HOSTNAME}}#$GRAFANA_INGRESS_HOSTNAME#g;\
    s#{{GRAFANA_INGRESS_PATH}}#$GRAFANA_INGRESS_PATH#g;\
    s#{{ROOTREPO}}#$ROOTREPO#g;" $yamltemplate/upgrade-cm-1.2.3-2-template.yaml > $yamldestination/upgrade-cm-1.2.3-2.yaml
    
    
    sed -e "s#{{REGISTRY}}#$REGISTRY#g;\
    s#{{IMAGEPULLSECRET}}#$IMAGEPULLSECRET#g;\
    s#{{PGS_REPLICATION_REPOSITORY}}#$PGS_REPLICATION_REPOSITORY#g;\
    s#{{PGS_REPLICATION_VERSION}}#$PGS_REPLICATION_VERSION#g;\
    s#{{PGS_SERVICENAME}}#$PGS_SERVICENAME#g;\
    s#{{NAMESPACE}}#$NAMESPACE#g;\
    s#{{CLUSTERDOMAIN}}#$CLUSTERDOMAIN#g;\
    s#{{PGS_USERNAME}}#$PGS_USERNAME#g;\
    s#{{PGS_PASSWORD}}#$PGS_PASSWORD#g;\
    s#{{RUNASUSER}}#$RUNASUSER#g;\
    s#{{READONLYROOTFILESYSTEM}}#$READONLYROOTFILESYSTEM#g;\
    s#{{PULLPOLICY}}#$PULLPOLICY#g;\
    s#{{COMMONLABELSHEIGHT}}#$COMMONLABELSHEIGHT#g;\
    s#{{PGS_DATABASE}}#$PGS_DATABASE#g;" $yamltemplate/upgrade-Job-1.2.3-2-template.yaml > $yamldestination/upgrade-Job-1.2.3-2.yaml

    if [[ $template == "false" ]]; then
        echo 'Start upgrade to 1.2.3-2 .........'
        kubectl -n $NAMESPACE apply -f $yamldestination/upgrade-cm-1.2.3-2.yaml
        sleep 3
        kubectl -n $NAMESPACE delete -f $yamldestination/upgrade-Job-1.2.3-2.yaml
        sleep 3
        kubectl -n $NAMESPACE apply -f $yamldestination/upgrade-Job-1.2.3-2.yaml
    fi
else
    echo '=================================== UPGRADE ' $PREFIX  ' DATABASE DISABLED ==================================='
fi
echo '************************ END UPGRADE ' $PREFIX ' DATABASE ************************'
echo ''
echo ''