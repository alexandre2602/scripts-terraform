data "aws_availability_zones" "available" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = "gudiao-labs-vpc"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "gudiao-labs-private-subnet"
  }
}