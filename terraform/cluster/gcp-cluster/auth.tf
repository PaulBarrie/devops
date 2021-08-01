
resource "google_service_account" "service_account" {
  account_id   = "cluster-sa"
  display_name = "A service account with cluster rights"
}


resource "google_service_account_key" "service-account-key" {
  service_account_id = google_service_account.service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}


resource "google_service_account_iam_binding" "sa-bind-iam" {
  service_account_id = "${google_service_account.service_account.name}"
  role               = "roles/iam.serviceAccountUser"

  members = [
    "user: po@example.com",
  ]

  # condition {
  #   title       = "expires_after_2019_12_31"
  #   description = "Expiring at midnight of 2019-12-31"
  #   expression  = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
  # }
}



####################################################
#   Rotate admin key 
####################################################
# note this requires the terraform to be run regularly
resource "time_rotating" "admin-key_rotation" {
  rotation_days = 30
}

resource "google_service_account_key" "admin-key" {
  service_account_id = google_service_account.service-account.name

  keepers = {
    rotation_time = time_rotating.mykey_rotation.rotation_rfc3339
  }
}

####################################################
#   Store credentials 
####################################################

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name = "google-application-credentials"
  }
  data = {
    "credentials.json" = base64decode(google_service_account_key.service-account-key.private_key)
  }
}