
locals {
  
  #### Breaking out the AZs due to Cluster Autoscaler:  https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md
  worker_groups = [
    {
      name                  = "${length(var.worker_names) >= 1 ? var.worker_names[0] : "1"}"
      key_name              = "${var.key == "" ? "" : var.key}"
      additional_security_group_ids = "${aws_security_group.worker_group_mgmt_one.id}"
      subnets               = "${data.aws_subnet_ids.privates.ids[0]}"
      autoscaling_enabled   = "${lookup(var.worker_autoscaling_enabled,   length(var.worker_names) >= 1 ? var.worker_names[0] : "default", lookup(var.worker_autoscaling_enabled, "default"))}"
      spot_price            = "${lookup(var.worker_spot_price,            length(var.worker_names) >= 1 ? var.worker_names[0] : "default", lookup(var.worker_spot_price, "default"))}"
      instance_type         = "${lookup(var.worker_instance_type,         length(var.worker_names) >= 1 ? var.worker_names[0] : "default", lookup(var.worker_instance_type, "default"))}"
      override_instance_type= "${lookup(var.worker_override_instance_type,length(var.worker_names) >= 1 ? var.worker_names[0] : "default", lookup(var.worker_override_instance_type, "default"))}"      
      asg_desired_capacity  = "${lookup(var.worker_asg_desired,           length(var.worker_names) >= 1 ? var.worker_names[0] : "default", lookup(var.worker_asg_desired, "default"))}"
      asg_max_size          = "${lookup(var.worker_asg_max,               length(var.worker_names) >= 1 ? var.worker_names[0] : "default", lookup(var.worker_asg_max, "default"))}"
      asg_min_size          = "${lookup(var.worker_asg_min,               length(var.worker_names) >= 1 ? var.worker_names[0] : "default", lookup(var.worker_asg_min, "default"))}"
      kubelet_extra_args    = "${lookup(var.worker_kubelet_extra_args,    length(var.worker_names) >= 1 ? var.worker_names[0] : "default", lookup(var.worker_kubelet_extra_args, "default"))}"
      pre_userdata          = "${lookup(var.worker_pre_userdata,          length(var.worker_names) >= 1 ? var.worker_names[0] : "default", lookup(var.worker_pre_userdata, "default"))}"
      additional_userdata   = "${lookup(var.worker_additional_userdata,   length(var.worker_names) >= 1 ? var.worker_names[0] : "default", lookup(var.worker_additional_userdata, "default"))}"
      ami_id                = "${lookup(var.worker_ami_id,                length(var.worker_names) >= 1 ? var.worker_names[0] : "default", lookup(var.worker_ami_id, "default"))}"

    },
    {
      name                  = "${length(var.worker_names) >= 2 ? var.worker_names[1] : "2"}"
      key_name              = "${var.key == "" ? "" : var.key}"      
      additional_security_group_ids = "${aws_security_group.worker_group_mgmt_one.id}"
      subnets               = "${data.aws_subnet_ids.privates.ids[1]}"
      autoscaling_enabled   = "${lookup(var.worker_autoscaling_enabled,   length(var.worker_names) >= 2 ? var.worker_names[1] : "default", lookup(var.worker_autoscaling_enabled, "default"))}"
      spot_price            = "${lookup(var.worker_spot_price,            length(var.worker_names) >= 2 ? var.worker_names[1] : "default", lookup(var.worker_spot_price, "default"))}"
      instance_type         = "${lookup(var.worker_instance_type,         length(var.worker_names) >= 2 ? var.worker_names[1] : "default", lookup(var.worker_instance_type, "default"))}"
      override_instance_type= "${lookup(var.worker_override_instance_type,length(var.worker_names) >= 2 ? var.worker_names[1] : "default", lookup(var.worker_override_instance_type, "default"))}"            
      asg_desired_capacity  = "${lookup(var.worker_asg_desired,           length(var.worker_names) >= 2 ? var.worker_names[1] : "default", lookup(var.worker_asg_desired, "default"))}"
      asg_max_size          = "${lookup(var.worker_asg_max,               length(var.worker_names) >= 2 ? var.worker_names[1] : "default", lookup(var.worker_asg_max, "default"))}"
      asg_min_size          = "${lookup(var.worker_asg_min,               length(var.worker_names) >= 2 ? var.worker_names[1] : "default", lookup(var.worker_asg_min, "default"))}"
      kubelet_extra_args    = "${lookup(var.worker_kubelet_extra_args,    length(var.worker_names) >= 2 ? var.worker_names[1] : "default", lookup(var.worker_kubelet_extra_args, "default"))}"
      pre_userdata          = "${lookup(var.worker_pre_userdata,          length(var.worker_names) >= 2 ? var.worker_names[1] : "default", lookup(var.worker_pre_userdata, "default"))}"
      additional_userdata   = "${lookup(var.worker_additional_userdata,   length(var.worker_names) >= 2 ? var.worker_names[1] : "default", lookup(var.worker_additional_userdata, "default"))}"      
      ami_id                = "${lookup(var.worker_ami_id,                length(var.worker_names) >= 2 ? var.worker_names[1] : "default", lookup(var.worker_ami_id, "default"))}"
    },
    {
      name                  = "${length(var.worker_names) >= 3 ? var.worker_names[2] : "3"}"
      key_name              = "${var.key == "" ? "" : var.key}"      
      additional_security_group_ids = "${aws_security_group.worker_group_mgmt_one.id}"
      subnets               = "${data.aws_subnet_ids.privates.ids[2]}"
      autoscaling_enabled   = "${lookup(var.worker_autoscaling_enabled,   length(var.worker_names) >= 3 ? var.worker_names[2] : "default", lookup(var.worker_autoscaling_enabled, "default"))}"
      spot_price            = "${lookup(var.worker_spot_price,            length(var.worker_names) >= 3 ? var.worker_names[2] : "default", lookup(var.worker_spot_price, "default"))}"
      instance_type         = "${lookup(var.worker_instance_type,         length(var.worker_names) >= 3 ? var.worker_names[2] : "default", lookup(var.worker_instance_type, "default"))}"
      override_instance_type= "${lookup(var.worker_override_instance_type,length(var.worker_names) >= 3 ? var.worker_names[2] : "default", lookup(var.worker_override_instance_type, "default"))}"      
      asg_desired_capacity  = "${lookup(var.worker_asg_desired,           length(var.worker_names) >= 3 ? var.worker_names[2] : "default", lookup(var.worker_asg_desired, "default"))}"
      asg_max_size          = "${lookup(var.worker_asg_max,               length(var.worker_names) >= 3 ? var.worker_names[2] : "default", lookup(var.worker_asg_max, "default"))}"
      asg_min_size          = "${lookup(var.worker_asg_min,               length(var.worker_names) >= 3 ? var.worker_names[2] : "default", lookup(var.worker_asg_min, "default"))}"
      kubelet_extra_args    = "${lookup(var.worker_kubelet_extra_args,    length(var.worker_names) >= 3 ? var.worker_names[2] : "default", lookup(var.worker_kubelet_extra_args, "default"))}"
      pre_userdata          = "${lookup(var.worker_pre_userdata,          length(var.worker_names) >= 3 ? var.worker_names[2] : "default", lookup(var.worker_pre_userdata, "default"))}"
      additional_userdata   = "${lookup(var.worker_additional_userdata,   length(var.worker_names) >= 3 ? var.worker_names[2] : "default", lookup(var.worker_additional_userdata, "default"))}"      
      ami_id                = "${lookup(var.worker_ami_id,                length(var.worker_names) >= 3 ? var.worker_names[2] : "default", lookup(var.worker_ami_id, "default"))}"
    },
    {
      name                  = "${length(var.worker_names) >= 4 ? var.worker_names[3] : "4"}"
      key_name              = "${var.key == "" ? "" : var.key}"      
      subnets               = "${join(",", data.aws_subnet_ids.privates.ids)}"
      autoscaling_enabled   = "${lookup(var.worker_autoscaling_enabled,   length(var.worker_names) >= 4 ? var.worker_names[3] : "default", lookup(var.worker_autoscaling_enabled, "default"))}"
      spot_price            = "${lookup(var.worker_spot_price,            length(var.worker_names) >= 4 ? var.worker_names[3] : "default", lookup(var.worker_spot_price, "default"))}"
      instance_type         = "${lookup(var.worker_instance_type,         length(var.worker_names) >= 4 ? var.worker_names[3] : "default", lookup(var.worker_instance_type, "default"))}"
      override_instance_type= "${lookup(var.worker_override_instance_type,length(var.worker_names) >= 4 ? var.worker_names[3] : "default", lookup(var.worker_override_instance_type, "default"))}"      
      asg_desired_capacity  = "${lookup(var.worker_asg_desired,           length(var.worker_names) >= 4 ? var.worker_names[3] : "default", lookup(var.worker_asg_desired, "default"))}"
      asg_max_size          = "${lookup(var.worker_asg_max,               length(var.worker_names) >= 4 ? var.worker_names[3] : "default", lookup(var.worker_asg_max, "default"))}"
      asg_min_size          = "${lookup(var.worker_asg_min,               length(var.worker_names) >= 4 ? var.worker_names[3] : "default", lookup(var.worker_asg_min, "default"))}"
      kubelet_extra_args    = "${lookup(var.worker_kubelet_extra_args,    length(var.worker_names) >= 4 ? var.worker_names[3] : "default", lookup(var.worker_kubelet_extra_args, "default"))}"
      pre_userdata          = "${lookup(var.worker_pre_userdata,          length(var.worker_names) >= 4 ? var.worker_names[3] : "default", lookup(var.worker_pre_userdata, "default"))}"
      additional_userdata   = "${lookup(var.worker_additional_userdata,   length(var.worker_names) >= 4 ? var.worker_names[3] : "default", lookup(var.worker_additional_userdata, "default"))}"      
      ami_id                = "${lookup(var.worker_ami_id,                length(var.worker_names) >= 4 ? var.worker_names[3] : "default", lookup(var.worker_ami_id, "default"))}"
    },        
### If you want to make GPU AZ aware uncomment these add add more 'gpu' entries to the worker_names array

    # {
    #   name                  = "${length(var.worker_names) >= 5 ? var.worker_names[4] : "5"}"
    #   key_name              = "${var.key == "" ? "" : var.key}"      
    #   additional_security_group_ids = "${aws_security_group.worker_group_mgmt_one.id}"
    #   subnets               = "${join(",", data.aws_subnet_ids.privates.ids)}"
    #   autoscaling_enabled   = "${lookup(var.worker_autoscaling_enabled,   length(var.worker_names) >= 5 ? var.worker_names[4] : "default", lookup(var.worker_autoscaling_enabled, "default"))}"
    #   spot_price            = "${lookup(var.worker_spot_price,            length(var.worker_names) >= 5 ? var.worker_names[4] : "default", lookup(var.worker_spot_price, "default"))}"
    #   instance_type         = "${lookup(var.worker_instance_type,         length(var.worker_names) >= 5 ? var.worker_names[4] : "default", lookup(var.worker_instance_type, "default"))}"
    #   override_instance_type= "${lookup(var.worker_override_instance_type,length(var.worker_names) >= 5 ? var.worker_names[4] : "default", lookup(var.worker_override_instance_type, "default"))}"      
    #   asg_desired_capacity  = "${lookup(var.worker_asg_desired,           length(var.worker_names) >= 5 ? var.worker_names[4] : "default", lookup(var.worker_asg_desired, "default"))}"
    #   asg_max_size          = "${lookup(var.worker_asg_max,               length(var.worker_names) >= 5 ? var.worker_names[4] : "default", lookup(var.worker_asg_max, "default"))}"
    #   asg_min_size          = "${lookup(var.worker_asg_min,               length(var.worker_names) >= 5 ? var.worker_names[4] : "default", lookup(var.worker_asg_min, "default"))}"
    #   kubelet_extra_args    = "${lookup(var.worker_kubelet_extra_args,    length(var.worker_names) >= 5 ? var.worker_names[4] : "default", lookup(var.worker_kubelet_extra_args, "default"))}"  
    #   pre_userdata          = "${lookup(var.worker_pre_userdata,          length(var.worker_names) >= 5 ? var.worker_names[4] : "default", lookup(var.worker_pre_userdata, "default"))}"
    #   additional_userdata   = "${lookup(var.worker_additional_userdata,   length(var.worker_names) >= 5 ? var.worker_names[4] : "default", lookup(var.worker_additional_userdata, "default"))}"      
    #   ami_id                = "${lookup(var.worker_ami_id,                length(var.worker_names) >= 5 ? var.worker_names[4] : "default", lookup(var.worker_ami_id, "default"))}"      
    # },
    # {
    #   name                  = "${length(var.worker_names) >= 6 ? var.worker_names[5] : "6"}"
    #   key_name              = "${var.key == "" ? "" : var.key}"      
    #   additional_security_group_ids = "${aws_security_group.worker_group_mgmt_one.id}"
    #   subnets               = "${data.aws_subnet_ids.privates.ids[1]}"
    #   autoscaling_enabled   = "${lookup(var.worker_autoscaling_enabled,   length(var.worker_names) >= 6 ? var.worker_names[5] : "default", lookup(var.worker_autoscaling_enabled, "default"))}"
    #   spot_price            = "${lookup(var.worker_spot_price,            length(var.worker_names) >= 6 ? var.worker_names[5] : "default", lookup(var.worker_spot_price, "default"))}"
    #   instance_type         = "${lookup(var.worker_instance_type,         length(var.worker_names) >= 6 ? var.worker_names[5] : "default", lookup(var.worker_instance_type, "default"))}"
    #   override_instance_type= "${lookup(var.worker_override_instance_type,length(var.worker_names) >= 6 ? var.worker_names[5] : "default", lookup(var.worker_override_instance_type, "default"))}"            
    #   asg_desired_capacity  = "${lookup(var.worker_asg_desired,           length(var.worker_names) >= 6 ? var.worker_names[5] : "default", lookup(var.worker_asg_desired, "default"))}"
    #   asg_max_size          = "${lookup(var.worker_asg_max,               length(var.worker_names) >= 6 ? var.worker_names[5] : "default", lookup(var.worker_asg_max, "default"))}"
    #   asg_min_size          = "${lookup(var.worker_asg_min,               length(var.worker_names) >= 6 ? var.worker_names[5] : "default", lookup(var.worker_asg_min, "default"))}"
    #   kubelet_extra_args    = "${lookup(var.worker_kubelet_extra_args,    length(var.worker_names) >= 6 ? var.worker_names[5] : "default", lookup(var.worker_kubelet_extra_args, "default"))}"  
    #   taint                 = "${lookup(var.worker_taints,                length(var.worker_names) >= 6 ? var.worker_names[5] : "default", lookup(var.worker_taints, "default"))}"    
    #   pre_userdata          = "${lookup(var.worker_pre_userdata,          length(var.worker_names) >= 6 ? var.worker_names[5] : "default", lookup(var.worker_pre_userdata, "default"))}"
    #   additional_userdata   = "${lookup(var.worker_additional_userdata,   length(var.worker_names) >= 6 ? var.worker_names[5] : "default", lookup(var.worker_additional_userdata, "default"))}"      
    #   ami_id                = "${lookup(var.worker_ami_id,                length(var.worker_names) >= 6 ? var.worker_names[5] : "default", lookup(var.worker_ami_id, "default"))}"
    # },
    # {
    #   name                  = "${length(var.worker_names) >= 7 ? var.worker_names[6] : "7"}"
    #   key_name              = "${var.key == "" ? "" : var.key}"      
    #   additional_security_group_ids = "${aws_security_group.worker_group_mgmt_one.id}"
    #   subnets               = "${data.aws_subnet_ids.privates.ids[2]}"
    #   autoscaling_enabled   = "${lookup(var.worker_autoscaling_enabled,   length(var.worker_names) >= 7 ? var.worker_names[6] : "default", lookup(var.worker_autoscaling_enabled, "default"))}"
    #   spot_price            = "${lookup(var.worker_spot_price,            length(var.worker_names) >= 7 ? var.worker_names[6] : "default", lookup(var.worker_spot_price, "default"))}"
    #   instance_type         = "${lookup(var.worker_instance_type,         length(var.worker_names) >= 7 ? var.worker_names[6] : "default", lookup(var.worker_instance_type, "default"))}"
    #   override_instance_type= "${lookup(var.worker_override_instance_type,length(var.worker_names) >= 7 ? var.worker_names[6] : "default", lookup(var.worker_override_instance_type, "default"))}"      
    #   asg_desired_capacity  = "${lookup(var.worker_asg_desired,           length(var.worker_names) >= 7 ? var.worker_names[6] : "default", lookup(var.worker_asg_desired, "default"))}"
    #   asg_max_size          = "${lookup(var.worker_asg_max,               length(var.worker_names) >= 7 ? var.worker_names[6] : "default", lookup(var.worker_asg_max, "default"))}"
    #   asg_min_size          = "${lookup(var.worker_asg_min,               length(var.worker_names) >= 7 ? var.worker_names[6] : "default", lookup(var.worker_asg_min, "default"))}"
    #   kubelet_extra_args    = "${lookup(var.worker_kubelet_extra_args,    length(var.worker_names) >= 7 ? var.worker_names[6] : "default", lookup(var.worker_kubelet_extra_args, "default"))}"  
    #   taint                 = "${lookup(var.worker_taints,                length(var.worker_names) >= 7 ? var.worker_names[6] : "default", lookup(var.worker_taints, "default"))}"    
    #   pre_userdata          = "${lookup(var.worker_pre_userdata,          length(var.worker_names) >= 7 ? var.worker_names[6] : "default", lookup(var.worker_pre_userdata, "default"))}"
    #   additional_userdata   = "${lookup(var.worker_additional_userdata,   length(var.worker_names) >= 7 ? var.worker_names[6] : "default", lookup(var.worker_additional_userdata, "default"))}"   
    #   ami_id                = "${lookup(var.worker_ami_id,                length(var.worker_names) >= 7 ? var.worker_names[6] : "default", lookup(var.worker_ami_id, "default"))}"   
    # },        
  ]


  map_roles = [
    {
      role_arn = "${data.aws_iam_role.poweruser.arn}"
      username = "PowerUser:{{SessionName}}"
      group    = "system:masters"
    },
  ]

}


