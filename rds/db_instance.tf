resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "${var.identifier}-db-subnet-group"
  subnet_ids = data.aws_subnet_ids.private.ids

   tags = {
      "Name"        = "${var.tag_default_name}-database"
      "Description" = "RDS Database Subnet Group"
      "Service"     = "RDS Database"
   }

}

resource "aws_db_instance" "gudiao-labs-db-instance" {

   identifier = var.identifier

   engine            = var.engine
   engine_version    = var.engine_version
   instance_class    = var.instance_class
   allocated_storage = var.allocated_storage
   storage_type      = var.storage_type
   storage_encrypted = var.storage_encrypted

   name                                = var.db-name
   username                            = var.username
   password                            = var.password
   port                                = var.port

   vpc_security_group_ids = [aws_security_group.db-sec-group.id]
   db_subnet_group_name   = aws_db_subnet_group.db-subnet-group.name

   availability_zone   = data.aws_availability_zones.available.names[0]
   multi_az            = var.multi_az

   deletion_protection = var.deletion_protection

   final_snapshot_identifier = "${var.db-name}-final"

   tags = {
      "Name"        = "${var.tag_default_name}-database"
      "Service"     = "RDS Database"
   }

#   timeouts {
#      create = lookup("5m", "create", null)
#      delete = lookup("5m", "delete", null)
#      update = lookup("5m", "update", null)
#   }
}