#' @title Writing data to Google BigQuery
#' @description This function writes data to a Google BigQuery table.
#' @param data Spark DataFrame to write to Google BigQuery.
#' @param projectId Google Cloud Platform project ID for BigQuery.
#' @param datasetId Google BigQuery dataset ID (may contain letters, numbers and underscores).
#' @param tableId Google BigQuery table ID (may contain letters, numbers and underscores).
#' @param gcsBucket Google Cloud Storage bucket used for temporary BigQuery files.
#' @param datasetLocation Google BigQuery dataset location ("EU" or "US").
#' This parameter can be found in the Google BigQuery web UI, under the "Dataset Details".
#' @param mode Specifies the behavior when data or table already exist. One of "overwrite",
#' "append", "ignore" or "error" (default).
#' @references
#' \url{https://cloud.google.com/bigquery/docs/datasets}
#' \url{https://cloud.google.com/bigquery/docs/tables}
#' \url{https://cloud.google.com/bigquery/docs/reference/standard-sql/}
#' @family Spark serialization routines
#' @seealso \code{\link[sparklyr]{spark_write_source}}, \code{\link{spark_read_bigquery}}
#' @importFrom sparklyr spark_write_source
#' @export
spark_write_bigquery <- function(data, projectId, datasetId, tableId, gcsBucket, datasetLocation, mode = "error") {
  parameters <- list(
    "bq.project.id" = projectId,
    "bq.gcs.bucket" = gcsBucket,
    "bq.dataset.location" = datasetLocation,
    "table" = sprintf("%s:%s.%s", projectId, datasetId, tableId)
  )
  
  spark_write_source(
    data,
    source = "com.miraisolutions.spark.bigquery",
    mode = mode,
    options = parameters
  )
}
