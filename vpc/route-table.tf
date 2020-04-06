resource "aws_route_table" "eks-rt-public" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }

  tags = {
    "Name"                                      = "eks-route-table-public"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }

}

resource "aws_route_table_association" "eks-rt-assoc-public" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.eks-public.*.id, count.index)
  route_table_id = aws_route_table.eks-rt-public.id
}

resource "aws_route_table" "eks-rt-private" {
  count  = var.az_count
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.eks-nat-gw.*.id, count.index)
  }

  tags = {
    "Name"                                      = "eks-route-table-private"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_route_table_association" "eks-rt-assoc-private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.eks-private.*.id, count.index)
  route_table_id = element(aws_route_table.eks-rt-private.*.id, count.index)
}

