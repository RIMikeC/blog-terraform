output "bucket_id" {
  value       = "${aws_s3_bucket.bucket.id}"
  description = "Name of the bucket"
}

output "bucket_arn" {
  value       = "${aws_s3_bucket.bucket.arn}"
  description = "ARN of the bucket"
}

output "bucket_url" {
  value       = "${aws_s3_bucket.bucket.website_endpoint}"
  description = "bucket URL"
}
