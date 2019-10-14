resource "aws_codebuild_project" "build" {
  name          = var.cicd_project_name
  description   = var.cicd_codebuild_project_description
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild.arn

  cache {
    type     = "S3"
    location = aws_s3_bucket.cicd-bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status    = "ENABLED"
      location  = "${aws_s3_bucket.cicd-bucket.id}/${var.cicd_project_name}-logs"
    }
  }

  artifacts {
    type      = "CODEPIPELINE"
  }

  source {
    type = "CODEPIPELINE"
  }
}
