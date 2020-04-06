## internet gateway
resource "aws_internet_gateway" "eks-igw" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name = "eks-internet-gateway"
  }
}