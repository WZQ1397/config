terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "3.86.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region =  var.gcp_region
  zone = var.gcp_zone
  credentials = chomp(file(var.gcp_credential))

}