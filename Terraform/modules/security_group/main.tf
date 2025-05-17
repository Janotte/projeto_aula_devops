# Criando o grupo de segurança para servidor da aplicação
resource "aws_security_group" "ec2_access_sg" {
  name        = var.security_group_name
  description = "Grupo de seguranca para Servidor da Aplicacao"
  vpc_id      = var.vpc_id
  tags = {
    Name        = var.security_group_name
    Project     = var.project
    Environment = var.environment
  }

  ingress {
    description = "Libera ICMP dentro da VPN"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "Libera acesso SSH com origem no meu IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Alterar para produção
  }

  ingress {
    description = "Libera acesso HTTP de qualquer origem"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Libera acesso HTTPS de qualquer origem"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = " Libera todo trafego de saida para qualquer destino"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
