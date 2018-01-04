#' @title Google BigQuery Default Settings
#' @description Sets default values for several Google BigQuery related settings.
#' @param billingProjectId Default Google Cloud Platform project ID for billing purposes.
#' This is the project on whose behalf to perform BigQuery operations.
#' @param gcsBucket Default Google Cloud Storage bucket used for temporary BigQuery files.
#' This should be the name of an existing storage bucket.
#' @param datasetLocation Default Google BigQuery dataset location ("EU" or "US").
#' @return A \code{list} of set options with previous values.
#' @seealso \code{\link{spark_read_bigquery}}, \code{\link{spark_write_bigquery}},
#' \code{\link{default_billing_project_id}}, \code{\link{default_gcs_bucket}},
#' \code{\link{default_dataset_location}}
#' @keywords database, connection
#' @export
bigquery_defaults <- function(billingProjectId, gcsBucket, datasetLocation) {
  options(
    "sparkbq.default.billingProjectId" = billingProjectId,
    "sparkbq.default.gcsBucket" = gcsBucket,
    "sparkbq.default.datasetLocation" = datasetLocation
  )
}

#' @title Default Google BigQuery Billing Project ID
#' @description Returns the default Google BigQuery billing project ID.
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_billing_project_id <- function() {
  getOption("sparkbq.default.billingProjectId", default = NULL)
}

#' @title Default Google BigQuery GCS Bucket
#' @description Returns the default Google BigQuery GCS bucket.
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_gcs_bucket <- function() {
  getOption("sparkbq.default.gcsBucket", default = NULL)
}

#' @title Default Google BigQuery Dataset Location
#' @description Returns the default Google BigQuery dataset location.
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_dataset_location <- function() {
  getOption("sparkbq.default.datasetLocation", default = NULL)
}
