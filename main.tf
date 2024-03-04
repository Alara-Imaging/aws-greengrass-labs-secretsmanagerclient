data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  region            = data.aws_region.current.name
  component_name    = "aws.greengrass.labs.SecretsManagerClient"
  component_version = var.component_version
  account_id        = data.aws_caller_identity.current.account_id
}

module "component_bucket" {
  # checkov:skip=CKV_TF_1: ADD REASON
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = "com.alaracare.secretsmanagerclient-${local.region}-${data.aws_caller_identity.current.account_id}"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  attach_elb_log_delivery_policy = true

  force_destroy = true

  versioning = {
    enabled = true
  }
}

resource "null_resource" "build_and_publish" {
  triggers = {
    component_name    = local.component_name
    component_version = local.component_version
    region            = local.region
    account_id        = local.account_id
  }
  provisioner "local-exec" {
    command = <<-EOT
      # Execute GDK commands to build and publish Greengrass components
      echo ${path.module}
      cd ${path.module}
      gdk component build
      gdk component publish -r ${data.aws_region.current.name}
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      # Execute AWS CLI command to delete the Greengrass component
      aws --region ${self.triggers.region} greengrassv2 delete-component --arn arn:aws:greengrass:${self.triggers.region}:${self.triggers.account_id}:components:${self.triggers.component_name}:versions:${self.triggers.component_version}
    EOT
  }

  depends_on = [module.component_bucket]
}
