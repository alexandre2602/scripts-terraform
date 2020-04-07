variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {}

# Variables RDS Service
variable "identifier" {
 default = "gudiao-labs-postgres"
}

variable "engine" {
 default = "postgres"
}

variable "engine_version" {
 default = "11.5"
}

variable "instance_class" {
 default = "db.t2.micro"
}

variable "allocated_storage" {
 default = 10
}

variable "storage_type" {
 default = "gp2"
}

variable "storage_encrypted" {
 default = false
}

variable "db-name" {
 default = "gudiaolabsdatabase"
}

variable "username" {
 default = "gudiao"
}

variable "password" {
 default = "gudiao123"
}

variable "port" {
 default = 5432
}

variable "multi_az" {
 default = "false"
}

variable "deletion_protection" {
 default = false
}

variable "timeouts" {
 default = "5m"
}