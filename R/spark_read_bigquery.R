#' @title Reading data from Google BigQuery
#' @description This function reads data stored in a Google BigQuery table.
#' @param sc \code{\link[sparklyr]{spark_connection}} provided by sparklyr.
#' @param name The name to assign to the newly generated table (see also
#' \code{\link[sparklyr]{spark_read_source}}).
#' @param billingProjectId Google Cloud Platform project ID for billing purposes.
#' This is the project on whose behalf to perform BigQuery operations.
#' @param projectId Google Cloud Platform project ID of BigQuery data set.
#' Defaults to \code{billingProjectId}.
#' @param datasetId Google BigQuery dataset ID (may contain letters, numbers and underscores).
#' Either both of \code{datasetId} and \code{tableId} or \code{sqlQuery} must be specified.
#' @param tableId Google BigQuery table ID (may contain letters, numbers and underscores).
#' Either both of \code{datasetId} and \code{tableId} or \code{sqlQuery} must be specified.
#' @param sqlQuery Google BigQuery standard SQL query (SQL-2011 dialect).
#' Either both of \code{datasetId} and \code{tableId} or \code{sqlQuery} must be specified.
#' @param gcsBucket Google Cloud Storage bucket used for temporary BigQuery files.
#' This should be the name of an existing storage bucket.
#' @param additionalParameters Additional Hadoop parameters
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
#' # Reading the public shakespeare data table
#' # https://cloud.google.com/bigquery/public-data/
#' # https://cloud.google.com/bigquery/sample-tables
#' shakespeare <-
#'   spark_read_bigquery(
#'     sc,
#'     name = "shakespeare",
#'     billingProjectId = "<your_billing_project_id>",
#'     projectId = "bigquery-public-data",
#'     datasetId = "samples",
#'     tableId = "shakespeare",
#'     gcsBucket = "<your_gcs_bucket>",
#'     additionalParameters = list("mapred.bq.dynamic.file.list.record.reader.poll.interval" = "500"))
#' }
#' @importFrom sparklyr spark_read_source
#' @export
spark_read_bigquery <- function(sc, name, billingProjectId, projectId = billingProjectId, 
                                datasetId = NULL, tableId = NULL, sqlQuery = NULL,
                                gcsBucket, additionalParameters = NULL, ...) {
  parameters <- c(list(
    "bq.project.id" = billingProjectId,
    "bq.gcs.bucket" = gcsBucket
  ), additionalParameters)
  
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
