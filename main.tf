locals {
  tags = merge(var.context.extra_tags, var.tags)

  create_policy = var.create && length(var.pull_principals) > 0

  lifecycle_policy = {
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Keep the last ${var.keep_last_images} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.keep_last_images
        }
        action = { type = "expire" }
      },
    ]
  }

  lifecycle_policy_json = jsonencode(local.lifecycle_policy)
}

module "this" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "3.2.0"

  create            = var.create
  create_repository = var.create
  repository_name   = var.name

  repository_image_tag_mutability = var.image_tag_mutability
  repository_image_scan_on_push   = true
  repository_force_delete         = false

  repository_encryption_type = var.kms_key_arn == null ? "AES256" : "KMS"
  repository_kms_key         = var.kms_key_arn

  create_lifecycle_policy     = var.create
  repository_lifecycle_policy = local.lifecycle_policy_json

  attach_repository_policy    = local.create_policy
  create_repository_policy    = local.create_policy
  repository_read_access_arns = var.pull_principals

  tags = local.tags
}
