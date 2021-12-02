# Creates the Kubernetes Controller and Worker nodes

# Controllers instance

resource "google_compute_instance" "k8s_controller" {

  count = var.controllers

  name         = "controller-${count.index + 1}"
  machine_type = var.gce_machine_type
  boot_disk {
    initialize_params {
      image = var.gce_disk_image
      size  = var.gce_disk_size
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      network_tier = "STANDARD"
    }
    # tag = format("mystring%02d%s", (count.index)

    network_ip = cidrhost(var.private_ip_cidr_range, format("1%d", (count.index + 1)))
    subnetwork = google_compute_subnetwork.private_network_1.name
  }

  metadata = {
    "ssh-keys"     = "${var.gce_ssh_key_username}:${file(var.gce_ssh_key)}"
    enable-oslogin = "FALSE"
  }

  can_ip_forward = true

  service_account {
    scopes = [
      "compute-rw",
      "storage-ro",
      "service-management",
      "service-control",
      "logging-write",
      "monitoring"
    ]
  }

  tags = [
    var.vpc_name,
    "controller"
  ]
}

# Node workers

resource "google_compute_instance" "k8s_node" {

  count = var.nodes

  name         = "worker-${count.index + 1}"
  machine_type = var.gce_machine_type
  boot_disk {
    initialize_params {
      image = var.gce_disk_image
      size  = var.gce_disk_size
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      network_tier = "STANDARD"
    }
    # tag = format("mystring%02d%s", (count.index)

    network_ip = cidrhost(var.private_ip_cidr_range, format("2%d", (count.index + 1)))
    subnetwork = google_compute_subnetwork.private_network_1.name
  }

  metadata = {
    "ssh-keys"     = "${var.gce_ssh_key_username}:${file(var.gce_ssh_key)}"
    enable-oslogin = "FALSE"
    pod-cidr       = replace(var.private_ip_pod_cidr_range, "$worker", count.index + 1)
  }

  can_ip_forward = true

  service_account {
    scopes = [
      "compute-rw",
      "storage-ro",
      "service-management",
      "service-control",
      "logging-write",
      "monitoring"
    ]
  }

  tags = [
    var.vpc_name,
    "worker"
  ]
  
  depends_on = [
    google_compute_subnetwork.private_network_1
  ]
}

