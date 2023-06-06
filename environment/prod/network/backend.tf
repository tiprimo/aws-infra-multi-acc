terraform {
  backend "s3" {
    bucket = "primo-tf-state-prod"
    key    = "network.tfstate"
    region = "us-east-1"
  }
}