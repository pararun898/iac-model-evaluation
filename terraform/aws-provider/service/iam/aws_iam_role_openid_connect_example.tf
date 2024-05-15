# Create an IAM Role with OIDC via the 'aws' provider

# Declare Provider values
locals {
  # Enter your identity provider FQDN. Corresponds to the iss claim.
  provider_fqdn = "idp.example.com"
  # Enter the ID that your identity provider assigned to your application.
  provider_app_id = "example_appid_from_oidc_idp"
}

# Get AWS Account information
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

# Define IAM Role
resource "aws_iam_role" "example" {
  # Define a name for your IAM Role
  name = "example"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.provider_fqdn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${local.provider_fqdn}:app_id" : local.provider_app_id
          }
        }
      },
    ]
  })
  # Add desired tags
  tags = {
    tag-key = "tag-value"
  }
}

# Define IAM Policy
resource "aws_iam_policy" "example" {
  # Define a name for your IAM Policy
  name = "example"
  path = "/"
  # Add a description for your policy
  description = "Example role with OIDC"

  # Define your IAM Policy
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "", # Add your desired actions
        ]
        Effect   = "Allow"
        Resource = "" # Add your desired resource(s)
      },
    ]
  })
}

# Define IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = aws_iam_policy.example.arn
}
