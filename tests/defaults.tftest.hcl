mock_provider "aws" {}

variables {
  context = {
    organization = "olensys"
    environment  = "test"
    application  = "example"
    owner        = "platform"
    cost_center  = "eng"
  }
  name = "example"
}

# Child-module resources are not addressable from tests. The hardcoded
# IMMUTABLE tag mutability is therefore proven statically (trivy) and by the
# real apply in complete.tftest.hcl; here we assert the repository plans with
# the requested name and merged tags.
run "test_immutable_tags" {
  command = plan

  assert {
    condition     = output.name == "example" && output.id == "example"
    error_message = "Repository must plan with the requested name."
  }

  assert {
    condition     = length(output.tags) == 0
    error_message = "Tags must be the merge of context.extra_tags and tags."
  }
}

# Same visibility limit as above for repository_image_scan_on_push = true.
run "test_scan_on_push" {
  command = plan

  variables {
    tags = { team = "platform" }
    context = {
      organization = "olensys"
      environment  = "test"
      application  = "example"
      owner        = "platform"
      cost_center  = "eng"
      extra_tags   = { env = "test" }
    }
  }

  assert {
    condition     = output.tags == tomap({ env = "test", team = "platform" })
    error_message = "var.tags must be applied last over context.extra_tags."
  }
}

run "test_lifecycle_keeps_n" {
  command = plan

  assert {
    condition     = jsondecode(output.lifecycle_policy_json).rules[1].selection.countNumber == 30
    error_message = "Default policy must keep the last 30 tagged images."
  }

  assert {
    condition     = jsondecode(output.lifecycle_policy_json).rules[0].selection.countNumber == 7 && jsondecode(output.lifecycle_policy_json).rules[0].selection.tagStatus == "untagged"
    error_message = "Rule 1 must expire untagged images after 7 days."
  }
}

run "test_lifecycle_custom_n" {
  command = plan

  variables {
    keep_last_images = 5
  }

  assert {
    condition     = jsondecode(output.lifecycle_policy_json).rules[1].selection.countNumber == 5
    error_message = "keep_last_images must drive rule 2."
  }
}

run "test_create_false_plans_nothing" {
  command = plan

  variables {
    create = false
  }

  assert {
    condition = alltrue([
      output.id == null, output.name == null, output.arn == null,
      output.url == null, output.tags == null, output.lifecycle_policy_json == null,
    ])
    error_message = "Every output must be null when create is false."
  }
}

run "test_name_length_validation" {
  command = plan

  variables {
    name = join("", [for i in range(257) : "a"])
  }

  expect_failures = [var.name]
}

run "test_keep_last_images_validation" {
  command = plan

  variables {
    keep_last_images = 0
  }

  expect_failures = [var.keep_last_images]
}
