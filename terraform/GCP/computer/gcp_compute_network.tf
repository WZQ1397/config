# This Terraform file will create the necessary Compute resources in GCP for the Kubernetes cluster

# Create VPC

resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  description             = "k8s cluster terraform"
}

# Create private subnet

resource "google_compute_subnetwork" "private_network_1" {
  name          = var.private_subnet_name
  ip_cidr_range = var.private_ip_cidr_range
  network       = google_compute_network.vpc_network.id
}

# Create firewall to allow only internal TCP, UDP, ICMP traffic

resource "google_compute_firewall" "firewall_allow_internal" {
  name    = var.firewall_allow_internal_name
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"

  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = var.firewall_allow_internal_range
}

# Create firewall to allow external TCP (SSH) (Kubernetes API port 6443) (ICMP - ping)

resource "google_compute_firewall" "firewall_allow_external" {
  name    = var.firewall_allow_external_name
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "6443"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

# Create Kubernetes Public IP Address, which will be attached to the external load balancer 
# sitting in front of the Kubernetes API servers

resource "google_compute_address" "external_ip_address" {
  name = "kubernetes-public-address"
}

# Create the external load balancer network resources

resource "google_compute_http_health_check" "http_health_check" {
  name        = "kubernetes"
  description = "Kubernetes HTTP Health check"

  port         = 80
  host         = "kubernetes.default.svc.cluster.local"
  request_path = "/healthz"
}

resource "google_compute_firewall" "firewall_health_check" {
  name          = "kubernetes-allow-health-check"
  network       = google_compute_network.vpc_network.name
  description   = "Allow TCP access to specified source ranges."
  source_ranges = var.firewall_health_check_allow_range
  allow {
    protocol = "tcp"
  }
}

resource "google_compute_target_pool" "http_target_pool" {
  name          = "kubernetes-target-pool"
  health_checks = [google_compute_http_health_check.http_health_check.name]
  #count = var.controllers

  instances = google_compute_instance.k8s_controller.*.self_link


}

#forwarding rules

resource "google_compute_forwarding_rule" "forwarding_rule" {
  name       = "kubernetes-forwarding-rule"
  target     = google_compute_target_pool.http_target_pool.id
  port_range = 6443
  region     = var.gcp_region

  ip_address = google_compute_address.external_ip_address.address
}

# route packets

resource "google_compute_route" "route" {
  count       = var.nodes
  name        = "kubernetes-route-10-200-${count.index + 1}-0-24"
  network     = google_compute_network.vpc_network.name
  next_hop_ip = "10.240.0.2${count.index + 1}"
  dest_range  = "10.200.${count.index + 1}.0/24"

  depends_on = [
    google_compute_subnetwork.private_network_1
  ]
}
#
#name         = "k8s-controller-${count.index + 1}"
