#' @title Reading data from Google BigQuery
#' @description This function reads data stored in a Google BigQuery table.
#' @param sc \code{\link[sparklyr]{spark_connection}} provided by sparklyr.
#' @param name The name to assign to the newly generated table (see also
#' \code{\link[sparklyr]{spark_read_source}}).
#' @param projectId Google Cloud Platform project ID for BigQuery.
#' @param datasetId Google BigQuery dataset ID (may contain letters, numbers and underscores).
#' Either both of \code{datasetId} and \code{tableId} or \code{sqlQuery} must be specified.
#' @param tableId Google BigQuery table ID (may contain letters, numbers and underscores).
#' Either both of \code{datasetId} and \code{tableId} or \code{sqlQuery} must be specified.
#' @param sqlQuery Google BigQuery standard SQL query (SQL-2011 dialect).
#' Either both of \code{datasetId} and \code{tableId} or \code{sqlQuery} must be specified.
#' @param gcsBucket Google Cloud Storage bucket used for temporary BigQuery files.
#' @param datasetLocation Google BigQuery dataset location ("EU" or "US").
#' This parameter can be found in the Google BigQuery web interface under "Dataset Details".
#' @param ... Additional arguments passed to \code{\link[sparklyr]{spark_read_source}}.
#' @return A \code{tbl_spark} which provides a \code{dplyr}-compatible reference to a
#' Spark DataFrame. 
#' @references
#' \url{https://cloud.google.com/bigquery/docs/datasets}
#' \url{https://cloud.google.com/bigquery/docs/tables}
#' \url{https://cloud.google.com/bigquery/docs/reference/standard-sql/}
#' @family Spark serialization routines
#' @seealso \code{\link[sparklyr]{spark_read_source}}, \code{\link{spark_write_bigquery}}
#' @keywords database, connection
#' @importFrom sparklyr spark_read_source
#' @export
spark_read_bigquery <- function(sc, name, projectId, datasetId = NULL, tableId = NULL, 
                                sqlQuery = NULL, gcsBucket, datasetLocation, ...) {
  parameters <- list(
    "bq.project.id" = projectId,
    "bq.gcs.bucket" = gcsBucket,
    "bq.dataset.location" = datasetLocation
  )
  
  if(!is.null(datasetId) && !is.null(tableId)) {
    parameters[["table"]] <- sprintf("%s:%s.%s", projectId, datasetId, tableId)
  } else if(!is.null(sqlQuery)) {
    parameters[["sqlQuery"]] <- sqlQuery
  } else {
    stop("Either both of 'datasetId' and 'tableId' or 'sqlQuery' must be specified.")
  }
  
  spark_read_source(
    sc,
    name = name,
    source = "com.miraisolutions.spark.bigquery",
    options = parameters,
    ...
  )
}
