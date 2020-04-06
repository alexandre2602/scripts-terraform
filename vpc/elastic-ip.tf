resource "aws_eip" "eks-gw" {
  count = var.az_count
  vpc   = true

  tags = {
    "Name"                                      = "eks-elastic-ip"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}
