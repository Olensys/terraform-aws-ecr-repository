output "id" {
  description = "Identifier of the repository (its name). Null when create is false."
  value       = var.create ? var.name : null
}

output "name" {
  description = "Name of the repository. Null when create is false."
  value       = var.create ? var.name : null
}

output "arn" {
  description = "ARN of the repository. Null when create is false."
  value       = var.create ? module.this.repository_arn : null
}

output "url" {
  description = "URL of the repository (registry host and repository name). Null when create is false."
  value       = var.create ? module.this.repository_url : null
}

output "lifecycle_policy_json" {
  description = "Lifecycle policy document applied to the repository. Null when create is false."
  value       = var.create ? local.lifecycle_policy_json : null
}

output "tags" {
  description = "Tags applied to every taggable resource, with context.extra_tags merged in. Null when create is false."
  value       = var.create ? local.tags : null
}
