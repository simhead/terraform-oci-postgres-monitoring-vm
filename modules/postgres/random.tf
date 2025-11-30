resource "random_string" "state_id" {
  length  = 6
  lower   = true
  numeric = false
  special = false
  upper   = false
}


resource "random_string" "argocd" {
  length  = 10
  lower   = true
  numeric = true
  special = true
  upper   = true
}