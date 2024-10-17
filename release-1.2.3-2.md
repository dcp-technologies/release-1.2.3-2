# Nouvelles Images du patch 1.2.3-2
```
dcptechnologies/api:x86-1.2.3-2
dcptechnologies/health:x86-1.2.3-2
dcptechnologies/podwatcher:x86-1.2.3-2
dcptechnologies/logwatcher:x86-1.2.3-2
dcptechnologies/sql:policy-1.0.0-v5
```

# env.sh
Dans le fihier "envs/env.sh", modifier la ligne suivante
```sh
API_VERSION=x86-1.2.3-2
```

# env-api.sh
Dans le fihier "envs/env-api.sh", mModifier la ligne suivante
```sh
MASTER_API_VERSION=1.2.3-2
```

# Script d'ajout des nouvelles ACLs et l'optimisationd des thread pour l'API DCP.
```
Copier le fichier 'master-api-cm.yaml' dans le repo helm d'installation de l'API: master-api->templates

Copier le script "upgradedatase-1.2.3-2.sh" dans la racine du répertoir d'installation

Copir les deux fichiers "upgrade-cm-1.2.3-2-template.yaml" et "upgrade-Job-1.2.3-2-template.yaml" dans le dossier templates
```

# Arrêter les service DCP
Avant d'arrêter les service dcp, s'assurer qu'il n'y a pas de traitement spark en cours
```sh
helm -ndcp uninstall dcpapi dcphealth dcplog dcppodwatcher-backup dcppodwatcher-primary dcppodwatcher-secondary
```

# JOB SQL pour les ACLs
Mettre à jour la base de donnée
```sh
./upgradedatase-1.2.3-2.sh
```

# Installer l'api
```sh
./09-api.sh
```

# Installer le log watcher
```sh
./12-logwatcher.sh
```

# Installer le podwatcher
```sh
./13-podwatcher.sh primary
./13-podwatcher.sh secondary
./13-podwatcher.sh backup
```

# Installe le health-checker
```sh
./14-health.sh
```

# Configuration Globale
Se connecter avec le compte dcpadminusername 

Dans le menu Admin -> Parameter:
    - Activer l'option waitpodend 
    - dcpwaittime = 15000
    - waitthreshold = 10

Dans le menu Admin -> Kubernets
    - selectionner la ligne "local"
    - Aller dans l'onglet Global Configuration -> Infos
        - Vérifier que la configuration "dcpcmsecret" contient la valeur "dcpapi-certmanager"

Dans le menu Admin -> Patch Services
    - Cliquer sur le bouton "Patch Spark Job". afin de corriger l'afficher des queues dans le menu Spark Capacity