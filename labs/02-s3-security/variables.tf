variable "aws_region" {
  description = "Region where the bucket is created (same as your Udemy lab account)."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique bucket name (course pattern: alias-account-id-region)."
  type        = string
}

variable "coffee_image_path" {
  description = "Local path to coffee.jpg from the course materials."
  type        = string
  default     = "../../MLA-C02-Materials/s3/coffee.jpg"
}

variable "beach_image_path" {
  description = "Local path to beach.jpg from the course materials."
  type        = string
  default     = "../../MLA-C02-Materials/s3/beach.jpg"
}
