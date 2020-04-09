resource "aws_eip" "eks-gw" {
  count = var.az_count
  vpc   = true

  tags = {
    "Name"                                      = "eks-elastic-ip"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_nat_gateway" "eks-nat-gw" {
  count = length(data.aws_subnet_ids.public.ids)
  subnet_id     = sort(data.aws_subnet_ids.public.ids)[count.index]
  allocation_id = element(aws_eip.eks-gw.*.id, count.index)

  tags = {
    "Name"                                      = "eks-nat-gateway"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}


resource "aws_route" "r" {
  count = length(data.aws_route_tables.rts.ids)
  route_table_id            = sort(data.aws_route_tables.rts.ids)[count.index]
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = element(aws_nat_gateway.eks-nat-gw.*.id, count.index) 

}


