# This file contains outputs from the module
# https://www.terraform.io/docs/configuration/outputs.html

output "account_id" {
  description = "AWS accountid"
  value       = data.aws_caller_identity.current.account_id
}
