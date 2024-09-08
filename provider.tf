terraform {
  backend "s3" {
    bucket         = "gtv-tfstate-backend"
    key            = "terraform/state"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.15.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0" # Specify the version range
    }
    # kubectl = {
    #   source = "gavinbunney/kubectl"
    #   version = "1.14.0"
    # }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "tfstate_backend" {
  bucket = "gtv-tfstate-backend"

}

resource "aws_s3_bucket_versioning" "tfstate_backend_versioning" {
  bucket = aws_s3_bucket.tfstate_backend.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_backend_encryption" {
  bucket = aws_s3_bucket.tfstate_backend.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Options are "AES256" or "aws:kms"
    }
  }
}


resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-lock-table"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform Lock Table"
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}