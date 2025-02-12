# ========================================= #
# VPC
# ========================================= #
module "vpc" {
  source = "github.com/Kamran-saeed/terraform-aws-vpc"

  service_name    = local.service_name
  env             = local.env
  vpc_name        = local.vpc_name
  cidr            = local.cidr
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  azs             = local.azs
}
