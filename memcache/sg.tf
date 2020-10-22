# Create redis security group
resource "aws_security_group" "sg_memcache" {
  name        = "sg_${var.name}_${var.project}_${var.environment}"
  description = "Security group that is needed for the ${var.name} servers"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.project}-${var.environment}-sg_${var.name}"
    Environment = var.environment
    Project     = var.project
  }
}

# Allow a security group to access the memcache instance
resource "aws_security_group_rule" "sg_app_to_memcahce" {
  count                    = length(var.allowed_sgs)
  type                     = "ingress"
  security_group_id        = aws_security_group.sg_memcache.id
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = var.allowed_sgs[count.index]
}

