variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "Range of IPv4 address for the VPC"
  default     = "10.0.0.0/16"
}

variable "az_count" {
  default = 3
}

variable "az_count_db" {
  default = 2
}

variable "cluster-name" {
  default     = "eks-gudiao"
  description = "Enter eks cluster name - example like eks-demo, eks-dev etc"
}

variable "eks_version" {
  default = "1.15"
}

variable "eks-worker-ami" {
  default = "ami-0dc7713312a7ec987"
}

variable "worker-node-instance_type" {
  default = "t2.micro"
}

variable "ssh_key_pair" {
  default = "gudiaoEKS-Keypair"
}

variable "identifier" {
  default = "demodb-postgres"
}

variable "engine" {
  default = "postgres"
}

variable "engine_version" {
  default = "9.6.9"
}

variable "instance_class" {
  default = "db.t2.micro"
}

variable "allocated_storage" {
  default = 10
}

#storage_type      = var.storage_type

variable "storage_encrypted" {
  default = false
}

#kms_key_id        = var.kms_key_id
#license_model     = var.license_model





