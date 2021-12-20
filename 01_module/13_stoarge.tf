resource "aws_s3_bucket" "cada_s3" {
  bucket        = format("%s-log-bucket1230", var.name)
  acl           = "public-read-write"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.cada_s3.id

  #aws의 버킷정책 json부분
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
        "Resource" : "${aws_s3_bucket.cada_s3.arn}/*"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "delivery.logs.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.cada_s3.arn}/*",
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
        "Resource" : "${aws_s3_bucket.cada_s3.arn}"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logs.ap-northeast-2.amazonaws.com"
        },
        "Action" : "s3:GetBucketAcl",
        "Resource" : "${aws_s3_bucket.cada_s3.arn}"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "logs.ap-northeast-2.amazonaws.com"
        },
        "Action" : "s3:PutObject",
        "Resource" : "${aws_s3_bucket.cada_s3.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}



resource "aws_s3_bucket_public_access_block" "access_bucket" {
  bucket = aws_s3_bucket.cada_s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_ebs_volume" "ebs" {
  availability_zone = "${var.region.region}${var.region.az[0]}"
  size              = 20
  tags = {
    Name = "${format("%s-ebs", var.name)}"
  }
}
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs.id   #선택한 볼륨 id
  instance_id = aws_instance.bastion.id #연결할 인스턴스 ID
}

resource "aws_efs_file_system" "cd-efs" {
  creation_token = format("%s-efs1230", var.name)
  tags = {
    Name = "${format("%s-efs", var.name)}"
  }
}

resource "aws_efs_mount_target" "cd-efs-mount-target" {
  count           = "${length(var.cidr.was)}"
  file_system_id  = aws_efs_file_system.cd-efs.id
  subnet_id       = aws_subnet.was_subnet[count.index].id
  security_groups = [aws_security_group.security_efs.id]
}

resource "aws_vpc" "cd-vpc" {
  cidr_block = var.cidr.vpc
}
