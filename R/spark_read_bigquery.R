#' @title Reading data from Google BigQuery table
#' @description TODO
#' @param sc \code{spark_connection} provided by sparklyr
#' @param tableOrQuery either the name of a Google BigQuery table,
#' or an SQL query string
#' TODO: verify whether it is possible to specify as first line of the
#'       query \#legacySQL or \#standardSQL, and which flavor is the
#'       default one (I guess legacySQL)
#'       See: https://cloud.google.com/bigquery/docs/reference/legacy-sql
#'       and: https://cloud.google.com/bigquery/docs/reference/standard-sql/
#' @param projectId id of the project to be used
#' @param datasetId id of the dataset to be used for queries
#' @param tableId id of the Google BigQuery table to be used for queries
#' @param gcsBucket TODO
#' @param datasetLocation geographical location of the dataset (for example "EU" for Europe)
#' This parameter can be found in the Google BigQuery web UI, under the "Dataset Details"
#' @import sparklyr
#' @export
spark_read_bigquery <- function(sc, tableOrQuery, projectId, datasetId, tableId, gcsBucket, datasetLocation) {
  spark_read_source(
    sc,
    name = tableOrQuery,
    source = "com.miraisolutions.spark.bigquery",
    options = list(
      "bq.project.id" = projectId,
      "bq.gcs.bucket" = gcsBucket,
      "bq.dataset.location" = datasetLocation,
      "tableReference" = sprintf("%s:%s.%s", projectId, datasetId, tableId)
    )
  )
}
