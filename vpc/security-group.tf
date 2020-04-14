resource "aws_security_group" "mgmt-sec-group" {
  name        = "${var.tagName}-mgmt-sec-group"
  description = "Mgmt Security Group"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  tags = {
    "Name" = "${var.tagName}-mgmt-sec-group"
  }
}

resource "aws_security_group_rule" "mgmt-inbound-rule-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mgmt-sec-group.id
}


resource "aws_security_group" "public-sec-group" {
  name        = "${var.tagName}-public-sec-group"
  description = "Public Security Group"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    "Name" = "${var.tagName}-public-sec-group"
  }

  depends_on = [
     aws_security_group.mgmt-sec-group
  ]
}

resource "aws_security_group_rule" "public-inbound-rule-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public-sec-group.id
}

resource "aws_security_group_rule" "public-inbound-rule-https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public-sec-group.id
}

resource "aws_security_group_rule" "public-inbound-rule-ssh-mgmt" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = aws_security_group.mgmt-sec-group.id
  security_group_id = aws_security_group.public-sec-group.id
}

resource "aws_security_group" "private-sec-group" {
  name        = "${var.tagName}-private-sec-group"
  description = "Private Security Group"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.tagName}-private-sec-group"
  }

  depends_on = [
     aws_security_group.mgmt-sec-group, 
     aws_security_group.public-sec-group
  ]
}

resource "aws_security_group_rule" "private-inbound-rule-ssh-mgmt" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = aws_security_group.mgmt-sec-group.id
  security_group_id = aws_security_group.private-sec-group.id
}


resource "aws_security_group_rule" "private-inbound-rule-icmp-mgmt" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  source_security_group_id = aws_security_group.mgmt-sec-group.id
  security_group_id = aws_security_group.private-sec-group.id
}

resource "aws_security_group_rule" "private-inbound-rule-icmp-public" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  source_security_group_id = aws_security_group.public-sec-group.id
  security_group_id = aws_security_group.private-sec-group.id
}
