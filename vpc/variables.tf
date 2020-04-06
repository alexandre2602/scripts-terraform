variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "Range of IPv4 address for the VPC"
  default     = "10.0.0.0/16"
}

variable "az_count" {
  default = 2
}

variable "tagName" {
  default = "gudiao-labs"
}

variable "cluster-name" {
  default     = "gudiao-labs-eks"
  description = "Enter eks cluster name - example like eks-demo, eks-dev etc"
}

