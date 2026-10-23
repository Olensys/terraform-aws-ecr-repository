# terraform-aws-ecr-repository

ECR repository with immutable tags, scan on push and a lifecycle policy that keeps the last N images

## Opinions

- Image tags are `IMMUTABLE`.
- Scan on push is enabled.
- Force delete is disabled; a repository that still holds images cannot be destroyed.
- Encryption is `AES256` unless `kms_key_arn` is set, then `KMS` with that key.
- The lifecycle policy expires untagged images after 7 days and keeps the last `keep_last_images` (default 30) images.
- Pull access is granted only to `pull_principals`; with none, no repository policy is created.

## Usage

```hcl
module "naming" {
  source  = "git::https://github.com/Olensys/terraform-null-naming.git?ref=v1.0.1"
  context = var.context
}

module "ecr_repository" {
  source  = "git::https://github.com/Olensys/terraform-aws-ecr-repository.git?ref=v1.0.2"
  name    = module.naming.name
  context = var.context

  tags = module.naming.tags
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0, < 7.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_this"></a> [this](#module\_this) | terraform-aws-modules/ecr/aws | 3.2.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_context"></a> [context](#input\_context) | Deployment context used for naming, tagging and environment-dependent defaults. | <pre>object({<br/>    organization = string<br/>    environment  = string<br/>    application  = string<br/>    component    = optional(string)<br/>    owner        = string<br/>    cost_center  = string<br/>    extra_tags   = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Resource name. Lowercase letters, digits and hyphens. | `string` | n/a | yes |
| <a name="input_create"></a> [create](#input\_create) | Whether to create any resources. Set false to plan nothing. | `bool` | `true` | no |
| <a name="input_keep_last_images"></a> [keep\_last\_images](#input\_keep\_last\_images) | Number of tagged images to keep. Older images are expired by the lifecycle policy. | `number` | `30` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS key ARN for repository encryption. Null uses AES256 (AWS-managed); set to use KMS. | `string` | `null` | no |
| <a name="input_pull_principals"></a> [pull\_principals](#input\_pull\_principals) | IAM principal ARNs granted read (pull) access through the repository policy. Empty creates no repository policy. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags merged onto every taggable resource, applied last. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the repository. Null when create is false. |
| <a name="output_id"></a> [id](#output\_id) | Identifier of the repository (its name). Null when create is false. |
| <a name="output_lifecycle_policy_json"></a> [lifecycle\_policy\_json](#output\_lifecycle\_policy\_json) | Lifecycle policy document applied to the repository. Null when create is false. |
| <a name="output_name"></a> [name](#output\_name) | Name of the repository. Null when create is false. |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags applied to every taggable resource, with context.extra\_tags merged in. Null when create is false. |
| <a name="output_url"></a> [url](#output\_url) | URL of the repository (registry host and repository name). Null when create is false. |
<!-- END_TF_DOCS -->
