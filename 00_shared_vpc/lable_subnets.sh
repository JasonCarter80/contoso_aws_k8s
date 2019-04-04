#!/bin/bash
TRANSIT_ACCOUNT=999999999999

login() {
    ## We use Azure MFA so this works for a login
    export AZURE_DEFAULT_ROLE_ARN="arn:aws:iam::$1:role/PowerUser"
    aws-azure-login --no-prompt
}

#### Get these values from Terrafrom for each Region
for s in us-east-1,vpc-aaaaaaaaaaaaaaa eu-central-1,vpc-bbbbbbbbbbbbbb ap-southeast-1,vpc-cccccccccccccccc
do
    login $TRANSIT_ACCOUNT
    
    REGION=${s%,*};
    VPCID=${s#*,};
    echo "Getting subnets for VPC: $VPCID in $REGION"
    ALLSUBNETS=$(aws ec2 describe-subnets --region $REGION  | jq --arg VPCID "$VPCID" -c '[.Subnets[] | select(.VpcId==$VPCID) ]')

    for i in  demo,000000000000 prod,111111111111 staging,222222222222 
    do 
        ACCOUNT_NAME=${i%,*};
        ACCOUNT_ID=${i#*,};
        echo "Working on $i"
        TAGGEDSUBNETS=$(echo $ALLSUBNETS | jq --arg ACCT "$ACCOUNT_NAME" -c '[.[] | select(.Tags[]|select(.Key=="Name")|.Value | contains($ACCT) ) | { SubnetId: .SubnetId , Tags: .Tags}]')
        login $ACCOUNT_ID
        LOCALSUBNETS=$(aws ec2 describe-subnets --region $REGION  | jq --arg VPCID "$VPCID" -c '.Subnets[] | select(.VpcId==$VPCID)')

        for local in $LOCALSUBNETS;
        do
            
            SUBNET=$(echo $local | jq -c '.SubnetId' --raw-output)
            NAME=$(echo $TAGGEDSUBNETS | jq --arg SUBNET "$SUBNET" -c '.[] | select (.SubnetId==$SUBNET)| .Tags[]|select(.Key=="Name")|.Value' --raw-output)
            TYPE=$(echo $TAGGEDSUBNETS | jq --arg SUBNET "$SUBNET" -c '.[] | select (.SubnetId==$SUBNET)| .Tags[]|select(.Key=="subnet-type")|.Value' --raw-output)

            KUBERNETES=""
            if [ "$TYPE" == "private" ];  then
                KUBERNETES="Key=kubernetes.io/role/internal-elb,Value=1 Key=kubernetes.io/cluster/$ACCOUNT_NAME-$REGION,Value=owned"
            fi

            if [ "$TYPE" == "public" ]; then
                KUBERNETES="Key=kubernetes.io/role/elb,Value=1 Key=kubernetes.io/cluster/$ACCOUNT_NAME-$REGION,Value=owned"
            fi


            echo "Tagging $SUBNET in $ACCOUNT_NAME($ACCOUNT_ID) with NAME:$NAME, Subnet-Type:$TYPE $KUBERNETES"

            aws ec2 create-tags --resources $SUBNET --tags Key=Name,Value=$NAME Key=subnet-type,Value=$TYPE $KUBERNETES --region $REGION
            

            
        done
    done
done
