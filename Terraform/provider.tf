# Este arquivo define a configuração do provedor para AWS.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configura o provedor da AWS e define a região e perfil.
provider "aws" {
  profile = var.profile
  region  = var.region
}