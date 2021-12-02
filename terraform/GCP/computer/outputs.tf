
output "controller-ext-ip" {
  description = "Output Controller: External IP Addresses"
  value       = google_compute_instance.k8s_controller[*].network_interface[0].access_config[0].nat_ip
}


output "controller-int-ip" {
  description = "Output Controller: Internal IP Addresses"
  value       = google_compute_instance.k8s_controller[*].network_interface[0].network_ip
}

output "worker-node-ext-ip" {
  description = "Output Worker Node: External IP Addresses"
  value       = google_compute_instance.k8s_node[*].network_interface[0].access_config[0].nat_ip
}

output "worker-node-int-ip" {
  description = "Output Worker Node: Internal IP Addresses"
  value       = google_compute_instance.k8s_node[*].network_interface[0].network_ip
}

output "kubernetes-external-ip" {
  description = "Output Kubernetes public IP-Address"
  value       = google_compute_address.external_ip_address.address
}

