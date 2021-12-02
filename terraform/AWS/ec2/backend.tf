terraform {
  backend "consul" {
    address = "172.10.101.10:8500"
    scheme  = "http"
    path    = "tf/state"
  }
}

