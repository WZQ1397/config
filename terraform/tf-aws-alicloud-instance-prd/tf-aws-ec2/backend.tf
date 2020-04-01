terraform {
  backend "consul" {
    address = "consul.k8s-dev-local.tsjinrong.top"
    scheme  = "http"
    path    = "tf/state"
    # token   = ""
  }
}

