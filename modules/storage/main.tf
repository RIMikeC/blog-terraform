resource "aws_s3_bucket" "bucket" {
  bucket = "nomoreservers"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
