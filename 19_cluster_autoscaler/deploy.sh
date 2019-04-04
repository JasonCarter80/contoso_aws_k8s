#!/usr/local/bin/bash
throw_error() {
    echo  -e "\e[01;31m$1\e[0m" 1>&2
    if [ "$2" == "1" ]; then
        usage;
    fi
    exit 1
}

usage() {
    cat <<EOM

Usage:
    $(basename $0) ACTION PROJECT FOLDER
    -a, --action        apply, destroy
    -p, --project       shared-us-east-1
    -f, --folder        20_software_folder

EOM
    exit 0
}

##### Load and Validate Command Line Arguments
for i in "$@"
do
case $i in
    apply|destroy)
        ACTION="$1"
        shift 1
        ;;
    -a|--action)
        ACTION="$2"
        shift 2
        ;;
    shared*|prod*|dev*|staging*|demo*)
        PROJECT="$1"
        shift 1
        ;;
    -p|--project)
        PROJECT="$2"
        shift 2 
        ;;
    -f|--folder)
        FOLDER="$2"
        shift 2
        ;;
    *)
        if [ ! "$1" == "" ]; then
            if [ -d $1 ]; then
                FOLDER="$1"
                shift 1               
            fi
        fi
        ;;    
esac
done

if [ "$CLUSTER_NAME" == "" ]; then
    CLUSTER_NAME=$PROJECT
fi

#### Action Provided
if [ "$ACTION" == "" ]; then
     throw_error "Error: ACTION invalid/not set!" 1
fi

##### Project Provided
if [ "$PROJECT" == "" ]; then
    throw_error "Error: PROJECT invalid/not set!" 1
else
    IFS='-' read -r ACCOUNT REGION <<< "$PROJECT"
    
    if [[ "$REGION" =~ ^(us-east-1|eu-central-1|ap-southeast-1)$ ]]; then
        if ! [[ "$ACCOUNT" =~ ^(shared|prod|dev|staging|demo)$ ]]; then
            throw_error "Error:\tPROJECT must begin with account name in [shared, prod, dev, staging, demo]\n\tACCOUNT:  $ACCOUNT" 1
        fi
    else
        throw_error "Error:\tPROJECT must end with [us-east-1, eu-central-1, ap-southeast-1]\n\tREGION: $REGION" 1
    fi
fi


case "$ACTION" in
    'apply')
        INCLUDECONFIG="--set autoDiscovery.clusterName=$CLUSTER_NAME"
        if [ -f environments/$PROJECT.yaml ]; then
            INCLUDECONFIG="-f environments/$PROJECT.yaml --set autoDiscovery.clusterName=$CLUSTER_NAME"
        fi
        helm upgrade $NAME . --install \
            --set clusterName=$CLUSTER_NAME \
            --namespace $NAMESPACE \
            --kubeconfig=../kubeconfigs/kubeconfig_$CLUSTER_NAME \
            $INCLUDECONFIG
            

    ;;
    'destroy')
        helm delete $NAME \
            --kubeconfig=../kubeconfigs/kubeconfig_$CLUSTER_NAME \
            --purge

    ;;
    esac
        
