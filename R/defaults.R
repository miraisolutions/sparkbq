#' @title Google BigQuery Default Settings
#' @description Sets default values for several Google BigQuery related settings.
#' @param billingProjectId Default Google Cloud Platform project ID for billing purposes.
#' This is the project on whose behalf to perform BigQuery operations.
#' @param gcsBucket Google Cloud Storage (GCS) bucket to use for storing temporary files.
#' Temporary files are used when importing through BigQuery load jobs and exporting through
#' BigQuery extraction jobs (i.e. when using data extracts such as Parquet, Avro, ORC, ...).
#' The service account specified in \code{serviceAccountKeyFile} needs to be given appropriate
#' rights. This should be the name of an existing storage bucket.
#' @param datasetLocation Geographic location where newly created datasets should reside.
#' "EU" or "US". Defaults to "US".
#' @param serviceAccountKeyFile Google Cloud service account key file to use for authentication
#' with Google Cloud services. The use of service accounts is highly recommended. Specifically,
#' the service account will be used to interact with BigQuery and Google Cloud Storage (GCS).
#' If not specified, Google application default credentials (ADC) will be used, which is the default.
#' @param type Default BigQuery import/export type to use. Options include "direct",
#' "parquet", "avro", "orc", "json" and "csv". Defaults to "direct".
#' Please note that only "direct" and "avro" are supported for both importing and exporting. \cr
#' "csv" and "json" are not recommended due to their lack of type safety.
#' 
#' See the table below for supported type and import/export combinations.
#' 
#' \tabular{lcccccc}{
#'                                          \tab Direct \tab Parquet \tab Avro \tab ORC \tab JSON \tab CSV  \cr
#'   Import to Spark (export from BigQuery) \tab X      \tab         \tab X    \tab     \tab X    \tab X    \cr
#'   Export from Spark (import to BigQuery) \tab X      \tab X       \tab X    \tab X   \tab      \tab      \cr
#' }
#' @return A \code{list} of set options with previous values.
#' @references
#' \url{https://github.com/miraisolutions/spark-bigquery}
#' \url{https://cloud.google.com/bigquery/pricing}
#' \url{https://cloud.google.com/bigquery/docs/dataset-locations}
#' \url{https://cloud.google.com/bigquery/docs/authentication/service-account-file}
#' \url{https://cloud.google.com/docs/authentication/}
#' \url{https://cloud.google.com/bigquery/docs/authentication/}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-parquet}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-avro}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-orc}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-json}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-csv}
#' @seealso \code{\link{spark_read_bigquery}}, \code{\link{spark_write_bigquery}},
#' \code{\link{default_billing_project_id}}, \code{\link{default_gcs_bucket}},
#' \code{\link{default_dataset_location}}
#' @keywords database, connection
#' @export
bigquery_defaults <- function(billingProjectId, gcsBucket, datasetLocation = "US",
                              serviceAccountKeyFile = NULL, type = "direct") {
  options(
    "sparkbq.default.billingProjectId" = billingProjectId,
    "sparkbq.default.gcsBucket" = gcsBucket,
    "sparkbq.default.datasetLocation" = datasetLocation,
    "sparkbq.default.serviceAccountKeyFile" = serviceAccountKeyFile,
    "sparkbq.default.bigquery.type" = type
  )
}

#' @title Default Google BigQuery Billing Project ID
#' @description Returns the default Google BigQuery billing project ID.
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_billing_project_id <- function() {
  getOption("sparkbq.default.billingProjectId")
}

#' @title Default Google BigQuery GCS Bucket
#' @description Returns the default Google BigQuery GCS bucket.
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_gcs_bucket <- function() {
  getOption("sparkbq.default.gcsBucket")
}

#' @title Default Google BigQuery Dataset Location
#' @description Returns the default Google BigQuery dataset location. It defaults
#' to "US".
#' @references
#' \url{https://cloud.google.com/bigquery/docs/dataset-locations}
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_dataset_location <- function() {
  getOption("sparkbq.default.datasetLocation", default = "US")
}

#' @title Default Google BigQuery Service Account Key File
#' @description Returns the default service account key file to use.
#' @references
#' \url{https://cloud.google.com/bigquery/docs/authentication/service-account-file}
#' \url{https://cloud.google.com/docs/authentication/}
#' \url{https://cloud.google.com/bigquery/docs/authentication/}
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_service_account_key_file <- function() {
  getOption("sparkbq.default.serviceAccountKeyFile")
}

#' @title Default BigQuery import/export type
#' @description Returns the default BigQuery import/export type. It defaults to
#' "direct".
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_bigquery_type <- function() {
  getOption("sparkbq.default.bigquery.type", default = "direct")
}
