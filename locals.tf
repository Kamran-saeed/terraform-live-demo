locals {
  region       = "eu-west-1"
  service_name = "tfc-agent"
  env          = "demo"

  # VPC Config
  cidr            = "172.0.0.0/22"
  private_subnets = ["172.0.0.0/24", "172.0.1.0/24", "172.0.2.0/24"]
  public_subnets  = ["172.0.3.0/26", "172.0.3.64/26", "172.0.3.128/26"]
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_name        = "${local.env}-${local.service_name}-vpc"

  # VPC Endpoints Config
  vpce_sg_port_map = {
    tcp = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow traffic for vpc endpoints"
    }
  }

  # Agent Config
  agent_pool_organizations = ["EinfachCloud"]
  asg_min_count            = 1
  asg_desired_count        = 1
  asg_max_count            = 3
}
