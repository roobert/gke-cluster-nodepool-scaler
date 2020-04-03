variable company_name {}
variable project_id {}
variable zone {}
variable cluster {}
variable nodepool {}
variable app_version {}
variable min_nodes {}
variable max_nodes {}

resource "google_cloudfunctions_function" "gke-cluster-nodepool-scaler" {
  name                  = "gke-cluster-nodepool-scaler"
  source_archive_bucket = google_storage_bucket.gke-cluster-nodepool-scaler.name
  source_archive_object = "app-${local.app_version}.zip"
  available_memory_mb   = 128
  timeout               = 60
  runtime               = "python37"
  entry_point           = "main"

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = "projects/${local.project_id}/topics/gke-cluster-nodepool-scaler"
  }

  environment_variables = {
    PROJECT_ID = var.project_id
    ZONE       = var.zone
    CLUSTER    = var.cluster
    NODEPOOL   = var.nodepool
  }
}

resource "google_storage_bucket" "gke-cluster-nodepool-scaler" {
  name = "${var.company_name}-gke-cluster-nodepool-scaler"
}

resource "google_pubsub_topic" "gke-cluster-nodepool-scaler" {
  name = "gke-cluster-nodepool-scaler"
}

resource "google_cloud_scheduler_job" "gke-cluster-nodepool-scaler-scale-down" {
  name     = "gke-cluster-nodepool-scaler-scale-down"
  schedule = "0 0 * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.gke-cluster-nodepool-scaler.id
    data       = base64encode(var.min_nodes)
  }
}

resource "google_cloud_scheduler_job" "gke-cluster-nodepool-scaler-scale-up" {
  name     = "gke-cluster-nodepool-scaler-scale-up"
  schedule = "0 8 * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.gke-cluster-nodepool-scaler.id
    data       = base64encode(var.max_nodes)
  }
}
