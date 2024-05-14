plugin "aws" {
    enabled = true
    version = "0.31.0"

    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "terraform" {
  enabled = true
}

rule "aws_resource_missing_tags" {
  enabled = true
  tags = ["TerraformModule"]
}

rule "aws_iam_policy_gov_friendly_arns" {
  enabled = true
}

rule "aws_iam_policy_document_gov_friendly_arns" {
  enabled = true
}

rule "aws_iam_role_policy_gov_friendly_arns" {
  enabled = true
}