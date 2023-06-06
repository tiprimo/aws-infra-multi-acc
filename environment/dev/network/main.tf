module "vpc-main-prod" {
  source          = "../../../modules/vpc"
  vpc_cidr        = var.dev_cidr
  vpc_name        = var.vpc_name
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
  ram_name = "shared_vpc_prod"
  account_ids         = ["213224418008", "108507110104", "512928546505"]
  tags = {
    Name        = "vpc-main-prod"
    Environment = "prod"
  }
}