resource "aws_s3_bucket" "cd_log_bucket" {
  bucket        = "cd-log-bucket1230"
  acl           = "public-read-write"
  force_destroy = true

  /*    lifecycle_rule {
        id      = "log"
        enabled = true
        
        prefix = "${aws_s3_bucket.cd_log_bucket.arn}/*"
        
        tags = {
            rule      = "log"
            autoclean = "true"
        }
        transition {
            days          = 30
            storage_class = "STANDARD_IA" # or "ONEZONE_IA"
        } */
}

resource "aws_s3_bucket_policy" "cd_s3_policy" {
  bucket = aws_s3_bucket.cd_log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::600734575887:root"
        },
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.cd_log_bucket.arn}/*"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.cd_log_bucket.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:GetBucketAcl",
        "Resource" : "${aws_s3_bucket.cd_log_bucket.arn}"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logs.ap-northeast-2.amazonaws.com"
        },
        "Action" : "s3:GetBucketAcl",
        "Resource" : "${aws_s3_bucket.cd_log_bucket.arn}"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logs.ap-northeast-2.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.cd_log_bucket.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}
resource "aws_s3_bucket_public_access_block" "cd_access_bucket" {
  bucket = aws_s3_bucket.cd_log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_ebs_volume" "cd_ebs" {
  availability_zone = "ap-northeast-2a"
  size              = 20

  tags = {
    Name = "cd-ebs"
  }
}

resource "aws_volume_attachment" "cd_ebs_att" {
  device_name  = "/dev/sdh"
  volume_id    = aws_ebs_volume.cd_ebs.id
  instance_id  = aws_instance.cd_bastion.id
  force_detach = true
  skip_destroy = true
}

resource "aws_efs_file_system" "cd_efs" {
  creation_token = "cd-efs"

  tags = {
    Name = "cd-efs"
  }
}
resource "aws_efs_mount_target" "cd_efs_mount1" {
  #count = "${length(var.was_cidr)}"
  file_system_id  = aws_efs_file_system.cd_efs.id
  subnet_id       = aws_subnet.cd_priwas1.id
  security_groups = [aws_security_group.sg_efs.id]
}

resource "aws_efs_mount_target" "cd_efs_mount2" {
  #count = "${length(var.was_cidr)}"
  file_system_id  = aws_efs_file_system.cd_efs.id
  subnet_id       = aws_subnet.cd_priwas2.id
  security_groups = [aws_security_group.sg_efs.id]
}
