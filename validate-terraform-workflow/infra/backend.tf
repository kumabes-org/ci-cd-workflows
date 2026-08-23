terraform {
  backend "s3" {
    bucket  = "976193236739-statefile"
    key     = "us-east-1/dev/1341183187"
    region  = "us-east-1"
    encrypt = true
  }
}