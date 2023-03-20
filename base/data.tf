data "aws_caller_identity" "current"{}

data "aws_region" "region"{}

data "aws_iam_policy_document" "pipeline_assume_role" {
  version = "2012-10-17"
  statement {
    sid = "codepipeline-assume-role"
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild_assume_role" {
  version = "2012-10-17"
  statement {
    sid = "codebuild-assume-role"
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild_policy"{
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = ["s3:*"]
    resources = ["arn:aws:s3:::*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:*",
      "codestar-connections:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "pipeline_policy"{
  version = "2012-10-17"
  statement {
    sid = "s3bucketaccess"
    actions = ["s3:*"]
    effect = "Allow"
    resources = [
      aws_s3_bucket.artifacts_bucket.arn,
      "${aws_s3_bucket.artifacts_bucket.arn}/*"
    ]
  }

  statement {
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
    ]
    effect = "Allow"
    resources = ["*"]
  }

  statement {
    sid ="passroleaccess"
    effect = "Allow"
    actions = ["iam:PassRole"]
    resources = ["*"]
  }

  statement {
    actions = [
      "codepipeline:*",
      "iam:ListRoles",
      "cloudformation:Describe*",
      "cloudFormation:List*",
      "codecommit:List*",
      "codecommit:Get*",
      "codecommit:GitPull",
      "codecommit:UploadArchive",
      "codecommit:CancelUploadArchive",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codestar-connections:*",
      "cloudformation:CreateStack",
      "cloudformation:DeleteStack",
      "cloudformation:DescribeStacks",
      "cloudformation:UpdateStack",
      "cloudformation:CreateChangeSet",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DescribeChangeSet",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:SetStackPolicy",
      "cloudformation:ValidateTemplate",
      "iam:PassRole",
      "sns:*"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}