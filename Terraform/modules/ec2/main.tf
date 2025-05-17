# Criando uma instância WEB
resource "aws_instance" "web_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  private_ip                  = var.private_ip
  associate_public_ip_address = true
    user_data              = file("${path.module}/scripts/userdata.sh")
  iam_instance_profile        = var. iam_instance_profile

  tags = {
    Name        = "${var.project}-${var.environment}-web-server"
    Project     = var.project
    Environment = var.environment
  }
}