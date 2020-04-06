resource "aws_network_acl" "eks-nacl-public" {
  vpc_id     = aws_vpc.eks.id
  subnet_ids = aws_subnet.eks-public.*.id

  tags = {
    "Name"                                      = "eks-nacl-public"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }

}

resource "aws_network_acl_rule" "eks-nacl-http" {
  network_acl_id = aws_network_acl.eks-nacl-public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = aws_vpc.eks.cidr_block
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "eks-nacl-https" {
  network_acl_id = aws_network_acl.eks-nacl-public.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = aws_vpc.eks.cidr_block
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "eks-nacl-ephemeral" {
  network_acl_id = aws_network_acl.eks-nacl-public.id
  rule_number    = 300
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = aws_vpc.eks.cidr_block
  from_port      = 1024
  to_port        = 65535
}


resource "aws_network_acl" "eks-nacl-private" {
  #count      = var.az_count
  vpc_id     = aws_vpc.eks.id
  subnet_ids = aws_subnet.eks-private.*.id

  tags = {
    "Name"                                      = "eks-nacl-private"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }

}

resource "aws_network_acl_rule" "eks-nacl-private-ephemeral" {
  #count          = var.az_count
  #network_acl_id = element(aws_network_acl.eks-nacl-private.*.id, count.index)
  network_acl_id = aws_network_acl.eks-nacl-private.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = aws_vpc.eks.cidr_block
  from_port      = 1024
  to_port        = 65535
}

