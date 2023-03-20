resource "aws_codebuild_project" "build"{
  name = "${var.name}-build-${var.short_id}"
  service_role = data.aws_iam_role.codebuild_role.arn
  artifacts {
    name = aws_s3_bucket.artifacts_bucket.id
    override_artifact_name = false
    packaging = "NONE"
    type = "CODEPIPELINE"
  }
  cache {
    location = aws_s3_bucket.artifacts_bucket.bucket
    type = "S3"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true
    type = "LINUX_CONTAINER"
    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name = environment_variable.value["name"]
        value = environment_variable.value["value"]
        type = environment_variable.value["type"]
      }
    }
  }
  source {
    buildspec = var.buildspec
    git_clone_depth = 0
    insecure_ssl = false
    report_build_status = false
    type = "CODEPIPELINE"
  }
}