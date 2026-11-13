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

- terraform/ — VPC, EKS, IAM, ECR and S3 infrastructure.
- terraform/README.md — deployment, workload identity and security instructions.
- terraform/terraform.tfvars.example — example inputs to customize.

## Quick start

See the [Terraform deployment guide](terraform/README.md). The Terraform foundation provisions AWS infrastructure only. Argo CD, CI runners, MCP gateway, policy enforcement, observability and AI application components are separate Kubernetes/GitOps layers and are not installed by this stack.

## Security principles

- Private EKS worker nodes and restricted Kubernetes API access.
- IAM Roles for Service Accounts (IRSA) for AI workload identity.
- Bedrock model permissions and private encrypted S3 artifact storage.
- ECR image scanning and immutable image tags.
- No committed credentials, state files or environment-specific secrets.

This is a reference implementation, not a turnkey production platform. Review IAM permissions, networking, supported EKS versions, regional Bedrock model access, backup/DR, observability and cost controls before production use.
