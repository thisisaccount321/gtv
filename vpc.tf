module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs                  = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  enable_dns_support   = true
  enable_dns_hostnames = true


  # Public Subnets
  public_subnets = [
    "10.1.10.0/24",
    "10.1.11.0/24",
    "10.1.12.0/24"
  ]

  # Private Subnets for Application Workloads
  private_subnets = [
    "10.1.2.0/23",
    "10.1.4.0/23",
    "10.1.6.0/23"
  ]

  # Private Subnets for Databases
  database_subnets = [
    "10.1.8.64/26",
    "10.1.8.128/26",
    "10.1.8.192/26"
  ]
  create_database_subnet_group       = true
  create_database_subnet_route_table = true
  # NAT Gateway configuration
  enable_nat_gateway = true
  single_nat_gateway = true


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  # Additional Tags to Subnets
  public_subnet_tags = {
    Type                                              = "Public Subnet"
    Environment                                       = "dev"
    "kubernetes.io/role/elb"                          = 1
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
  }
  private_subnet_tags = {
    Type                                              = "Private Subnet"
    Environment                                       = "dev"
    "kubernetes.io/role/internal-elb"                 = 1
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
  }

  database_subnet_tags = {
    Type        = "Database Subnet"
    Environment = "dev"
  }
  # Instances launched into the Public subnet should be assigned a public IP address.
  map_public_ip_on_launch = true


}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

# EC2

# Security Group for the VPN instance
resource "aws_security_group" "vpn_access_server" {
  name        = "vpn_access_server"
  description = "Security group for VPN instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1194
    protocol    = "udp"
    to_port     = 1194
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "vpn_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  key_name               = aws_key_pair.dev_keypair.key_name
  vpc_security_group_ids = [aws_security_group.vpn_access_server.id]

  tags = {
    Name = "VPN Server"
  }

  volume_tags = {
    Name = "VPN EBS Volume"
  }
}

# EBS Volume
resource "aws_ebs_volume" "vpn_ebs" {
  availability_zone = aws_instance.vpn_server.availability_zone
  size              = var.ebs_volume_size
  type              = "gp2"

  tags = {
    Name = "VPN EBS Volume"
  }
}

# EBS Volume Attachment
resource "aws_volume_attachment" "vpn_ebs_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.vpn_ebs.id
  instance_id = aws_instance.vpn_server.id
}

# Elastic IP
resource "aws_eip" "vpn_server" {
  instance = aws_instance.vpn_server.id
}

# Upload Public Key to Parameter Store
resource "aws_ssm_parameter" "dev_public_keypair" {
  name        = "vpn_public_key"
  type        = "SecureString"
  value       = file("${path.module}/vpn_key.pub")
  description = "Public key for the VPN instance."
}

resource "aws_key_pair" "dev_keypair" {
  key_name   = "dev_keypair"
  public_key = aws_ssm_parameter.dev_public_keypair.value
}



### Variables

variable "ami_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance."
  type        = string
}

variable "ebs_volume_size" {
  description = "The size of the EBS volume in GB."
  type        = number
}


output "vpn_instance_id" {
  value = aws_instance.vpn_server.id
}

output "vpn_eip" {
  value = aws_eip.vpn_server.public_ip
}

output "vpn_ebs_id" {
  value = aws_ebs_volume.vpn_ebs.id
}

# Define Local Values in Terraform
locals {
  eks_cluster_name = "dev_cluster"
}



# Create a Private Hosted Zone
resource "aws_route53_zone" "private" {
  name = "jesse.xyz."
  vpc {
    vpc_id = module.vpc.vpc_id
  }
}


resource "aws_route53_record" "wildcard_record" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "*.jesse.xyz."
  type    = "A"
  # ttl     = 300
  alias {
    name                   = "internal-af508f7fedbcf4b65902f77a863a6dc1-1616621960.ap-southeast-1.elb.amazonaws.com"
    zone_id                = "Z1LMS91P8CMLE5" # Replace with the actual zone ID
    evaluate_target_health = true
  }
}