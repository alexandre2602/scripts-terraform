## EKS private subnets
resource "aws_subnet" "eks-private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.eks.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.eks.id

  tags = {
    "Name"                                      = "eks-private-subnet"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

## EKS public subnets
resource "aws_subnet" "eks-public" {
  count = var.az_count
  # var.az_count é usado para não conflitar com o private
  cidr_block              = cidrsubnet(aws_vpc.eks.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.eks.id
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "eks-public-subnet"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

# resource "aws_subnet" "eks-private-db" {
#   count             = var.az_count_db * var.az_count
#   cidr_block        = cidrsubnet(aws_vpc.eks.cidr_block, 8, var.az_count_db + count.index)
#   availability_zone = data.aws_availability_zones.available.names[count.index]
#   vpc_id            = aws_vpc.eks.id

#   tags = {
#     "Name"                                      = "eks-private-subnet-db"
#   }
# }
