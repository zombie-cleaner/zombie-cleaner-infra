# Data sources ================================================================================

# Get the default VPC for the region
data "aws_vpc" "default" {
  default = true
}

# Get default subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get the latest Amazon Linux 2023 ARM64 AMI
data "aws_ssm_parameter" "amazon_linux_2023_arm" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
}

# Security group ==============================================================================

resource "aws_security_group" "springboot_sg" {
  name        = "${var.globalConfigs.appName}-${var.globalConfigs.environment}-springboot-sg"
  description = "Security group for Spring Boot EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name        = "${var.globalConfigs.appName}-${var.globalConfigs.environment}-springboot-sg"
    Environment = var.globalConfigs.environment
    App         = var.globalConfigs.appName
  }
}

# SSH access
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.springboot_sg.id
  cidr_ipv4         = var.ec2Config.ssh_allowed_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "SSH access"
}

# Spring Boot application port
resource "aws_vpc_security_group_ingress_rule" "springboot" {
  security_group_id = aws_security_group.springboot_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.ec2Config.spring_boot_port
  to_port           = var.ec2Config.spring_boot_port
  ip_protocol       = "tcp"
  description       = "Spring Boot application port"
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.springboot_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

# IAM role for EC2 ============================================================================

resource "aws_iam_role" "ec2_s3_read_role" {
  name = "${var.globalConfigs.appName}-${var.globalConfigs.environment}-ec2-s3-read"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = var.globalConfigs.environment
    App         = var.globalConfigs.appName
  }
}

resource "aws_iam_policy" "ec2_s3_read_policy" {
  name        = "${var.globalConfigs.appName}-${var.globalConfigs.environment}-ec2-s3-read"
  description = "Allow EC2 to read S3 objects for Spring Boot JAR download"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.ec2Config.app_jar_s3_bucket}",
          "arn:aws:s3:::${var.ec2Config.app_jar_s3_bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_read_attach" {
  role       = aws_iam_role.ec2_s3_read_role.name
  policy_arn = aws_iam_policy.ec2_s3_read_policy.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.globalConfigs.appName}-${var.globalConfigs.environment}-ec2-profile"
  role = aws_iam_role.ec2_s3_read_role.name
}

# EC2 instance ================================================================================

resource "aws_instance" "springboot" {
  ami                    = data.aws_ssm_parameter.amazon_linux_2023_arm.value
  instance_type          = var.ec2Config.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.springboot_sg.id]
  key_name               = var.ec2Config.ssh_key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user-data.tftpl", {
    app_name         = var.globalConfigs.appName
    environment      = var.globalConfigs.environment
    region           = var.globalConfigs.region
    jar_s3_bucket    = var.ec2Config.app_jar_s3_bucket
    jar_s3_key       = var.ec2Config.app_jar_s3_key
    java_version     = var.ec2Config.java_version
    spring_boot_port = var.ec2Config.spring_boot_port
  })

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true

    tags = {
      Name        = "${var.globalConfigs.appName}-${var.globalConfigs.environment}-root-volume"
      Environment = var.globalConfigs.environment
      App         = var.globalConfigs.appName
    }
  }

  tags = {
    Name        = "${var.globalConfigs.appName}-${var.globalConfigs.environment}-springboot"
    Environment = var.globalConfigs.environment
    App         = var.globalConfigs.appName
  }
}

# Elastic IP (free when associated to a running instance) =====================================

resource "aws_eip" "springboot" {
  domain   = "vpc"
  instance = aws_instance.springboot.id

  tags = {
    Name        = "${var.globalConfigs.appName}-${var.globalConfigs.environment}-springboot-eip"
    Environment = var.globalConfigs.environment
    App         = var.globalConfigs.appName
  }
}
