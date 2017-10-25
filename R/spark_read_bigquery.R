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
