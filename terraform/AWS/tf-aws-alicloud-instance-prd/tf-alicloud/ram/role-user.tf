# Create a RAM User Policy attachment.

# alicloud_ram_policy.K8S-ZACH-ADMIN:
resource "alicloud_ram_policy" "K8S-ZACH-ADMIN" {
    name             = "K8S-ZACH-ADMIN"

    statement {
        action   = [
            "cs:Get*",
        ]
        effect   = "Allow"
        resource = [
            "acs:cs:*:*:cluster/c108a4912245541fdb9dfa7fc9d2b163c",
        ]
    }
}

# alicloud_ram_policy.approval-limit:
resource "alicloud_ram_policy" "approval-limit" {
    name             = "approval-limit"

    statement {
        action   = [
            "oss:Get*",
            "oss:List*",
        ]
        effect   = "Allow"
        resource = [
            "acs:oss:*:*:suncash-prd/*",
        ]
    }
    statement {
        action   = [
            "oss:ListBuckets",
            "oss:ListObjects",
            "oss:GetBucketStat",
            "oss:GetBucketInfo",
            "oss:GetBucketAcl",
        ]
        effect   = "Allow"
        resource = [
            "acs:oss:*:*:*",
        ]
    }
}

# alicloud_ram_policy.spark-dev:
resource "alicloud_ram_policy" "spark-dev" {
    name             = "spark-dev"

    statement {
        action   = [
            "oss:Get*",
            "oss:List*",
            "oss:Delete*",
        ]
        effect   = "Allow"
        resource = [
            "acs:oss:*:*:tsjr-spark-dev/*",
            "acs:oss:*:*:sparkone-test/*",
        ]
    }
}

# alicloud_ram_policy.suncash-dev:
resource "alicloud_ram_policy" "suncash-dev" {
    name             = "suncash-dev"

    statement {
        action   = [
            "oss:*",
        ]
        effect   = "Allow"
        resource = [
            "acs:oss:*:*:suncash-dev/*",
        ]
    }
    statement {
        action   = [
            "oss:*",
        ]
        effect   = "Deny"
        resource = [
            "acs:oss:*:*:suncash-logs-backup/*",
        ]
    }
    statement {
        action   = [
            "oss:List*",
            "oss:Get*",
        ]
        effect   = "Allow"
        resource = [
            "acs:oss:*:*:suncash-prd/*",
        ]
    }
}

# alicloud_ram_user.dba:
resource "alicloud_ram_user" "dba" {
    display_name = "dba"
    name         = "dba"
}

# alicloud_ram_user.spark-dev:
resource "alicloud_ram_user" "spark-dev" {
    display_name = "spark-dev"
    name         = "spark-dev"
}

# alicloud_ram_user.suncash:
resource "alicloud_ram_user" "suncash" {
    display_name = "suncash"
    name         = "suncash"
}

# alicloud_ram_user.tsjinrong:
resource "alicloud_ram_user" "tsjinrong" {
    display_name = "tsjinrong"
    name         = "tsjinrong"
}


resource "alicloud_ram_user_policy_attachment" "spark-dev" {
  policy_name = "${alicloud_ram_policy.suncash-dev.name}"
  policy_type = "${alicloud_ram_policy.suncash-dev.type}"
  user_name = "${alicloud_ram_user.spark-dev.name}"
}
