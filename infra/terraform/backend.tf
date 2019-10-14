terraform {
  backend "s3" {
    bucket=var.s3_remote_state_bucket_name
    key="countries-api/dev/terraform.tfstate"
    region="us-west-1"
  }
}