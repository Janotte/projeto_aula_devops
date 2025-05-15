variable "region" {
  type        = string
  description = "Nome do projeto"
  default     = "us-east-2"
}

variable "profile" {
  type        = string
  description = "Profile utilizada no projeto"
  default     = "devops"
}

variable "project" {
  type        = string
  description = "Projeto da Aplicação"
  default     = "devops"
}

variable "environment" {
  type        = string
  description = "Ambiente de Desenvolvimento"
  default     = "dev"
}