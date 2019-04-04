## Contoso Network Setup

This repo is used to deploy a base Network.  Each directory should be executed in order.  Some directories use Terraform, others Helm.

### Required Set

# Terraform

For Terraform state, a S3 Bucket (contoso-terraform-state)  was setup with sharing permissions for each account.  Each account is restricted to write keys starting with its name, thus the prod account, can write to workspace prod-us-east-1.

Each account has its own DynamoDb table (contoso-terraform-lock) in us-east-1.  

Be sure to update these in tf_init.tf

```
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::contoso-terraform-state",
                "arn:aws:s3:::contoso-terraform-state/env:/transit*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "o-1234567890"
                }
            }
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::000000000000:root"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::contoso-terraform-state/env:/demo*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::111111111111:root"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::contoso-terraform-state/env:/prod*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::22222222222:root"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::contoso-terraform-state/env:/staging*"
        },

    ]
}
```

A utility script was written to deploy each directory in a standard way: deploy.sh

deploy.sh ACTION  FOLDER_NAME  PROJECT

-  ACTION is apply or destroy.   An apply will run apply for Terraform, and upgrade --install for helm.
-  FOLDER_NAME is the name of the folder it should operate on
-  PROJECT is a combination of account abbreviation (dev, prod, staging) and an AWS REgion (us-east-1, ap-southeast-1, eu-central-1)


#### Folder Layout
Each folder has an environment folder which contains project named files for each technology.  
ie:  dev-eu-central-1.tfvars    or dev-eu-central-1.yaml

