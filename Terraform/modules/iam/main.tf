
# Criando a função IAM para a instância EC2
resource "aws_iam_role" "ec2_access_s3_role" {
  name = var.ec2_access_s3_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Criando a política de acesso ao S3
resource "aws_iam_role_policy" "ec2_access_s3_policy" {
  name = var.ec2_access_s3_policy_name
  role = aws_iam_role.ec2_access_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:PutObjectAcl",
          "s3:GetBucketOwnershipControls"
        ],
        Resource = [
          "${var.bucket_arn}",
          "${var.bucket_arn }/*",
        ]
      }
    ]
  })
}

# Criando o perfil de instância IAM
resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.ec2_profile_name
  role = aws_iam_role.ec2_access_s3_role.id
}

# Anexando a política gerenciada do SSM à função IAM
resource "aws_iam_role_policy_attachment" "ssm_managed_policy_attachment" {
  role       = aws_iam_role.ec2_access_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}
