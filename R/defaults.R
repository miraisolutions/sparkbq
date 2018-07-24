#' @title Google BigQuery Default Settings
#' @description Sets default values for several Google BigQuery related settings.
#' @param billingProjectId Default Google Cloud Platform project ID for billing purposes.
#' This is the project on whose behalf to perform BigQuery operations.
#' @param gcsBucket Default Google Cloud Storage bucket used for temporary BigQuery files.
#' This should be the name of an existing storage bucket.
#' @param datasetLocation Default Google BigQuery dataset location ("EU" or "US").
#' @param type Default BigQuery import/export type to use. Options include "direct",
#' "parquet", "avro", "orc", "json" and "csv". If not set, it defaults to
#' \code{NULL}, meaning that the default spark-bigquery import/export mechanism
#' will be used (i.e. "direct"). Please note that only "direct" and "avro"
#' are supported for both importing and exporting.
#' See the table below for supported type and import/export combinations.
#' 
#' \tabular{lcccccc}{
#'                                          \tab Direct \tab Parquet \tab Avro \tab ORC \tab JSON \tab CSV  \cr
#'   Import to Spark (export from BigQuery) \tab X      \tab         \tab X    \tab     \tab X    \tab X    \cr
#'   Export from Spark (import to BigQuery) \tab X      \tab X       \tab X    \tab X   \tab      \tab      \cr
#' }
#' @return A \code{list} of set options with previous values.
#' @seealso \code{\link{spark_read_bigquery}}, \code{\link{spark_write_bigquery}},
#' \code{\link{default_billing_project_id}}, \code{\link{default_gcs_bucket}},
#' \code{\link{default_dataset_location}}
#' @keywords database, connection
#' @export
bigquery_defaults <- function(billingProjectId, gcsBucket, datasetLocation, type = NULL) {
  options(
    "sparkbq.default.billingProjectId" = billingProjectId,
    "sparkbq.default.gcsBucket" = gcsBucket,
    "sparkbq.default.datasetLocation" = datasetLocation,
    "sparkbq.default.bigquery.type" = type
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

#' @title Default BigQuery import/export type
#' @description Returns the default BigQuery import/export type. It defaults to
#' "direct".
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_bigquery_type <- function() {
  getOption("sparkbq.default.bigquery.type", default = "direct")
}
