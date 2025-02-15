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
# VPC Endpoints
# ========================================= #
module "vpc_endpoints" {
  source = "github.com/Kamran-saeed/terraform-aws-vpc-endp"

  service_name        = local.service_name
  env                 = local.env
  region              = local.region
  vpc_id              = module.vpc.id
  vpc_cidr            = module.vpc.cidr
  private_rt_ids      = module.vpc.private_rt_ids
  endpoint_subnet_ids = module.vpc.private_subnets
  sg_port_map         = local.vpce_sg_port_map
}

# ========================================= #
# TFC Agent
# ========================================= #
module "tfc-agents" {
  source = "github.com/Kamran-saeed/terraform-aws-tfc-setup//modules/tfc-agent"

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
  env                   = local.env
  service_name          = local.service_name
  auto_update           = "patch"
  agent_pool_org_name   = each.value
}

# ========================================= #
# AWS IAM OIDC Provider
# ========================================= #
module "oidc-provider" {
  source = "github.com/Kamran-saeed/terraform-aws-tfc-setup//modules/oidc-provider"

  oidc_provider_url           = "https://app.terraform.io"
  tfc_oidc_provider_audiences = ["aws.workload.identity"]
}
