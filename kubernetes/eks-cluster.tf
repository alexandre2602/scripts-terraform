#EKS Service
resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.eks-cluster-service-role.arn

  vpc_config {
    security_group_ids = [data.aws_security_group.selected.id]
    subnet_ids         = data.aws_subnet_ids.private.ids
  }

  depends_on = [
    aws_nat_gateway.eks-nat-gw
  ]  

}