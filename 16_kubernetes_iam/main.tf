
resource "aws_iam_role" "role" {
  name          = "eks-${lower(data.terraform_remote_state.kubernetes.cluster_id)}-${lower(var.name)}"
  #path          = "/k8s/"
  assume_role_policy    = "${data.aws_iam_policy_document.assume_role_policy.json}"
}


data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${data.terraform_remote_state.kubernetes.worker_iam_role_arn}"]
    }
  }
  
}


resource "aws_iam_role_policy" "policy" {
    name = "${var.name}-Policy"
    role = "${aws_iam_role.role.id}"
    policy  = "${var.policy}"
}

