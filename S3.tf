# Genereer een random ID om unieke bucketnamen te garanderen
resource "random_id" "bucket_id" {
  byte_length = 4
}
#  Week 4 - 4.2: S3 Buckets aanmaken
resource "aws_s3_bucket" "saxit_openbaar" {
  bucket        = "saxit-openbaar-gio-${random_id.bucket_id.hex}"
  force_destroy = true
}

resource "aws_s3_bucket" "saxit_intern" {
  bucket        = "saxit-intern-gio-${random_id.bucket_id.hex}"
  force_destroy = true
}

resource "aws_s3_bucket" "saxit_geheim" {
  bucket        = "saxit-geheim-gio-${random_id.bucket_id.hex}"
  force_destroy = true
}

#  Week 4 - 4.2: Bucket policy voor Openbaar
resource "aws_s3_bucket_policy" "policy_openbaar" {
  bucket = aws_s3_bucket.saxit_openbaar.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "RequireEncryptionAndTag"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.saxit_openbaar.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:RequestObjectTag/classificatie" = "openbaar"
          }
        }
      }
    ]
  })
}
#  Week 4 - 4.2: Bucket policy voor Intern
resource "aws_s3_bucket_policy" "policy_intern" {
  bucket = aws_s3_bucket.saxit_intern.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "RequireEncryptionAndTag"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.saxit_intern.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:RequestObjectTag/classificatie" = "intern"
          }
        }
      }
    ]
  })
}

#  Week 4 - 4.2: Bucket policy voor Geheim
resource "aws_s3_bucket_policy" "policy_geheim" {
  bucket = aws_s3_bucket.saxit_geheim.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "RequireEncryptionAndTag"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.saxit_geheim.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:RequestObjectTag/classificatie" = "geheim"
          }
        }
      }
    ]
  })
}
