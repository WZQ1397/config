resource "alicloud_vpc" "K8S-SG-A" {
    name = "K8S-SG-A"
    cidr_block        = "172.16.0.0/12"
}
 data "alicloud_zones" "K8S-SG-A" {
}
 resource "alicloud_vswitch" "K8S-SG-A-1" {
    vpc_id = "${alicloud_vpc.K8S-SG-A.id}"
    cidr_block        = "172.20.1.0/24"
    availability_zone = "${data.alicloud_zones.K8S-SG-A.zones.0.id}"
    name = "K8S-SG-A-1"
}

resource "alicloud_route_table" "K8S-GW-SG-A" {
    vpc_id = "${alicloud_vpc.K8S-SG-A.id}"
    name = "K8S-GW-SG-A"
    description = "K8S-GW-SG-A"
}

resource "alicloud_route_table_attachment" "K8S-SG-A-1" {
    vswitch_id = "${alicloud_vswitch.K8S-SG-A-1.id}"
    route_table_id = "${alicloud_route_table.K8S-GW-SG-A.id}"
}

# terraform import alicloud_route_entry.K8S-GW-SG-A-gre-1 vtb-t4nb7ajo6egv4n9mza64a:vrt-t4n9oaz6cofp1zz5lfvy1:172.10.0.0/16:Instance:i-t4n3hkpem5du8mcoyvdh
resource "alicloud_route_entry" "K8S-GW-SG-A-gre-1" {
    destination_cidrblock = "172.10.0.0/16"
    name                  = "GRE-AWS"
    nexthop_id            = "i-t4n3hkpem5du8mcoyvdh"
    nexthop_type          = "Instance"
    route_table_id        = "${alicloud_route_table.K8S-GW-SG-A.id}"
}

resource "alicloud_route_entry" "K8S-GW-SG-A-gre-2" {
    destination_cidrblock = "192.168.1.0/30"
    name                  = "TUN1"
    nexthop_id            = "i-t4n3hkpem5du8mcoyvdh"
    nexthop_type          = "Instance"
    route_table_id        = "${alicloud_route_table.K8S-GW-SG-A.id}"
}


# # alicloud_route_entry.K8S-GW-SG-A-gre-1:
# resource "alicloud_route_entry" "K8S-GW-SG-A-gre-1" {
#     destination_cidrblock = "172.10.0.0/16"
#     id                    = "vtb-t4nb7ajo6egv4n9mza64a:vrt-t4n9oaz6cofp1zz5lfvy1:172.10.0.0/16:Instance:i-t4n3hkpem5du8mcoyvdh"
#     name                  = "GRE-AWS"
#     nexthop_id            = "i-t4n3hkpem5du8mcoyvdh"
#     nexthop_type          = "Instance"
#     route_table_id        = "vtb-t4nb7ajo6egv4n9mza64a"
#     router_id             = "vrt-t4n9oaz6cofp1zz5lfvy1"
# }

# # alicloud_route_entry.K8S-GW-SG-A-gre-2:
# resource "alicloud_route_entry" "K8S-GW-SG-A-gre-2" {
#     destination_cidrblock = "192.168.1.0/30"
#     id                    = "vtb-t4nb7ajo6egv4n9mza64a:vrt-t4n9oaz6cofp1zz5lfvy1:192.168.1.0/30:Instance:i-t4n3hkpem5du8mcoyvdh"
#     name                  = "TUN1"
#     nexthop_id            = "i-t4n3hkpem5du8mcoyvdh"
#     nexthop_type          = "Instance"
#     route_table_id        = "vtb-t4nb7ajo6egv4n9mza64a"
#     router_id             = "vrt-t4n9oaz6cofp1zz5lfvy1"
# }

# # alicloud_route_table.K8S-GW-SG-A:
# resource "alicloud_route_table" "K8S-GW-SG-A" {
#     id     = "vtb-t4nb7ajo6egv4n9mza64a"
#     name   = "K8S-GW-SG-A"
#     tags   = {}
#     vpc_id = "vpc-t4nvbeirlln3syma1ujqw"
# }

# # alicloud_route_table_attachment.K8S-SG-A-1:
# resource "alicloud_route_table_attachment" "K8S-SG-A-1" {
#     id             = "vtb-t4nb7ajo6egv4n9mza64a:vsw-t4nswo1upj9iziyqjenb0"
#     route_table_id = "vtb-t4nb7ajo6egv4n9mza64a"
#     vswitch_id     = "vsw-t4nswo1upj9iziyqjenb0"
# }

# # alicloud_vpc.K8S-SG-A:
# resource "alicloud_vpc" "K8S-SG-A" {
#     cidr_block        = "172.16.0.0/12"
#     id                = "vpc-t4nvbeirlln3syma1ujqw"
#     name              = "K8S-SG-A"
#     resource_group_id = "rg-acfmw5q2ib7atyy"
#     route_table_id    = "vtb-t4nb7ajo6egv4n9mza64a"
#     router_id         = "vrt-t4n9oaz6cofp1zz5lfvy1"
#     router_table_id   = "vtb-t4nb7ajo6egv4n9mza64a"
#     tags              = {}
# }

# # alicloud_vswitch.K8S-SG-A-1:
# resource "alicloud_vswitch" "K8S-SG-A-1" {
#     availability_zone = "ap-southeast-1a"
#     cidr_block        = "172.20.1.0/24"
#     description       = "K8S-SG-A-1"
#     id                = "vsw-t4nswo1upj9iziyqjenb0"
#     name              = "K8S-SG-A-1"
#     tags              = {}
#     vpc_id            = "vpc-t4nvbeirlln3syma1ujqw"
# }
