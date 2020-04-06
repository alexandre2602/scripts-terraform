resource "aws_nat_gateway" "eks-nat-gw" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.eks-public.*.id, count.index)
  allocation_id = element(aws_eip.eks-gw.*.id, count.index)
  depends_on = [
    aws_internet_gateway.eks-igw
  ]

  tags = {
    "Name"                                      = "eks-nat-gateway"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}