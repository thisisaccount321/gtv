
output "aws_access_key_id" {
  value = aws_iam_access_key.logs_user_key.id
}

output "aws_secret_access_key" {
  value     = aws_iam_access_key.logs_user_key.secret
  sensitive = true
}


output "vpn_eip" {
  value = aws_eip.vpn_server.public_ip
}

output "vpn_ebs_id" {
  value = aws_ebs_volume.vpn_ebs.id
}

