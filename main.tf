/**
* # AWS template for IaC Terraform module
* The following is a template for a terraform repository that brings you some extra useful guidelines on how to start a terraform project from scratch with AWS cloud provider.
* 
* ## How to use this template
* 
* 1. Start with "Use this template"
* 2. Choose a repository Name, Description, Public/Private/Internal and to include all branches.
* 3. After working on your Terraform module repo, there is a Github Workflow that perform certain actions (see below structure)
* 4. README.md file is automatically generated
* 5. The overall diagram can be changed and commited directly from Draw.io: https://app.diagrams.net/
* 6. To generate the resource graph follow the documentation: https://graphviz.org/about/
* 7. Extra tools :
*  - **terraform-docs** used to generate terraform modules documentation in various formats: https://terraform-docs.io/user-guide/introduction/
*  - **tflint** used as a framework and each feature is provided by plugins (Find possible errors, Warn about deprecated syntax, Enforce best practices): https://github.com/terraform-linters/tflint
*  - **pre-commit** used as a framework for managing and maintaining multi-language pre-commit hooks: https://pre-commit.com/#intro
*  - **tfsec** uses static analysis of your terraform code to spot potential misconfigurations: https://github.com/aquasecurity/tfsec
*
* ## Instalation
* 
* ```console
* brew install hashicorp/tap/terraform
* brew install terraform-docs
* brew install pre-commit
* brew install tflint
* brew install tfsec
* brew install graphviz
* ```
* ## Usage
* ```console
* terraform init
* terraform graph | dot -Tsvg > ./docs/graph.svg
* terraform-docs -c .terraform-docs.yml . 
* pre-commit run -a (manual run) or pre-commit install (automatic run)
* ```
*
* ## Template structure
*
* ```
* |-  .github
* |   |- workflows
* |       |-  terraform.yml -> (github workflow configurations)
* |           |-  -> (Upon commit on braches master and develop, it performs:)
* |           |-  -> (Setup Terraform)
* |           |-  -> (Terraform format)
* |           |-  -> (Terraform validate)
* |           |-  -> (Auto-generate README file)
* |-  docs
* |   |-  architecture.drawio.svg -> (edit your solution diagram directly from draw.io, see image below)
* |   |-  graph.svg  -> (auto-generated resource graph)
* |-  examples
* |   |- basic -> (required)
* |      |-  main.tf -> (if a reusable module, use this folder to give an example of how to use the module)
* |   |- name subfolder for more exemples -> (optional)
* |-  .gitignore  -> (congifure what to ignore on git commit)
* |-  .pre-commit-config.yaml  -> (describes what repositories and hooks are installed)
* |-  .terraform-docs.yml  -> (configuration to autogenerate README markdown from main.tf)
* |-  CHANGELOG.md (!Do not edit, this file is auto-generated!)
* |-  data.tf  -> (This file contains data resources only.)
* |          |-  -> (If this file if not needed, can be removed.) 
* |          |-  -> (Check: https://www.terraform.io/docs/configuration/data-sources.html)
* |-  main.tf  -> (Write here your module description to be generated on README)
* |-  outputs.tf -> (This file contains outputs from the module)
* |          |-  -> Check: https://www.terraform.io/docs/configuration/outputs.html )
* |-  README.md (!Do not edit, this file is auto-generated!)
* |-  variables.tf -> (This file contains variables definition for the module.)
* |          |-  -> Check: https://www.terraform.io/docs/configuration/variables.html)
* ```
*
* ## Architectural Diagram
* ![Architecture](./docs/architecture.drawio.svg "Architecture")
*/

terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4, <5"
    }
  }
}

data "aws_caller_identity" "current" {}
