variable "ec2_access_s3_role_name" {
  type        = string
  description = "Nome da função IAM para acesso ao S3"
}
variable "ec2_access_s3_policy_name" {
  type        = string
  description = "Nome da política IAM para acesso ao S3"    
}
variable "ec2_profile_name" {
  type        = string
  description = "Nome do perfil de instância IAM"
}
variable "ec2_instance_profile_name" {
  type        = string
  description = "Nome do perfil de instância IAM"
}
variable "bucket_arn" {
  type        = string
  description = "ARN do bucket S3"
}