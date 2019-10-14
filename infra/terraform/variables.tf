variable "s3_remote_state_bucket_name" {
  type        = "string"
  description = "The name for the S3 remote state bucket"
}

variable "cicd_project_name" {
  type        = "string"
  description = "Codebuild project name"
}

variable "cicd_codebuild_project_description" {
  type        = "string"
  description = "Codebuild project description"
}

variable "cicd_iam_role_name" {
  type        = "string"
  description = "The name for the iam role"
}

variable "cicd_bucket_name" {
  type        = "string"
  description = "The name for the S3 for CI/CD bucket"
}

variable "github_owner" {
  type        = "string"
  description = "Project Github Owner"
}

variable "github_repo_name" {
  type        = "string"
  description = "Project Github repository name"
}

variable "github_token" {
  type        = "string"
  description = "Git personal access token"
}