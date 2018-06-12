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
#' @param gcsBucket Google Cloud Storage bucket used for temporary BigQuery files.
#' This should be the name of an existing storage bucket. Defaults to
#' \code{default_gcs_bucket()}.
#' @param datasetLocation Google BigQuery dataset location ("EU" or "US"). Only needs to be
#' specified if the dataset does not yet exist. It is ignored if it specified and the
#' dataset already exists. Defaults to \code{default_dataset_location()}.
#' @param additionalParameters Additional Hadoop parameters
#' @param mode Specifies the behavior when data or table already exist. One of "overwrite",
#' "append", "ignore" or "error" (default).
#' @param ... Additional arguments passed to \code{\link[sparklyr]{spark_write_source}}.
#' @return \code{NULL}. This is a side-effecting function.
#' @references
#' \url{https://cloud.google.com/bigquery/docs/datasets}
#' \url{https://cloud.google.com/bigquery/docs/tables}
#' \url{https://cloud.google.com/bigquery/docs/reference/standard-sql/}
#' @family Spark serialization routines
#' @seealso \code{\link[sparklyr]{spark_write_source}}, \code{\link{spark_read_bigquery}},
#' \code{\link{bigquery_defaults}}
#' @keywords database, connection
#' @examples
#' \dontrun{
#' # Required when running outside of Google Cloud Platform
#' gcpJsonKeyfile <- "/path/to/your/gcp_json_keyfile.json"
#' 
#' Sys.setenv("GOOGLE_APPLICATION_CREDENTIALS" = gcpJsonKeyfile)
#' # or
#' config <- spark_config()
#' config[["spark.hadoop.google.cloud.auth.service.account.json.keyfile"]] <- gcpJsonKeyfile
#' 
#' sc <- spark_connect(master = "local", config = config)
#' 
#' bigquery_defaults(
#'   billingProjectId = "<your_billing_project_id>",
#'   gcsBucket = "<your_gcs_bucket>",
#'   datasetLocation = "US")
#' 
#' # Copy mtcars to Spark
#' spark_mtcars <- dplyr::copy_to(sc, mtcars, "spark_mtcars", overwrite = TRUE)
#' 
#' spark_write_bigquery(
#'   data = spark_mtcars,
#'   datasetId = "<your_dataset_id>",
#'   tableId = "mtcars",
#'   datasetLocation = "<your_dataset_location>",
#'   mode = "overwrite",
#'   additionalParameters = list("mapred.bq.dynamic.file.list.record.reader.poll.interval" = "500"))
#' }
#' @importFrom sparklyr spark_write_source
#' @export
spark_write_bigquery <- function(data, billingProjectId = default_billing_project_id(), 
                                 projectId = billingProjectId, datasetId, tableId, 
                                 gcsBucket = default_gcs_bucket(),
                                 datasetLocation = default_dataset_location(), 
                                 additionalParameters = NULL, mode = "error", ...) {
  parameters <- c(list(
    "bq.project.id" = billingProjectId,
    "bq.gcs.bucket" = gcsBucket,
    "bq.dataset.location" = if(is.null(datasetLocation)) "" else datasetLocation,
    "table" = sprintf("%s:%s.%s", projectId, datasetId, tableId)
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
