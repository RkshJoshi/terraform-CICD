resource "aws_iam_role" "codepipeline_role"{
  name = "${var.name}-codepipeline-role-${var.short_id}"
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role.json
  force_detach_policies = true
  max_session_duration = 3600
  path = "/service-role/"
}

resource "aws_iam_policy" "pipeline_policy" {
  description = "Policy used in trust relationship with Codepipeline"
  name = "${var.name}-pipeline-policy-${var.short_id}"
  policy = data.aws_iam_policy_document.pipeline_policy.json
}

resource "aws_iam_role_policy_attachment" "policy_attach"{
  name = "${var.name}-policy-attachment-${var.short_id}"
  roles = [aws_iam_role.codepipeline_role.name]
  policy_arn = aws_iam_policy.pipeline_policy.arn
}

resource "aws_iam_role_policy_attachment" "extra_policy_attach" {
  count = var.extra_policy_arns == null ? 0 : length(var.extra_policy_arns)
  roles = [aws_iam_role.codepipeline_role.name]
  policy_arn = var.extra_policy_arns[count.index]
}

resource "aws_iam_role" "codebuild_role"{
  name = "${var.name}-codebuild-role-${var.short_id}"
  assume_role_policy = data.aws_iam_role.codebuild_assume_role.json
  force_detach_policies = true
  max_session_duration = 3600
  path = "/service-role/"
}

resource "aws_iam_policy" "codebuild_policy" {
  description = "Policy used in trust relationship with codebuild"
  name = "${var.name}-codebuild-policy-${var.short_id}"
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attach" {
  name = "${var.name}-buildpolicy-attachment-${var.short_id}"
  roles = [aws_iam_role.codebuild_role.name]
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_iam_policy" "cross_account_policy"{
  count = var.cross_account_id == null ? 0 : 1
  
  description = "Policy used for cross-account access ${var.name}"
  name = "${var.name}-cross-account-policy-${var.short_id}"
  path = "/service-role/"
  policy = jsonencode(
    {
      Statement = [
        {
          "Action" : [
            "sts:AssumeRole"
          ],
          "Effect": "Allow"
          "Resource" : "arn:aws::iam::${var.cross_account_id}:role/OrganizationAccountAccessRole"
        }
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy_attachment" "cross_account_policy_attachment" {
  count = var.cross_account_id == null ? 0 : 1
  role = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.cross_account_policy[count.index].arn
}


resource "aws_iam_role_policy_attach" "extra_build_policy_attach" {
  count = var.extra_policy_arns == null ? 0 : length(var.extra_policy_arns)
  role = aws_iam_role.codebuild_role.name
  policy_arn = var.extra_policy_arns[count.index]
}