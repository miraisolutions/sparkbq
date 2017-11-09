#' @title Writing data to Google BigQuery
#' @description This function writes data to a Google BigQuery table.
#' @param data Spark DataFrame to write to Google BigQuery.
#' @param billingProjectId Google Cloud Platform project ID for billing purposes.
#' This is the project on whose behalf to perform BigQuery operations.
#' @param projectId Google Cloud Platform project ID of BigQuery data set.
#' Defaults to \code{billingProjectId}.
#' @param datasetId Google BigQuery dataset ID (may contain letters, numbers and underscores).
#' @param tableId Google BigQuery table ID (may contain letters, numbers and underscores).
#' @param gcsBucket Google Cloud Storage bucket used for temporary BigQuery files.
#' This should be the name of an existing storage bucket.
#' @param datasetLocation Google BigQuery dataset location ("EU" or "US"). Only needs to be
#' specified if the data set does not yet exist. It is ignored if it specified and the
#' data set already exists.
#' This parameter can be found in the Google BigQuery web interface, under "Dataset Details".
#' @param mode Specifies the behavior when data or table already exist. One of "overwrite",
#' "append", "ignore" or "error" (default).
#' @param ... Additional arguments passed to \code{\link[sparklyr]{spark_write_source}}.
#' @return \code{NULL}. This is a side-effecting function.
#' @references
#' \url{https://cloud.google.com/bigquery/docs/datasets}
#' \url{https://cloud.google.com/bigquery/docs/tables}
#' \url{https://cloud.google.com/bigquery/docs/reference/standard-sql/}
#' @family Spark serialization routines
#' @seealso \code{\link[sparklyr]{spark_write_source}}, \code{\link{spark_read_bigquery}}
#' @keywords database, connection
#' @importFrom sparklyr spark_write_source
#' @export
spark_write_bigquery <- function(data, billingProjectId, projectId = billingProjectId,
                                 datasetId, tableId, gcsBucket, datasetLocation = NULL, 
                                 mode = "error", ...) {
  parameters <- list(
    "bq.project.id" = billingProjectId,
    "bq.gcs.bucket" = gcsBucket,
    "bq.dataset.location" = if(is.null(datasetLocation)) "" else datasetLocation,
    "table" = sprintf("%s:%s.%s", projectId, datasetId, tableId)
  )
  
  spark_write_source(
    data,
    source = "com.miraisolutions.spark.bigquery",
    mode = mode,
    options = parameters,
    ...
  )
  
  invisible()
}
