# Changelog

## [1.1.0](https://github.com/Olensys/terraform-aws-ecr-repository/compare/v1.0.4...v1.1.0) (2026-10-25)


### Features

* add image_tag_mutability input ([#5](https://github.com/Olensys/terraform-aws-ecr-repository/issues/5)) ([cf5a5e9](https://github.com/Olensys/terraform-aws-ecr-repository/commit/cf5a5e9e69b10e31f0b663064a0abfca8a0fb26b))

## [1.0.4](https://github.com/Olensys/terraform-aws-ecr-repository/compare/v1.0.3...v1.0.4) (2026-10-24)


### Bug Fixes

* **examples:** unique application slug so concurrent integration runs do not collide ([#2](https://github.com/Olensys/terraform-aws-ecr-repository/issues/2)) ([0a3e50d](https://github.com/Olensys/terraform-aws-ecr-repository/commit/0a3e50d8cb0e0a7a425bac2f06f24c8135656ba9))

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
