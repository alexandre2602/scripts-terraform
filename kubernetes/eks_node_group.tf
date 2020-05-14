resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "eks-gudiao-labs-nodes"
  node_role_arn   = aws_iam_role.eks-node-service-role.arn
  subnet_ids      = data.aws_subnet_ids.private.ids
  instance_types  = [var.worker-node-instance-type]

  scaling_config {
    desired_size = 2
    max_size     = 8
    min_size     = 2
  }

  remote_access {
    ec2_ssh_key               = "awsKey"
    source_security_group_ids = [data.aws_security_group.selected.id]
  }  

  tags = {
    "Name" = "eks_node_group"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }

}