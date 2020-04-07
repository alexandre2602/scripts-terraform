data "aws_availability_zones" "available" {}

data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "private" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Tier = "Private"
  }
}