module "eks" {

  source  = "terraform-aws-modules/eks/aws"
  version = "20.24.0"

  cluster_name    = local.eks_cluster_name
  cluster_version = var.cluster_version

  enable_cluster_creator_admin_permissions = true



  vpc_id     = module.vpc.vpc_id
  subnet_ids = data.aws_subnets.private.ids

  create_node_security_group = false


  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  eks_managed_node_group_defaults = {
    disk_size                  = 20
    use_custom_launch_template = false

    attach_cluster_primary_security_group = true

    # Disabling and using externally provided security groups
    create_security_group = false

  }

  eks_managed_node_groups = {
    databases_ng = {
      name      = "databases_ng"
      subnet_id = [module.vpc.database_subnets[0]]


      instance_types = [var.databases_ng_node_group_instance_types]
      capacity_type  = "ON_DEMAND"
      min_size       = var.databases_ng_node_group_capacity_min_size
      desired_size   = var.databases_ng_node_group_capacity_desired_size
      max_size       = var.databases_ng_node_group_capacity_max_size

      labels = {
        group : "DatabasesGroup"
      }

      taints = [
        {
          key    = "dedicated"
          value  = "DatabasesGroup"
          effect = "NO_SCHEDULE"
        },
        {
          key    = "dedicated"
          value  = "DatabasesGroup"
          effect = "NO_EXECUTE"
        }
      ]
    }

    general_ng = {
      name           = "general_ng"
      subnet_ids     = data.aws_subnets.private.ids
      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
      min_size       = 2
      desired_size   = 3
      max_size       = 5

    }


  }

  cluster_security_group_additional_rules = {
    ingress_pvt_cluster = {
      description = "Access EKS from VPC."
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = [var.vpc_cidr]
    }
  }
  depends_on = [
    module.vpc
  ]
}

module "eks_aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~>20.8.4"

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn : module.eks.eks_managed_node_groups.databases_ng.iam_role_arn
      username : "system:node:{{EC2PrivateDNSName}}"
      groups : ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn : module.eks.eks_managed_node_groups.general_ng.iam_role_arn
      username : "system:node:{{EC2PrivateDNSName}}"
      groups : ["system:bootstrappers", "system:nodes"]
    }
  ]


  aws_auth_users = [
    {
      userarn : aws_iam_user.logs_user.arn
      groups : ["log-viewer"]
    }
  ]
}





data "aws_subnets" "private" {
  filter {
    name   = "tag:Type"
    values = ["Private Subnet"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Type"
    values = ["Public Subnet"]
  }
}

data "aws_caller_identity" "current" {}

resource "aws_eks_addon" "ebs_eks_addon" {
  depends_on               = [aws_iam_role_policy_attachment.ebs_csi_iam_role_policy_attach]
  cluster_name             = "dev_cluster"
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi_iam_role.arn
}




