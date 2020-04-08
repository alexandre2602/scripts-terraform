## Crate EKS Nodes security group
resource "aws_security_group" "eks-sec-group-nodes" {
  name        = "eks-sec-group-nodes"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.eks.id

  tags = {
    "Name"                   = "eks-sec-group-nodes"
    "kubernetes.io/cluster/" = "${var.cluster-name}"
  }
}

resource "aws_security_group_rule" "allow_all_nodes_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks-sec-group-nodes.id
}

resource "aws_security_group_rule" "allow_all_nodes_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks-sec-group-nodes.id
}

resource "aws_security_group_rule" "allow_ssh_nodes" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks-sec-group-nodes.id
}

resource "aws_security_group_rule" "allow_com_nodes_cluster" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks-sec-group-nodes.id
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "eks-gudiao-labs-nodes"
  node_role_arn   = aws_iam_role.eks-node-service-role.arn
  subnet_ids      = data.aws_subnet_ids.private.ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  tags = {
    "Name" = "eks_node_group"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }

}