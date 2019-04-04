output "worker_iam_role_arn" {
    value = "${module.eks.worker_iam_role_arn}"
}

output "cluster_id" {
    value = "${module.eks.cluster_id}"
}