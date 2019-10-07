resource "google_storage_bucket" "example-bucket" {
  name     = "${var.bucket_name}"
  location = "US"

}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket   = "${var.bucket_name}"
  role     = "roles/storage.admin"

  members = [
     "serviceAccount:${google_service_account.bastion_account_sa.email}"
  ]


  depends_on = ["google_storage_bucket.example-bucket"]
}
