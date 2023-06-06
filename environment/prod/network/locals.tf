locals {
  public_subnets = {
    public_subnet1 = {
      cidr_block = cidrsubnet(var.prod_cidr, 8, 1)
    }
  }
}

locals {
  private_subnets = {
    private_subnet1 = {
      cidr_block = cidrsubnet(var.prod_cidr, 8, 2)
    },  
    private_subnet2 = {
      cidr_block = cidrsubnet(var.prod_cidr, 8, 3)
    },
    private_subnet3 = {
      cidr_block = cidrsubnet(var.prod_cidr, 8, 4)
    },
    private_subnet4 = {
      cidr_block = cidrsubnet(var.prod_cidr, 8, 5)
    }
  }
}