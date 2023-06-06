terraform {
  backend "s3" {
    bucket = "primo-tf-state-dev"
    key    = "network.tfstate"
    region = "us-east-1"
  }
}