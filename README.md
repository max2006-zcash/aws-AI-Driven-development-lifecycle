# AWS AI-Driven Development Lifecycle

An AWS reference foundation for an AI-assisted software development and delivery platform. It connects AI engineering workflows with a secure Kubernetes runtime and a GitOps-oriented delivery process.

## Architecture overview

```text
Developers -> Git repository / CI pipeline -> Container build -> Amazon ECR
                         |                                      |
                         v                                      v
                AI agent on Amazon EKS <------------------ Kubernetes platform
                         |
                         +--> Amazon Bedrock (approved foundation models)
                         +--> MCP / approved engineering tools (application layer)
                         |
                         +--> S3 versioned artifacts and evaluation datasets

Follow-on platform layers: Argo CD, CI runners, policy/supply-chain controls,
metrics, logs, traces, secrets integration and deployment automation.
```

## Repository layout

- Root Terraform files — VPC, EKS, IAM, ECR and S3 infrastructure.
- terraform.tfvars.example — example inputs to customize.

## Quick start

Terraform files now live in the repository root. The infrastructure foundation provisions AWS resources only; Argo CD, CI runners, MCP gateway, policy enforcement, observability and AI application components are separate Kubernetes/GitOps layers and are not installed by this stack.

## Security principles

- Private EKS worker nodes and restricted Kubernetes API access.
- IAM Roles for Service Accounts (IRSA) for AI workload identity.
- Bedrock model permissions and private encrypted S3 artifact storage.
- ECR image scanning and immutable image tags.
- No committed credentials, state files or environment-specific secrets.

This is a reference implementation, not a turnkey production platform. Review IAM permissions, networking, supported EKS versions, regional Bedrock model access, backup/DR, observability and cost controls before production use.


## Terraform deployment

This stack provisions the AWS foundation for the AI-assisted delivery platform:

- VPC with public/private subnets across two Availability Zones, Internet Gateway and NAT Gateway
- Amazon EKS control plane, private managed node group and core add-ons
- ECR repository for the AI agent container
- Private, encrypted and versioned S3 bucket for artifacts/evaluation data
- IRSA role for the `ai-platform/ai-agent` service account with Bedrock and S3 permissions

It does not install Argo CD, CI runners, an MCP gateway, policy engines, observability or application workloads. Deploy those as separately versioned Kubernetes/GitOps layers.

### Prerequisites

- Terraform 1.6 or later and AWS CLI credentials with VPC, IAM, EKS, EC2, ECR and S3 permissions
- An EKS Kubernetes version supported in the selected region
- Bedrock access enabled for the intended model or inference profile

### Deploy

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Replace the example EKS API allow-list with your real office/VPN public egress CIDR.
3. Replace the Bedrock wildcard with approved model/inference-profile ARNs. Review region, AZs, CIDRs, EKS version and node sizing.
4. Run:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Configure kubectl and create the workload identity:

```bash
aws eks update-kubeconfig --region <aws-region> --name <cluster-name>
kubectl get nodes
kubectl create namespace ai-platform
kubectl create serviceaccount ai-agent -n ai-platform
kubectl annotate serviceaccount ai-agent -n ai-platform eks.amazonaws.com/role-arn=<ai_workload_role_arn>
```

The workload should use the AWS SDK default credential chain and web identity token flow. Do not store long-lived AWS access keys in Kubernetes Secrets.

### Security and cost notes

- `203.0.113.10/32` is documentation-only. Replace it before applying or you may block your workstation from the public EKS API endpoint.
- The sample uses one NAT Gateway for simplicity and cost; it is a single-AZ egress dependency. Production should consider one NAT Gateway per AZ.
- Configure a remote encrypted Terraform state backend with locking before team use. Never commit state files, plans, credentials or real `.tfvars` files.
- Review AWS quotas, EKS version availability, subnet capacity, Bedrock model access and costs before applying.
- The S3 bucket is versioned. Export and remove required object versions before destroying it.

Destroy only after reviewing the plan:

```bash
terraform destroy
```
