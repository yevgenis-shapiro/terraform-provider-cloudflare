terraform {
  backend "s3" {
    bucket = "cloudflare-solutions-tfstate"
    key    = "terraform/cloudflare.tfstate"
    region = "ap-southeast-2"
  }
}
