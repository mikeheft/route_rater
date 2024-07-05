terraform {
  backend "s3" {
    bucket  = "hop-skip-drive"
    key     = "terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
}
