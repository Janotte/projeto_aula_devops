variable "project" {
  type        = string
  description = "Projeto da Aplicação"
}

variable "environment" {
  type        = string
  description = "Ambiente de Desenvolvimento"
}

variable "ami_id" {
  type        = string
  description = "AMI da instância"
  default     = "ami-060a84cbcb5c14844" # Amazon Linux 2023 em us-east-2
}

variable "instance_type" {
  type        = string
  description = "Tipo da instância"
  default     = "t2.micro"
}

variable "subnet_id" {
  type        = string
  description = "ID da Sub-rede"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "IDs dos Grupos de Segurança"
}

variable "key_name" {
  type        = string
  description = "Nome da Chave SSH"
}

variable "private_ip" {
  type        = string
  description = "IP Privado da Instância"
}
variable "iam_instance_profile" {
  type        = string
  description = "Perfil IAM da Instância"
}