data "aws_iam_role" "poweruser" {
  name = "PowerUser"
}

resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "${terraform.workspace}-${var.name}-Management-One"
  description = "SG to be applied to all *nix machines"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}


resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]    
    
  }
}


data "aws_subnet_ids" "publics" {
  vpc_id = "${var.vpc_id}"

  tags = {
    "subnet-type" = "public"
  }
}

data "aws_subnet_ids" "privates" {
  vpc_id = "${var.vpc_id}"

  tags = {
    "subnet-type" = "private"
  }
}


module "eks" {
  source                               = "terraform-aws-modules/terraform-aws-eks"
  worker_group_tags                    = "${var.worker_group_tags}"
  cluster_endpoint_private_access      = "${var.cluster_endpoint_private_access}"
  cluster_endpoint_public_access       = "${var.cluster_endpoint_public_access}"
  config_output_path                   = "${var.config_output_path}/"
  cluster_name                         = "${var.name}"
  cluster_version                      = "${var.cluster_version}"
  subnets                              = ["${concat(data.aws_subnet_ids.privates.ids, data.aws_subnet_ids.publics.ids)}"]
  vpc_id                               = "${var.vpc_id}"
  worker_groups                        = "${local.worker_groups}"
  worker_group_count                   = "${length(var.worker_names)}"
  worker_additional_security_group_ids = ["${aws_security_group.all_worker_mgmt.id}"]
  map_roles                            = "${local.map_roles}"
  map_roles_count                      = 1
  kubeconfig_name                      = "${var.name}"
  #map_users                            = "${var.map_users}"
  #map_accounts                         = "${var.map_accounts}"

#data.terraform_remote_state.vpc.tags,
  tags = "${merge(
    
    map(
      "Name", "${terraform.workspace}-${var.name}",
      "tag_role", "Kubernetes"
      
    )
  )}"
}
