resource "aws_s3_bucket" "app_bucket" {
  bucket = "soso-storage-v2"

  tags = {
    Name = "soso-bucket"
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}
