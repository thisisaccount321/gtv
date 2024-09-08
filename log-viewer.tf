resource "aws_iam_user" "logs_user" {
  name = "LogsUser"
}

resource "aws_iam_access_key" "logs_user_key" {
  user = aws_iam_user.logs_user.name
}


resource "aws_iam_policy" "eks_access_policy" {
  name        = "EKSAccessPolicy"
  description = "Policy to allow access to EKS cluster and related actions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster"
        ]
        Resource = "arn:aws:eks:ap-southeast-1:463470949045:cluster/dev_cluster"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "logs_user_policy_attachment" {
  user       = aws_iam_user.logs_user.name
  policy_arn = aws_iam_policy.eks_access_policy.arn
}



resource "kubernetes_manifest" "log-viewer-clusterrolebind" {
  manifest = yamldecode(file("${path.module}/log-viewer/log-viewer-clusterrolebind.yaml"))

  depends_on = [
    module.eks
  ]
}

resource "kubernetes_manifest" "log-viewer-clusterrole" {
  manifest = yamldecode(file("${path.module}/log-viewer/log-viewer-clusterrolebind.yaml"))

  depends_on = [
    module.eks
  ]
}

