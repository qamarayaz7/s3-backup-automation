# Terraform version requirement
terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket = "qamar-terraform-state-2772"   #  new backend bucket
    key    = "s3-backup-automation/terraform.tfstate"   # folder + file name for THIS project
    region = "us-east-1"                   
}
}
# AWS provider

provider "aws" {
  region = "us-east-1"  
}
