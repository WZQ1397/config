storage "consul" {
  address = "172.16.48.104:8500"
  path    = "vault/"
}
#storage "file" {
#  path = "/mnt/vault/data"
#}
ui = true
disable_mlock  = true
listener "tcp" {
 address     = "0.0.0.0:8200"
 tls_disable = 1
}
