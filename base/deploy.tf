resource "aws_codebuild_project" "deploy" {
  count = var.deploy_codebuild ? 1 : 0
  name = "${var.name}-deploy-codebuild-${var.short_id}"
  service_role = aws_iam_role.codebuild_role.arn
  source {
    buildspec = var.deployspec
    git_clone_depth = 0
    insecure_ssl = false
    report_buil_status = false
    type = "CODEPIPELINE"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true
    type = "LINUX_CONTAINER"
    dynamic environment_variable {
      for_each = var.environment_variables
      content {
        name = environment_variable.value["name"]
        value = environment_variable.value["value"]
        type = environment_variable.value["type"]
      }
    }
  }
  artifacts {
    name = aws_s3_bucket.artifacts_bucket.id
    type = "CODEPIPELINE"
    packaging = "NONE"
    override_artifact_name = false
  }
}