variable "security_group_name" {
  type        = string
  description = "Nome do grupo de segurança"    
}

variable "project" {
  type        = string
  description = "Projeto da Aplicação"
}

variable "environment" {
  type        = string
  description = "Ambiente de Desenvolvimento"
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC" 
}