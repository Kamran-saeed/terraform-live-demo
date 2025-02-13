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

# ========================================= #
# TFC Agent
# ========================================= #
module "tfc-agents" {
  source = "github.com/Kamran-saeed/terraform-aws-tfc-agent"

  for_each = toset(local.agent_pool_organizations)

  VpcId                 = module.vpc.id
  AsgSubnetIds          = module.vpc.private_subnets
  Ec2ServerAmi          = "ami-0c8c01ffe4344d79c"
  Ec2ServerInstanceType = "t3.small"
  Ec2RootVolumeType     = "gp3"
  Ec2RootVolumeSize     = 50
  MinimumHealthyPercent = 100
  AsgMinSize            = local.asg_min_count
  DesiredCount          = local.asg_desired_count
  AsgMaxSize            = local.asg_max_count
  Region                = local.region
  ImageName             = "hashicorp/tfc-agent"
  ImageVersion          = "1.15"
  env                   = "shared"
  service_name          = local.service_name
  auto_update           = "patch"
  agent_pool_org_name   = each.value
}
