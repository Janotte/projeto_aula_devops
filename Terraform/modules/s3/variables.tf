variable "bucket_name" {
  type        = string
  description = "Nome do bucket S3"  
}

variable "project" {
  type        = string
  description = "Projeto da Aplicação"
}

variable "environment" {
  type        = string
  description = "Ambiente de Desenvolvimento"
}

variable "domain" {
  type        = string
  description = "Dominio da aplicação"
}