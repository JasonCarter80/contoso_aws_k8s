#!/usr/local/bin/bash

### Command Line Variables
ACTION=""
REGION=""



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
    $(basename $0) -a ACTION -p PROJECT
    -a, --action        create, delete
    -p, --project       shared-us-east-1
EOM
    exit 0
}

ARGS=$@

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


echo "Processing $ACTION for $PROJECT"

PARAMSFILE=$(pwd)/environments/$PROJECT.vars

if [ -f $PARAMSFILE ]; then
    export $(grep -v '^#' $PARAMSFILE | xargs)
fi


case "$ACTION" in
    'apply')
        kubectl  create serviceaccount tiller -n kube-system --kubeconfig=../kubeconfigs/kubeconfig_$PROJECT
        kubectl create clusterrolebinding tiller --clusterrole cluster-admin  --serviceaccount=kube-system:tiller --kubeconfig=../kubeconfigs/kubeconfig_$PROJECT
        helm init --wait --service-account tiller --upgrade --kubeconfig=../kubeconfigs/kubeconfig_$PROJECT 
        
    ;;
    'destroy')
        helm reset --kubeconfig=../kubeconfigs/kubeconfig_$PROJECT
        kubectl delete serviceaccount tiller -n kube-system --kubeconfig=../kubeconfigs/kubeconfig_$PROJECT
        kubectl delete clusterrolebinding tiller  --kubeconfig=../kubeconfigs/kubeconfig_$PROJECT
    esac