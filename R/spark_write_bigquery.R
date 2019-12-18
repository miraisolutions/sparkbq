#' @title Writing data to Google BigQuery
#' @description This function writes data to a Google BigQuery table.
#' @param data Spark DataFrame to write to Google BigQuery.
#' @param billingProjectId Google Cloud Platform project ID for billing purposes.
#' This is the project on whose behalf to perform BigQuery operations.
#' Defaults to \code{default_billing_project_id()}.
#' @param projectId Google Cloud Platform project ID of BigQuery dataset.
#' Defaults to \code{billingProjectId}.
#' @param datasetId Google BigQuery dataset ID (may contain letters, numbers and underscores).
#' @param tableId Google BigQuery table ID (may contain letters, numbers and underscores).
#' @param type BigQuery export type to use. Options include "direct", "parquet",
#' "avro", "orc". Defaults to \code{default_bigquery_type()}.
#' See \link{bigquery_defaults} for more details about the supported types.
#' @param gcsBucket Google Cloud Storage (GCS) bucket to use for storing temporary files.
#' Temporary files are used when importing through BigQuery load jobs and exporting through
#' BigQuery extraction jobs (i.e. when using data extracts such as Parquet, Avro, ORC, ...).
#' The service account specified in \code{serviceAccountKeyFile} needs to be given appropriate
#' rights. This should be the name of an existing storage bucket.
#' @param datasetLocation Geographic location where newly created datasets should reside.
#' "EU" or "US". Defaults to "US". Only needs to be specified if the dataset does not yet exist.
#' It is ignored if it is specified and the dataset already exists.
#' @param serviceAccountKeyFile Google Cloud service account key file to use for authentication
#' with Google Cloud services. The use of service accounts is highly recommended. Specifically,
#' the service account will be used to interact with BigQuery and Google Cloud Storage (GCS).
#' @param additionalParameters Additional spark-bigquery options. See
#' \url{https://github.com/miraisolutions/spark-bigquery} for more information.
#' @param mode Specifies the behavior when data or table already exist. One of "overwrite",
#' "append", "ignore" or "error" (default).
#' @param ... Additional arguments passed to \code{\link[sparklyr]{spark_write_source}}.
#' @return \code{NULL}. This is a side-effecting function.
#' @references
#' \url{https://github.com/miraisolutions/spark-bigquery}
#' \url{https://cloud.google.com/bigquery/docs/datasets}
#' \url{https://cloud.google.com/bigquery/docs/tables}
#' \url{https://cloud.google.com/bigquery/docs/reference/standard-sql/}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-parquet}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-avro}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-orc}
#' \url{https://cloud.google.com/bigquery/pricing}
#' \url{https://cloud.google.com/bigquery/docs/dataset-locations}
#' \url{https://cloud.google.com/docs/authentication/}
#' \url{https://cloud.google.com/bigquery/docs/authentication/}
#' @family Spark serialization routines
#' @seealso \code{\link[sparklyr]{spark_write_source}}, \code{\link{spark_read_bigquery}},
#' \code{\link{bigquery_defaults}}
#' @keywords database connection
#' @examples
#' \dontrun{
#' config <- spark_config()
#' 
#' sc <- spark_connect(master = "local", config = config)
#' 
#' bigquery_defaults(
#'   billingProjectId = "<your_billing_project_id>",
#'   gcsBucket = "<your_gcs_bucket>",
#'   datasetLocation = "US",
#'   serviceAccountKeyFile = "<your_service_account_key_file>",
#'   type = "direct")
#' 
#' # Copy mtcars to Spark
#' spark_mtcars <- dplyr::copy_to(sc, mtcars, "spark_mtcars", overwrite = TRUE)
#' 
#' spark_write_bigquery(
#'   data = spark_mtcars,
#'   datasetId = "<your_dataset_id>",
#'   tableId = "mtcars",
#'   mode = "overwrite")
#' }
#' @importFrom sparklyr spark_write_source
#' @export
spark_write_bigquery <- function(data, billingProjectId = default_billing_project_id(),
                                 projectId = billingProjectId, datasetId, tableId,
                                 type = default_bigquery_type(), gcsBucket = default_gcs_bucket(),
                                 datasetLocation = default_dataset_location(),
                                 serviceAccountKeyFile = default_service_account_key_file(),
                                 additionalParameters = NULL, mode = "error", ...) {

  if(!(type %in% c("direct", "parquet", "avro", "orc")))
    stop(sprintf("The export type '%s' is not supported by spark_write_bigquery", type))

  parameters <- c(list(
    "bq.project" = billingProjectId,
    "bq.staging_dataset.gcs_bucket" = gcsBucket,
    "bq.location" = datasetLocation,
    "bq.service_account_key_file" = serviceAccountKeyFile,
    "table" = sprintf("%s.%s.%s", projectId, datasetId, tableId),
    "type" = type
  ), additionalParameters)

  spark_write_source(
    data,
    source = "bigquery",
    mode = mode,
    options = parameters,
    ...
  )

  invisible()
}
