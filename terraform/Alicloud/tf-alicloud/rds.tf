# alicloud_db_instance.suncash-prd:
resource "alicloud_db_instance" "suncash-prd" {
    auto_renew                 = false
    auto_upgrade_minor_version = "Manual"
    engine                     = "MySQL"
    engine_version             = "5.6"
    instance_charge_type       = "Prepaid"
    instance_name              = "suncash-prd"
    instance_storage           = 100
    instance_type              = "rds.mysql.t1.small"
    maintain_time              = "18:00Z-22:00Z"
    monitoring_period          = 60
    security_group_id          = "sg-t4nhofwrn4neckmfouze"
    security_ip_mode           = "safety"
    security_ips               = [
        "100.104.160.192/26",
        "100.104.164.0/24",
        "100.104.194.128/26",
        "100.104.205.0/24",
        "100.104.244.192/26",
        "100.104.89.64/26",
        "11.193.225.5",
        "11.193.98.180",
        "127.0.0.1",
        "172.20.1.0/24",
        "222.66.149.30/32",
        "52.80.168.2/28",
        "54.223.113.178",
    ]
    tags                       = {
        "prd" = "生产库"
    }
    vswitch_id                 = "vsw-t4nswo1upj9iziyqjenb0"
    zone_id                    = "ap-southeast-1a"

    timeouts {}
}

resource "alicloud_vpc" "default" {
    name       = "vpc-123456"
    cidr_block = "172.16.0.0/16"
}

resource "alicloud_db_readonly_instance" "suncash-prd-ro" {
    master_db_instance_id = "${alicloud_db_instance.suncash-prd.id}"
    engine_version = "${alicloud_db_instance.suncash-prd.engine_version}"
    instance_type = "${alicloud_db_instance.suncash-prd.instance_type}"
    instance_name         = "suncash-read"
    instance_storage      = 100
    vswitch_id            = "vsw-t4nswo1upj9iziyqjenb0"
    zone_id               = "ap-southeast-1a"
    timeouts {}
    # parameters = [{
    #     name = "innodb_large_prefix"
    #     value = "ON"
    # },{
    #     name = "connect_timeout"
    #     value = "50"
    # }]
}
