## Crate EKS master security group
resource "aws_security_group" "eks-sec-group-cluster" {
  name        = "eks-sec-group-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.eks.id

  tags = {
    "Name" = "eks-sec-group-cluster"
  }
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks-sec-group-cluster.id
}

resource "aws_security_group_rule" "allow_all_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks-sec-group-cluster.id
}

# resource "aws_security_group_rule" "allow_ssh" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.eks-sec-group-cluster.id
# }

# resource "aws_security_group_rule" "allow_https" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.eks-sec-group-cluster.id
# }

# resource "aws_security_group_rule" "allow_http" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.eks-sec-group-cluster.id
# }

# resource "aws_security_group_rule" "allow_com_cluster_nodes" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.eks-sec-group-cluster.id
# }

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

# resource "aws_security_group_rule" "allow_ssh_nodes" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.eks-sec-group-nodes.id
# }

# resource "aws_security_group_rule" "allow_com_nodes_cluster" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.eks-sec-group-nodes.id
# }
