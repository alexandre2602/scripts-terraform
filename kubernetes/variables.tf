variable "region" {
  default = "us-east-1"
}

variable "az_count" {
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
