# Contoso K8S Setup on AWS 

This repo is used to deploy a VPC in a central account using the new Shared Subnets features. I have VPN setup to the Transit account to connect each office and each region, your setup will likely differ for connectivity.

Each directory should be executed in order.  Some directories use Terraform, others Helm.

## Required Set

#### Terraform

For Terraform state, a S3 Bucket (contoso-terraform-state)  was setup in my central account with sharing permissions for each account.  Each account is restricted to write keys starting with its name, thus the prod account, can write to workspace prod-us-east-1.  If you get Access denied for Terraform, make sure you are not in the default Workspace.

Each account has its own DynamoDb table (contoso-terraform-lock) in us-east-1.  

Be sure to update your values in each in tf_init.tf

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

### Helm
Nothing special.   My accounts have a Role called PowerUser that we use.  You will notice in the K8s setup that we grant the PowerUser the k8s system:masters role which is everything, modify to your liking.

## Usage

A utility script (deploy.sh) was written to deploy each directory in a standard way, and limited to my predefined regions as well as the account prefixes, modify to your liking.

deploy.sh ACTION  FOLDER_NAME  PROJECT

-  ACTION is apply or destroy.   An apply will run apply for Terraform, and upgrade --install for helm.
-  FOLDER_NAME is the name of the folder it should operate on
-  PROJECT is a combination of account abbreviation (dev, prod, staging) and an AWS Region (us-east-1, ap-southeast-1, eu-central-1)
-  [--approve] This is equivalanet to terraform --auto-approve

If a deploy.sh file exists in the folder, it will be used.  This is an override.  Look at the tiller folder for an example.   


#### Folder Layout
Each folder has an environment folder which contains project named files for each technology.  
ie:  dev-eu-central-1.tfvars    or dev-eu-central-1.yaml


# TERMS OF USE
This entire project was cobbled together through examples of others and private fiddling, thus the DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE, is best applied.

Running these scripts WILL COSTS YOU MONEY, do not blame me if it COSTS YOU MONEY.

I will not be held liable for your execution of these scripts for any reason.

It took me nearly a week to put this together after requested, thus I likely don't have alot of time to help troubleshoot, but feel free to post issues, I'll respond when I can.   
I will accept Pull Request, when I can.





