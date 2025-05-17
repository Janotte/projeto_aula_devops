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

# Este módulo cria o bucket S3 para armazenar os arquivos
module "upload_bucket" {
  source      = "./modules/s3"
  bucket_name = "${var.project}-${var.environment}.${var.domain}"
  project     = var.project
  environment = var.environment
  domain      = var.domain
}

# Este módulo cria as chaves SSH para acesso às instâncias EC2
module "ec2_key_pair" {
  source        = "./modules/key_pair"
  key_pair_name = "${var.project}_${var.environment}_ec2_key_pair"
}

#Este módulo cria o IAM para acesso ao S3
module "iam" {
  source                    = "./modules/iam"
  ec2_access_s3_role_name   = "${var.project}_${var.environment}_EC2AccessS3Role"
  ec2_access_s3_policy_name = "${var.project}_${var.environment}_EC2AccessS3RolePolicy"
  ec2_profile_name          = "${var.project}_${var.environment}_EC2Profile"
  ec2_instance_profile_name = "${var.project}_${var.environment}_EC2InstanceProfile"
  bucket_arn                = module.upload_bucket.bucket_arn
}

# Este módulo cria o grupo de segurança para as instâncias EC2
module "security_group" {
  source              = "./modules/security_group"
  security_group_name = "${var.project}-${var.environment}-sg-web"
  vpc_id              = module.main.vpc_id
  project             = var.project
  environment         = var.environment
}

# Este módulo cria uma instância EC2 com o perfil IAM associado.
module "ec2" {
  source                 = "./modules/ec2"
  ami_id                 = "ami-060a84cbcb5c14844" # Amazon Linux 2023 em us-east-2
  instance_type          = "t2.micro"
  subnet_id              = module.main.public_subnet_a_id
  vpc_security_group_ids = [module.security_group.security_group_id]
  key_name               = module.ec2_key_pair.name
  private_ip             = "10.0.1.200"
  iam_instance_profile   = module.iam.ec2_instance_profile_name
  project     = var.project
  environment = var.environment
}
