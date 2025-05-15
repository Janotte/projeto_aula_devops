# Definição  de variáveis para ​​VPC
variable "vpc_name" {
  description = "Nome da VPC"
  type        = string

}
# Bloco CIDR da VPC 
variable "vpc_cidr" {
  description = "CIDR da VPC"
  type        = string
}

variable "region" {
  description = "Região AWS"
  type        = string
}

variable "project" {
  type        = string
  description = "Projeto da Aplicação"
}

variable "environment" {
  type        = string
  description = "Ambiente de Desenvolvimento"
}

variable "public_subnet_a_cidr" {
  description = "Public subnet CIDR"
  type        = string
}

variable "public_subnet_b_cidr" {
  description = "Public subnet CIDR"
  type        = string
}

variable "private_subnet_a_cidr" {
  description = "Private subnet CIDR"
  type        = string
}

variable "private_subnet_b_cidr" {
  description = "Private subnet CIDR"
  type        = string
}
