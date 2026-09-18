output "bucket_name" {
  value = aws_s3_bucket.lab.id
}

output "coffee_s3_uri" {
  value = "s3://${aws_s3_bucket.lab.id}/${aws_s3_object.coffee.key}"
}

output "beach_s3_uri" {
  value = "s3://${aws_s3_bucket.lab.id}/${aws_s3_object.beach.key}"
}

output "coffee_object_url" {
  description = "Often returns 403 in browser unless the object is public; use console preview or aws s3 cp."
  value       = "https://${aws_s3_bucket.lab.bucket_regional_domain_name}/${aws_s3_object.coffee.key}"
}
