#!/bin/bash
ACCOUNT_ID=139558111080


login() {
    ## We use Azure MFA so this works for a login using this CLI tool https://github.com/dtjohnson/aws-azure-login
    export AZURE_DEFAULT_ROLE_ARN="arn:aws:iam::$1:role/PowerUser"
    aws-azure-login --no-prompt
}


build_arn() {
    ARN_VALUE="arn:aws:ec2:$region:$ACCOUNT_ID:subnet/$1"
}

get_account() {
    for i in demo,000000000000 prod,111111111111 staging,222222222222 ; 
    do 
        KEY=${i%,*};
        VAL=${i#*,};
        if [[ "$KEY" == "$1" ]]; then
            echo $VAL
            break
        fi
    done
}

login $ACCOUNT_ID

#### Share the Subnets
for region in us-east-1 ap-southeast-1 eu-central-1
do
    for ACCT in presales; #prod shared dev demo staging ;
    do
        SHAREARN=$(aws ram  get-resource-shares --resource-owner=SELF --region $region | jq --arg ACCT "$ACCT" -c '.resourceShares[] | select(.name | contains($ACCT)) | .resourceShareArn'  --raw-output)
        SUBNETS=$(aws ec2 describe-subnets --query "Subnets[*].[SubnetId]" --filters "Name=tag:Name,Values=$ACCT*" --region $region | jq '.[] | add ' --raw-output)       

        SHAREDACCOUNT_ID=$(get_account $ACCT)
        
        for SUBNET in $SUBNETS;
        do
            build_arn $SUBNET
            RESULTS=$(aws ram associate-resource-share --resource-share-arn=$SHAREARN --resource-arns $ARN_VALUE --principals $SHAREDACCOUNT_ID --region $region)
            echo "Associating $SUBNET with $SHAREDACCOUNT_ID in $region"
        done
        
    done
done 






 