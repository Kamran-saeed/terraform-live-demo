provider "aws" {
  region = local.region
}

provider "tfe" {
  hostname = "app.terraform.io"
}
