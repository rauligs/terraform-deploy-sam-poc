# Bootstrap terraform remote state

In order to create the initial S3 bucket to store terraform remote state has been created this terraform
configuration expected to run only once (per backend state). Kitchen tests won't work otherwise anyway so
needs to be set up prior running Kitchen tests for our lambdas.

## Run

```shell script
terraform init
terraform apply
```