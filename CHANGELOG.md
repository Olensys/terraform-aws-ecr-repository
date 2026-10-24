# Changelog

## [1.0.3](https://github.com/Olensys/terraform-aws-ecr-repository/compare/v1.0.2...v1.0.3) (2026-10-24)


### Bug Fixes

* run integration on change and weekly instead of nightly ([791f7ee](https://github.com/Olensys/terraform-aws-ecr-repository/commit/791f7ee4a2424521ac84150b5c2c5662d3c31202))

## 1.0.2

### Tests

- `test_scan_on_push` (which never observed scan-on-push) is replaced by `test_tags_contract`: `tags` wins over `context.extra_tags`, and extra tags are merged.
- `test_immutable_tags` is marked `# SMOKE:` because it only asserts the name and tag map; immutability is proven by trivy and the nightly apply.

### Docs

- README Usage shows the naming module.

## 1.0.1

### Fixes

- render declared provider constraints and skip .terraform in trivy scans
- declare required_version and providers in examples/minimal

## 1.0.0

- ECR repository with immutable tags, scan on push and force delete disabled.
- Lifecycle policy expiring untagged images after 7 days and keeping the last N images (`keep_last_images`, default 30).
- Optional pull access through `pull_principals` and optional KMS encryption through `kms_key_arn`.
- Wraps `terraform-aws-modules/ecr/aws` 3.2.0.
