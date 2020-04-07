## Create RDS security group
resource "aws_security_group" "db-sec-group" {
  name        = "gudiao-labs-db-sec-group"
  description = "Database Security Group"
  vpc_id      = data.aws_vpc.vpc.id

  tags = {
    "Name" = "gudiaoLabs-db-sec-group"
  }
}

resource "aws_security_group_rule" "db-allow-all-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db-sec-group.id
}

resource "aws_security_group_rule" "db-allow-postgres-ingress" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db-sec-group.id
}

resource "aws_security_group_rule" "db-allow-ssh-ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db-sec-group.id
}

resource "aws_security_group_rule" "db-allow-icmp-ingress" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db-sec-group.id
}
