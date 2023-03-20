locals {
  artifacts_bucket_name = format(%s-artifacts-%s-%s, lower(replace(var.name,"_","-"), lower(var.short_id), data.aws_region.current.name))
  github_connection_arn = 
}

resource "aws_s3_bucket" "artifacts_bucket"{
  bucket = local.artifacts_bucket_name
  force_destroy = true # when terraform is destroyed bucket will be deleted
}

resource "aws_s3_bucket_acl" "artifacts_bucket_acl"{
  bucket = aws_s3_bucket.artifacts_bucket.id
  acl = "private"
}

resource "aws_s3_bucket_public_access_block" "artifacts_public_access" {
  bucket = aws_s3_bucket.artifacts_bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifacts_bucket_encryption" {
  bucket = aws_s3_bucket.artifacts_bucket.id
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_codestarconnections_connection" "gh_connection"{
  count = var.github_connection_arn == null ? 1 :0
  name = "${var.name}-gh-${var.short_id}"
  provider_type = "Github"
}

resource "aws_sns_topic" "deploy_topic"{
  name = "${var.name}-pipeline-notification-${var.short_id}"
}

resource "aws_codepipeline" "pipeline"{
  name = "${var.name}-pipeline-${var.short_id}"
  role_arn = aws_iam_role.codepipeline_role.arn
  
  artifact_store {
    location = aws_s3_bucket.artifacts_bucket.bucket
    type = "S3"
  }

  stage {
    name = "Source"
    action {
      category = "Source"
      configuration = {
        "BranchName" = var.branch_name
        "ConnectionArn" = local.github_connection_arn
        "FullRepositoryId" = "${var.githubowner}/${var.repository_name}"
        "OutputArtifactFormat" = "CODE_ZIP"
      }
      name = "Source"
      provider = "CodeStarSourceConnection"
      owner = "AWS"
      run_order = 1
      version = "1"
      input_artifacts = []
      output_artifacts = ["SourceArtifact"]
  }
  }
  stage {
    name = "Build"
    action {
      name = "Build"
      owner = "AWS"
      category = "Build"
      provider = "CodeBuild"
      input_artifacts = ["SourceArtifacts"]
      output_artifacts = ["BuildArtifact"]
      configuration = {
        "ProjectName" = aws_codebuild_project.build.name
      }
      run_order = 1
      version = "1"
    }
  }

  stage {
    name = "Approve"
    action {
      category = "Approval"
      configuration = {
        "NotificationArn" = aws_sns_topic.deploy_topic.arn
      }
      name = "Approve"
      owner = "AWS"
      provider = "Manual"
      run_order = 1
      version = "1"
    }
  }

  dynamic "stage"{
    for_each = var.deploy_codebuild_config
    content {
      name = "Deploy"
      action {
        name = "Deploy"
        category = stage.value["category"]
        configuration = stage.value["configuration"]
        owner = "AWS"
        input_artifacts = ["BuildArtifact"]
        provider = stage.value["provider"]
        run_order = 1
        version = "1"
      }
    }
  }
}

