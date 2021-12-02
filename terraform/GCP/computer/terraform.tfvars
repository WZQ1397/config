gcp_project_id                = ""
gcp_region                    = "us-central1"
gcp_zone                      = "us-central1-a"
vpc_name                      = "kubernetes-thw"
private_subnet_name           = "kubernetes-subnet"
private_ip_cidr_range         = "10.240.0.0/24"
private_ip_pod_cidr_range     = "10.200.$worker.0/24"
firewall_allow_internal_name  = "firewall-allow-internal"
firewall_allow_internal_range = ["10.240.0.0/24", "10.200.0.0/16"]
firewall_allow_external_name  = "firewall-allow-external"
gcp_credential                = "<path to json>"
gce_machine_type              = "e2-standard-2"
gce_disk_image                = "ubuntu-os-cloud/ubuntu-1604-xenial-v20210429"
gce_ssh_key                   = "<path to ssh public key>"
gce_ssh_key_username          = "<ssh username>"

gce_disk_size = 100

# kubernetes instance group sizes add to scale up, or remove to scale down
nodes       = 3
controllers = 3

# http health vars static addresses
firewall_health_check_allow_range = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]

