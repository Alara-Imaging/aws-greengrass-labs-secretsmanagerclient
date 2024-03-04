provider "aws" {
  region = var.region
}

module "aws_secrets_manager_client" {
  source = "../"
}
