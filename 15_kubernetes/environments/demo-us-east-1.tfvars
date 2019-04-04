aws_region = "us-east-1"
vpc_id = "vpc-aaaaaaaaaaaaaaa"
name = "demo-us-east-1"
key  = "contoso-demo-us-east-1"
worker_names    = ["compute", "compute", "compute", "gpu", ]

worker_autoscaling_enabled =  {
        "default" = false,
        "compute" = true,
        "gpu"     = true

}

worker_spot_price = {
        "default" = "0.192",
        "compute" = "0.4",
        "gpu"     = "1.0"
}

worker_instance_type = {
        "default"   = "t3.large",
        "compute"   = "m5.xlarge",
        "gpu"       = "g3s.xlarge",
    }        

worker_override_instance_type = {
        "default"   = "t3.large",
        "compute"   = "r4.xlarge",
        "gpu"       = "g3s.2xlarge",
    }    



worker_asg_desired = {
        "default"   = "0",
        "compute"    = "1",
    }      

worker_asg_min = {
        "default" = "0",    
        "compute"    = "1",
}

worker_asg_max = {
        "default" = "5",
    }      

worker_kubelet_extra_args {
    "default" = "--kube-reserved cpu=250m,memory=1Gi --system-reserved cpu=250m,memory=0.2Gi",
    "gpu" = "--kube-reserved cpu=250m,memory=1Gi --system-reserved cpu=250m,memory=0.2Gi --node-labels=role=gpu --register-with-taints=role=gpu:NoSchedule",
}

### Find these here:  https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
worker_ami_id {
        "default" = "ami-0d9f458329e942f90"
        "gpu" = "ami-0cb7959f92429410a"
}


worker_group_tags = {
        default = []
        gpu = [
                {
                        key                 = "k8s.io/cluster-autoscaler/node-template/label/role"
                        value               = "gpu"
                        propagate_at_launch = false
                        },
                {
                        key                 = "k8s.io/cluster-autoscaler/node-template/taints/role"
                        value               = "gpu:NoSchedule"
                        propagate_at_launch = true
                },
        ]
}