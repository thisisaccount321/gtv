# Required variables for the EC2 instance
# ami_id             = "ami-07548161ae91256a2"       # Replace with the actual AMI ID you want to use
ami_id          = "ami-01811d4912b4ccb26"
instance_type   = "t3.small" # Replace with the desired EC2 instance type
ebs_volume_size = 30         # Size of the EBS volume in GB



nginx_release_name          = "nginx"
external_nginx_release_name = "external-nginx"

nginx_chart_version = "4.8.0"
nginx_namespace     = "ingress"

cert_manager_release_name  = "cert-manager"
cert_manager_chart_version = "v1.13.1"
cert_manager_namespace     = "cert-manager"



filebeat_release_name = "filebeat"

elk_namespace = "monitoring"

filebeat_chart_version = "8.5.1"

elasticsearch_release_name = "elasticsearch"


elasticsearch_chart_version = "8.5.1"

homepage_release_name = "homepage"

homepage_namespace = "homepage"

homepage_chart_version = "2.0.1"

cluster_endpoint_public_access = false

cluster_endpoint_private_access = true

cluster_name = "dev_cluster"

cluster_version = "1.27"

databases_ng_node_group_instance_types        = "t3.medium"
databases_ng_node_group_capacity_min_size     = "0"
databases_ng_node_group_capacity_desired_size = "0"
databases_ng_node_group_capacity_max_size     = "3"

general_ng_node_group_instance_types        = "t3.large"
general_ng_node_group_capacity_min_size     = "2"
general_ng_node_group_capacity_desired_size = "3"
general_ng_node_group_capacity_max_size     = "5"

vpc_name = "my-vpc"
vpc_cidr = "10.1.0.0/16"