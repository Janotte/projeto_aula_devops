# Este módulo cria uma VPC com sub-redes públicas e privadas em duas zonas de disponibilidade.
module "main" {
  source                = "./modules/vpc"
  vpc_name              = "${var.project}-${var.environment}-vpc"
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_a_cidr  = "10.0.1.0/24"
  public_subnet_b_cidr  = "10.0.2.0/24"
  private_subnet_a_cidr = "10.0.101.0/24"
  private_subnet_b_cidr = "10.0.102.0/24"
  region                = var.region
  project               = var.project
  environment           = var.environment
}

# Cria o bucket S3 para armazenar os arquivos
module "upload_bucket" {
  source      = "./modules/s3"
  bucket_name = "${var.project}-${var.environment}-bucket.${var.domain}"
  project     = var.project
  environment = var.environment
  domain      = var.domain
}
