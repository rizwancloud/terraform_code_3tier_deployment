terraform {
  backend "s3" {
    bucket = "terraform-state-bucket333"
    key    = "myapp/terraform.tfstate"
    region = "ap-south-1"
  }
}