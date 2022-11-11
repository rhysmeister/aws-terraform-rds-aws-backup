terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>4.38.0"
        }
    }
}

provider "aws" {
    region  = "eu-central-1"
    profile = "aws_terraform"
}