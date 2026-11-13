# Terraform reference deployment

This Terraform stack provisions the AWS foundation for an AI-assisted software delivery platform:

- VPC with public and private subnets across two Availability Zones
- Internet Gateway and a single NAT Gateway for private subnet egress
- Amazon EKS control plane and managed node group in private subnets
- EKS core add-ons: VPC CNI, CoreDNS and kube-proxy
- ECR repository for the AI agent container
- Private, encrypted and versioned S3 bucket for artifacts and evaluation data
- IRSA role for service account ai-platform/ai-agent with Bedrock and S3 permissions

This foundation does not install Argo CD, CI runners, an MCP gateway, policy engines, observability or application workloads. Deploy those as separately versioned Kubernetes/GitOps layers.

## Prerequisites

- Terraform 1.6 or later
- AWS credentials authorized to create VPC, IAM, EKS, EC2, ECR and S3 resources
- An EKS Kubernetes version supported in the selected AWS region
- Access enabled for the Bedrock model/inference profile you intend to use

## Deploy

1. Copy terraform.tfvars.example to terraform.tfvars.
2. Set a real EKS API allow-list CIDR (office/VPN public egress) and approved Bedrock model ARN(s).
3. Review the region, AZ names, subnet CIDRs, EKS version and node sizing.
4. Run:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Configure kubectl:

```bash
aws eks update-kubeconfig --region <aws-region> --name <cluster-name>
kubectl get nodes
```

Create the AI workload identity:

```bash
kubectl create namespace ai-platform
kubectl create serviceaccount ai-agent -n ai-platform
kubectl annotate serviceaccount ai-agent -n ai-platform eks.amazonaws.com/role-arn=<ai_workload_role_arn>
```

The AI workload should use the AWS SDK default credential chain and web identity token flow. Do not place long-lived AWS access keys in Kubernetes Secrets.

## Security and cost notes

- The sample CIDR 203.0.113.10/32 is documentation-only. Replace it before applying or you may lock out your workstation from the public EKS API endpoint.
- Replace the default Bedrock resource wildcard with exact approved model or inference-profile ARNs. ARN formats differ between foundation models and inference profiles.
- A single NAT Gateway is used to keep this development example simpler and less expensive. It is a single-AZ egress dependency; production should consider one NAT Gateway per AZ.
- EKS private endpoint access is enabled, public endpoint access is CIDR-restricted, and worker nodes run in private subnets.
- Configure a remote encrypted Terraform state backend with locking before team use. Never commit state files, plans, credentials or real tfvars.
- Review AWS quotas, EKS version availability, subnet capacity, Bedrock model access and estimated costs before applying.

## Destroy

Run terraform destroy after reviewing the plan. The S3 bucket is versioned; export and remove required object versions before destroying it.
