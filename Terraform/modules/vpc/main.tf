# Criando a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.project}-${var.environment}-vpc"
    Project     = var.project
    Environment = var.environment
  }
}

# Criando as subnets públicas
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_a_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name        = "${var.project}-${var.environment}-public-subnet-${var.region}a"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_b_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    Name        = "${var.project}-${var.environment}-public-subnet-${var.region}b"
    Project     = var.project
    Environment = var.environment
  }
}

# Criando as subnets privadas
resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_a_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name        = "${var.project}-${var.environment}-private-subnet-${var.region}a"
    Project     = var.project
    Environment = var.environment
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_b_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    Name        = "${var.project}-${var.environment}-private-subnet-${var.region}b"
    Project     = var.project
    Environment = var.environment
  }
}

# Criando o Network ACL
resource "aws_network_acl" "main_acl" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id, 
    aws_subnet.private_a.id,
    aws_subnet.private_b.id

  ]
  tags = {
    Name        = "${var.project}-${var.environment}-acl"
    Project     = var.project
    Environment = var.environment
  }
}

# ===== INGRESS =====

# Liberando a entrada pelas portas Efemeras
resource "aws_network_acl_rule" "ingress_response_traffic" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Liberando a entrada pela porta HTTP
resource "aws_network_acl_rule" "ingress_http" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 110
  egress         = false
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Liberando a entrada pela porta HTTPS
resource "aws_network_acl_rule" "ingress_https" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 120
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Liberando a entrada pela porta SSH
resource "aws_network_acl_rule" "ingress_ssh" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 130
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# ===== EGRESS =====

# Libera todo trafego de saida para qualquer destino
resource "aws_network_acl_rule" "egress_efemeras" {
  network_acl_id = aws_network_acl.main_acl.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

# Criando o Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project}-${var.environment}-igw"
    Project     = var.project
    Environment = var.environment
  }
}

# Criando a tabela rotas públic, com acesso à Internet
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project}-${var.environment}-public-rt"
    Project     = var.project
    Environment = var.environment
  }
}

#Associando a tabela de rotas pública à sub-rede pública
resource "aws_route_table_association" "public_public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public_public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_route.id
}

# Criando a tabela rotas privada, sem acesso à Internet
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project}-${var.environment}-private-rt"
    Project     = var.project
    Environment = var.environment
  }
}

#Associando a tabela de rotas privada à sub-rede privada e públicas
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_route.id
}
