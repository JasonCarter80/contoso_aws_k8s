variable "aws_region" {}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "ports" {
  type = "map"

  default {
    http     = 80
    https    = 0
    ssh      = 22
  }
}

variable "config_output_path" {
  default = "../kubeconfigs"

}

variable "cluster_version" {
    default = "1.12"
}
variable "key" {

}

#### Worker Details
variable "worker_names"  {
    type = "list"
    default = ["default"]
}

variable "worker_autoscaling_enabled"  {
    type = "map"
    default = {
        "default" = true,
    }    
}

variable "worker_spot_price" {
    type = "map"
    default = {
        "default" = "0.192",
    }
}

variable "worker_instance_type" {
    type = "map"
    default = {
        "default" = "m5.xlarge",
    }        
}

variable "worker_override_instance_type" {
    type = "map"
    default = {
        "default" = "t3.large",
    }        
}

variable "worker_asg_desired"  {
    type = "map"
    default = {
        "default" = "1",
    }      
}

variable "worker_asg_min"  {
    type = "map"
    default = {
        "default" = "0",
    }          
}

variable "worker_asg_max"  {
    type = "map"
    default = {
        "default" = "5",
    }      
}

variable "worker_kubelet_extra_args" {
    type = "map"
    default = {
        "default" = "--cloud-provider=aws"
    }
}

variable "worker_taints" {
    type = "map"
    default = {
        "default" = ""
    }
}

variable "worker_additional_userdata" {
    type = "map"
    default = {
        "default" = ""
    }
}

variable "worker_pre_userdata" {
    type = "map"
    default = {
        "default" = ""
    }
}

variable "worker_ami_id" {
    type = "map"
    default = {
        "default" = ""
    }
}


variable "vpc_id" {

}


variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  default     = false 
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
  default     = true
}


variable "worker_group_tags" {
  description = "A map defining extra tags to be applied to the worker group ASG."
  type        = "map"

  default = {
    default = []
  }
}