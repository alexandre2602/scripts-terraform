resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = false
  enable_dns_support = false

  tags = {
    "Name"                                      = "${var.tagName}-vpc"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}