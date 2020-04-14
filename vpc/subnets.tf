## EKS private subnets
resource "aws_subnet" "private-subnet" {
  count             = var.az_count
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.vpc.id

  tags = {
    "Name"                                      = "${var.tagName}-private-subnet"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

## EKS public subnets
resource "aws_subnet" "public-subnet" {
  count = var.az_count
  # var.az_count é usado para não conflitar com o private
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "${var.tagName}-public-subnet"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

## Mgmt subnets
resource "aws_subnet" "mgmt-subnet" {
  count = var.az_count
  # var.az_count é usado para não conflitar com o private
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2 * (var.az_count + count.index))
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    "Name"                                      = "${var.tagName}-mgmt-subnet"
  }
}

