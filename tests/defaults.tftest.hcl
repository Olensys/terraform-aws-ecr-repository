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

run "test_immutable_tags" {
  command = plan

  # SMOKE: child-module resources are not addressable from tests, so this only asserts the requested name and an empty tag map; the hardcoded IMMUTABLE tag mutability is only truly checked by a real apply (the nightly complete.tftest.hcl applies the example but asserts nothing about this setting) and, where applicable, enforced statically by trivy.
  assert {
    condition     = output.name == "example" && output.id == "example"
    error_message = "Repository must plan with the requested name."
  }

  assert {
    condition     = length(output.tags) == 0
    error_message = "Tags must be the merge of context.extra_tags and tags."
  }
}

run "test_tags_contract" {
  command = plan

  variables {
    tags = { Owner = "x" }
    context = {
      organization = "olensys"
      environment  = "test"
      application  = "example"
      owner        = "platform"
      cost_center  = "eng"
      extra_tags   = { Owner = "y", Team = "z" }
    }
  }

  assert {
    condition     = output.tags.Owner == "x"
    error_message = "var.tags must win over context.extra_tags."
  }

  assert {
    condition     = output.tags.Team == "z"
    error_message = "context.extra_tags must be merged."
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
