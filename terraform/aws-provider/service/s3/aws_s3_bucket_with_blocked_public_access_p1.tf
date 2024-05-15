# Create an S3 bucket named 'example' with public access blocked via the 'aws' provider

resource "aws_s3_bucket" "example" {
  bucket = "example"

}

# (Recommended) Enforce restrctions on public access for the bucket
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
