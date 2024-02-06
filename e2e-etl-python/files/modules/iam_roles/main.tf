resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.projectId}-e2e-IAMrole-${var.aws_region}-${var.pipeline_role_name}-${var.local_id}"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}

resource "aws_iam_role" "codebuild_role" {
  name               = "${var.projectId}-e2e-IAMrole-${var.aws_region}-${var.codebuild_role_name}-${var.local_id}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "${var.projectId}-e2e-policy-${var.aws_region}-${var.codepipeline_policy_name}-${var.local_id}"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "${var.projectId}-e2e-policy-${var.aws_region}-${var.codebuild_policy_name}-${var.local_id}"
  role   = aws_iam_role.codebuild_role.id
  policy = data.aws_iam_policy_document.codebuild_policy.json
}

data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "codepipeline_policy" {
   statement {
    sid       = ""
    actions   = [
        "cloudwatch:*",
        "s3:*",
        "codebuild:*"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    sid       = ""
    actions   = [
        "cloudwatch:*",
        "logs:*",
        "s3:*",
        "codebuild:*",
        "secretsmanager:*",
        "iam:*",
        "athena:*",
        "glue:*",
        "codepipeline:*"
      ]
    resources = ["*"]
    effect    = "Allow"
  }
}
