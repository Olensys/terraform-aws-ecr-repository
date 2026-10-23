variable "name" {
  description = "Resource name. Lowercase letters, digits and hyphens."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{1,256}$", var.name))
    error_message = "name must match ^[a-z0-9-]{1,256}$."
  }
}

variable "context" {
  description = "Deployment context used for naming, tagging and environment-dependent defaults."
  type = object({
    organization = string
    environment  = string
    application  = string
    component    = optional(string)
    owner        = string
    cost_center  = string
    extra_tags   = optional(map(string), {})
  })
  validation {
    condition     = contains(["dev", "staging", "prod", "test", "shared"], var.context.environment)
    error_message = "context.environment must be one of dev, staging, prod, test, shared."
  }
}

variable "create" {
  description = "Whether to create any resources. Set false to plan nothing."
  type        = bool
  default     = true
}

variable "keep_last_images" {
  description = "Number of tagged images to keep. Older images are expired by the lifecycle policy."
  type        = number
  default     = 30
  validation {
    condition     = var.keep_last_images >= 1 && var.keep_last_images <= 1000 && floor(var.keep_last_images) == var.keep_last_images
    error_message = "keep_last_images must be a whole number between 1 and 1000."
  }
}

variable "pull_principals" {
  description = "IAM principal ARNs granted read (pull) access through the repository policy. Empty creates no repository policy."
  type        = list(string)
  default     = []
}

variable "kms_key_arn" {
  description = "KMS key ARN for repository encryption. Null uses AES256 (AWS-managed); set to use KMS."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags merged onto every taggable resource, applied last."
  type        = map(string)
  default     = {}
}
