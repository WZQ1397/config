# alicloud_oss_bucket.spark99-prd:
resource "alicloud_oss_bucket" "spark99-prd" {
    acl               = "private"
    bucket            = "spark99-prd"
    policy            = jsonencode(
        {
            Statement = [
                {
                    Action    = [
                        "oss:GetObject",
                        "oss:PutObject",
                        "oss:GetObjectAcl",
                        "oss:PutObjectAcl",
                        "oss:ListObjects",
                        "oss:AbortMultipartUpload",
                        "oss:ListParts",
                        "oss:RestoreObject",
                        "oss:GetVodPlaylist",
                        "oss:PostVodPlaylist",
                        "oss:PublishRtmpStream",
                    ]
                    Effect    = "Allow"
                    Principal = [
                        "283925959209709833",
                    ]
                    Resource  = [
                        "acs:oss:*:1217252629547491:spark99-prd/*",
                    ]
                },
                {
                    Action    = [
                        "oss:ListObjects",
                    ]
                    Condition = {
                        StringLike = {
                        }
                    }
                    Effect    = "Allow"
                    Principal = [
                        "283925959209709833",
                    ]
                    Resource  = [
                        "acs:oss:*:1217252629547491:spark99-prd",
                    ]
                },
            ]
            Version   = "1"
        }
    )
    storage_class     = "Standard"
    tags              = {}
}
# alicloud_oss_bucket.tsjr-spark-dev:
resource "alicloud_oss_bucket" "tsjr-spark-dev" {
    acl               = "private"
    bucket            = "tsjr-spark-dev"
    storage_class     = "Standard"
    tags              = {}
}

# alicloud_oss_bucket.tsjr-spark-prd:
resource "alicloud_oss_bucket" "tsjr-spark-prd" {
    acl               = "private"
    bucket            = "tsjr-spark-prd"
    storage_class     = "Standard"
    tags              = {}
}
