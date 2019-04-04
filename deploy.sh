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
    $(basename $0) ACTION PROJECT FOLDER [check]
    -a, --action        apply, destroy
    -p, --project       shared-us-east-1
    -f, --folder        20_software_folder
    --check             check

EOM
    exit 0
}
TF_APPROVE=""

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
    shared*|prod*|dev*|staging*|demo*|transit*)
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
            if [ "$1" == "--approve" ]; then
                TF_APPROVE="--auto-approve"
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
    IFS='-' read -r ACCOUNT CNT GEO NUM OTHER <<< "$PROJECT"
    REGION="$CNT-$GEO-$NUM"
    if [[ "$REGION" =~ ^(us-east-1|eu-central-1|ap-southeast-1).* ]]; then
        if ! [[ "$ACCOUNT" =~ ^(shared|prod|dev|staging|demo|transit)$ ]]; then
            throw_error "Error:\tPROJECT must begin with account name in [shared, prod, dev, staging, demo, transit]\n\tACCOUNT:  $ACCOUNT" 1
        fi
    else
        throw_error "Error:\tPROJECT must contain [us-east-1, eu-central-1, ap-southeast-1]\n\tREGION: $REGION" 1
    fi
fi

### Folder Provided
HELM_PROJECT_DEFAULTS=$(pwd)/defaults.vars
HELM_FOLDER_DEFAULTS=$(pwd)/$FOLDER/environments/defaults.vars
HELM_CONFIG=$(pwd)/$FOLDER/environments/$PROJECT.vars

TERRAFORM_FOLDER_DEFAULTS=$(pwd)/$FOLDER/environments/defaults.tfvars
TERRAFORM_CONFIG=$(pwd)/$FOLDER/environments/$PROJECT.tfvars
if [ "$FOLDER" == "" ]; then
     throw_error "Error: FOLDER invalid/ not set!" 1
elif [[ ! -f $HELM_CONFIG && ! -f $TERRAFORM_CONFIG ]]; then
    throw_error "Error: No config file for $PROJECT exists in $FOLDER" 1
fi



### Three Level of Defaults Posible,   Project level, (Same as this file)
if [ -f $HELM_PROJECT_DEFAULTS ]; then
    set -a
    . $HELM_PROJECT_DEFAULTS
    set +a  
fi

### Three Level of Defaults Posible,   Folder level
if [ -f $HELM_FOLDER_DEFAULTS ]; then
    set -a
    . $HELM_FOLDER_DEFAULTS
    set +a
fi

### Three Level of Defaults Posible,   Project Specific level
if [ -f $HELM_CONFIG ]; then
    set -a
    . $HELM_CONFIG
    set +a
fi

if [ "$CLUSTER_NAME" == "" ]; then
    CLUSTER_NAME=$PROJECT
fi

if [ -f "$(pwd)/$FOLDER/deploy.sh" ]; then
    TYPE="Deploy File"
elif [ -n "$(ls -A $(pwd)/$FOLDER/*.tf 2>/dev/null)" ]; then
    TYPE="Terraform"
elif [ -n "$(ls -A $(pwd)/$FOLDER/Chart.yaml 2>/dev/null)" ]; then
    TYPE="Helm Chart"
fi 



echo "$ACTION $TYPE in $FOLDER to $PROJECT"
cd $(pwd)/$FOLDER
case "$ACTION" in
    'apply')
        case $TYPE in
            'Deploy File')
                ./deploy.sh $ACTION $PROJECT
            ;;
            'Terraform')

                
                rm -rf .terraform      
                terraform init
                terraform workspace select $PROJECT || terraform workspace new $PROJECT
                terraform apply --var-file="environments/$PROJECT.tfvars" $TF_APPROVE
            ;;
            'Helm Chart')
                INCLUDECONFIG=""
                ### Include TF Defaults

                SPECIFIC_YAML="$(pwd)/environments/$PROJECT.yaml"
                if [ -f $SPECIFIC_YAML ]; then
                    echo "Found Deployment Specific Config: $SPECIFIC_YAML"
                    INCLUDECONFIG="$INCLUDECONFIG -f $SPECIFIC_YAML"
                fi

                
                if [[ -f "$(pwd)/requirements.yaml"  ]]; then
                    helm dependency update --skip-refresh
                fi

                helm upgrade $NAME . --install \
                    --wait \
                    --namespace $NAMESPACE \
                    --kubeconfig=../kubeconfigs/kubeconfig_$ACCOUNT-$REGION \
                    $INCLUDECONFIG 

                

            ;;
            *)
                throw_error "Cannot deduce "
            ;;
        
        esac       
    ;;
    'destroy')
        case $TYPE in
            'Deploy File')
                ./deploy.sh $ACTION $PROJECT
            ;;
            'Terraform')
                rm -rf .terraform      
                terraform init
                terraform workspace select $PROJECT || terraform workspace new $PROJECT
                terraform destroy --var-file="environments/$PROJECT.tfvars" $TF_APPROVE
            ;;
            'Helm Chart')
                helm delete $NAME \
                    --kubeconfig=../kubeconfigs/kubeconfig_$ACCOUNT-$REGION \
                    --purge

            ;;
            *)
                throw_error "Cannot deduce "
        
        esac      
        ;;
    esac
        
