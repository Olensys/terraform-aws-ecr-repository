# Changelog

## 1.0.0

- ECR repository with immutable tags, scan on push and force delete disabled.
- Lifecycle policy expiring untagged images after 7 days and keeping the last N images (`keep_last_images`, default 30).
- Optional pull access through `pull_principals` and optional KMS encryption through `kms_key_arn`.
- Wraps `terraform-aws-modules/ecr/aws` 3.2.0.
