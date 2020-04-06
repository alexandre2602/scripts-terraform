resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name"                                      = "${var.tagName}-route-table-public"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }

}

resource "aws_route_table_association" "rt-assoc-public" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id = aws_route_table.rt-public.id
}

resource "aws_route_table" "rt-private" {
  count  = var.az_count
  vpc_id = aws_vpc.vpc.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = element(aws_nat_gateway.nat-gw.*.id, count.index)
  # }

  tags = {
    "Name"                                      = "${var.tagName}-route-table-private"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_route_table_association" "rt-assoc-private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private-subnet.*.id, count.index)
  route_table_id = element(aws_route_table.rt-private.*.id, count.index)
}

