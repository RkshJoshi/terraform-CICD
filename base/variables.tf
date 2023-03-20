variable "deployspec"{
  type = string
  description = "Deploy definition"
  default = null
}

variable "short_id" {
  type= string
  description = "value to use to provide uniqueness to the resources"
  validation {
    condition = can(regex("[[:alnum]]", var.short_id))
    error_message = "The short id can contain only alphanumeric chars"
  }
}

variable "name" {
  type = string
  description = "Name of the pipeline"
}

variable "github_connection_arn" {
  type = string
  description = "The connection ARN of the source version control"
  default = null
}

variable "extra_policy_arns" {
  type = list(string)
  description = "Additional Permission to be added to the pipeline service role"
  default = []
}

variable "branch_name"{
  type = string
  description = "Provide the branch Name of the Github repo"
  default = "main"
}

variable "repository_name" {
  type = string
  description = "Repository URL of the github repo where code is stored"
}

variable "githubowner" {
  type= string
  description = "Specify the name of the github owner"
}


variable "deploy_codebuild_config"{
  type = list(any)
  description = "Codebuild configuration"
  default = []
}

variable "environment_variables"{
  type = map
  description = "Environment variables for codebuild"
}

variable "cross_account_id"{
  type = string
  description = "Cross account Id if resources needs to be deployed to other account"
  default = null
}