locals {
  region       = "eu-west-1"
  service_name = "tfc-agent"
  env          = "demo"

  cidr            = "172.0.0.0/22"
  private_subnets = ["172.0.0.0/24", "172.0.1.0/24", "172.0.2.0/24"]
  public_subnets  = ["172.0.3.0/26", "172.0.3.64/26", "172.0.3.128/26"]
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  vpc_name = "${local.env}-${local.service_name}-vpc"
}
