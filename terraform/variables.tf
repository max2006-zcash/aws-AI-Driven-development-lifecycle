variable "aws_region" { type = string, default = "eu-west-1" }
variable "project_name" { type = string, default = "ai-dev-lifecycle" }
variable "environment" { type = string, default = "dev" }
variable "cluster_name" { type = string, default = "ai-dev-lifecycle-eks" }
variable "kubernetes_version" { description = "EKS version supported in the selected region", type = string, default = "1.33" }
variable "vpc_cidr" { type = string, default = "10.40.0.0/16" }
variable "availability_zones" { type = list(string), default = ["eu-west-1a", "eu-west-1b"] }
variable "public_subnet_cidrs" { type = list(string), default = ["10.40.0.0/24", "10.40.1.0/24"] }
variable "private_subnet_cidrs" { type = list(string), default = ["10.40.10.0/24", "10.40.11.0/24"] }
variable "eks_api_public_access_cidrs" { description = "Restrict to office/VPN egress CIDRs", type = list(string), default = ["203.0.113.10/32"] }
variable "node_instance_types" { type = list(string), default = ["m6i.large"] }
variable "node_desired_size" { type = number, default = 2 }
variable "node_min_size" { type = number, default = 2 }
variable "node_max_size" { type = number, default = 4 }
variable "bedrock_model_arns" { description = "Approved Bedrock model or inference profile ARNs", type = list(string), default = ["*"] }
variable "artifact_bucket_name" { description = "Optional globally unique S3 bucket name", type = string, default = null }
