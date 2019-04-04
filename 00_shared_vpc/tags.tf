locals {
  tags = {
    tag_environment   = "${terraform.workspace}"
    tag_productcode   = "${var.tag_productcode}"
    tag_owner         = "${var.tag_owner}"
    tag_responsible   = "${var.tag_responsible}"
    tag_role          = "${var.tag_role}"
    tag_dcl           = "${var.tag_dcl}"
    tag_dedicated     = "${var.tag_dedicated}"
    tag_clustername   = "${var.tag_clustername}"
    tag_orchestration = "${var.tag_orchestration}"
  }
}
