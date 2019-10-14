resource "aws_s3_bucket" "cicd-bucket" {
  bucket = var.cicd_bucket_name
  acl    = "private"
}

resource "aws_codepipeline" "cicd" {
  name     = var.cicd_project_name
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.cicd-bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["code"]

      configuration = {
        Owner  = var.github_owner
        Repo   = var.github_repo_name
        OAuthToken = var.github_token
        Branch = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["code"]
      output_artifacts  = ["package"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["package"]
      version         = "1"
      run_order       = "2"

      configuration = {
        ActionMode    = "CHANGE_SET_REPLACE"
        StackName     = "${var.cicd_project_name}-stack"
        ChangeSetName = "${var.cicd_project_name}-change-set"
        RoleArn       = aws_iam_role.cloudformation.arn
        Capabilities  = "CAPABILITY_IAM"
        TemplatePath  = "package::packaged.yaml"
      }
    }

    action {
      name            = "Execute"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["package"]
      version         = "1"
      run_order       = "3"

      configuration = {
        ActionMode    = "CHANGE_SET_EXECUTE"
        StackName     = "${var.cicd_project_name}-stack"
        ChangeSetName = "${var.cicd_project_name}-change-set"
      }
    }
  }
}
