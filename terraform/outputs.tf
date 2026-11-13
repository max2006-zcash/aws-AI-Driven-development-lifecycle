output "vpc_id" { value = aws_vpc.this.id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }
output "public_subnet_ids" { value = aws_subnet.public[*].id }
output "eks_cluster_name" { value = aws_eks_cluster.this.name }
output "eks_cluster_endpoint" { value = aws_eks_cluster.this.endpoint }
output "ai_workload_role_arn" {
  description = "Annotate ai-platform/ai-agent service account with this role ARN."
  value       = aws_iam_role.ai_workload.arn
}
output "ai_agent_ecr_repository_url" { value = aws_ecr_repository.ai_agent.repository_url }
output "artifact_bucket_name" { value = aws_s3_bucket.artifacts.bucket }
