terraform {
  backend "s3" {
    bucket         = "ecommerce-terraform-state-1908"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
