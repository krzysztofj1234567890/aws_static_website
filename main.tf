# create S3 bucket
resource "aws_s3_bucket" "tf_bucket" {
    bucket = var.bucket_name
}

# bucket ownership
resource "aws_s3_bucket_ownership_controls" "tf_bucket" {
    bucket = aws_s3_bucket.tf_bucket.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_policy" "public_access_policy" {
    bucket = aws_s3_bucket.tf_bucket.id
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            { 
                Sid         = "PublicReadGetObject",
                Effect      = "Allow",
                Principal   = "*",
                Action      = "s3:GetObject",
                Resource    = "${aws_s3_bucket.tf_bucket.arn}/*"
            }
        ]
    })
}

# open public access
resource "aws_s3_bucket_public_access_block" "tf_bucket" {
    bucket = aws_s3_bucket.tf_bucket.id
    block_public_acls   = false
    block_public_policy = false
    ignore_public_acls  = false
    restrict_public_buckets = false
}

# bucket acl
resource "aws_s3_bucket_acl" "tf_bucket" {
    depends_on = [
        aws_s3_bucket_ownership_controls.tf_bucket,
        aws_s3_bucket_public_access_block.tf_bucket,
    ]
    bucket  = aws_s3_bucket.tf_bucket.id
    acl     = "public-read"
}

# bucket website configuration
#resource "aws_s3_bucket_website_configuration" "tf_bucket" {
#    bucket  = aws_s3_bucket.tf_bucket.id
#    index_document {
#        suffix = "index.html"
#    }
#}

# upload index.html
#resource "aws_s3_object" "file" {
#    bucket  = aws_s3_bucket.tf_bucket.id
#    key     = "index.html"
#    source  = "index.html"
#    acl     = "public-read"
#    content_type    = "text/html"
#}