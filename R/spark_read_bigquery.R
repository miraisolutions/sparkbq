#' @title Reading data from Google BigQuery
#' @description This function reads data stored in a Google BigQuery table.
#' @param sc \code{\link[sparklyr]{spark_connection}} provided by sparklyr.
#' @param name The name to assign to the newly generated table (see also
#' \code{\link[sparklyr]{spark_read_source}}).
#' @param billingProjectId Google Cloud Platform project ID for billing purposes.
#' This is the project on whose behalf to perform BigQuery operations.
#' Defaults to \code{default_billing_project_id()}.
#' @param projectId Google Cloud Platform project ID of BigQuery dataset.
#' Defaults to \code{billingProjectId}.
#' @param datasetId Google BigQuery dataset ID (may contain letters, numbers and underscores).
#' Either both of \code{datasetId} and \code{tableId} or \code{sqlQuery} must be specified.
#' @param type BigQuery import type to use. Options include "direct", "avro",
#' "json" and "csv". Defaults to \code{default_bigquery_type()}.
#' See \link{bigquery_defaults} for more details about the supported types.
#' @param tableId Google BigQuery table ID (may contain letters, numbers and underscores).
#' Either both of \code{datasetId} and \code{tableId} or \code{sqlQuery} must be specified.
#' @param sqlQuery Google BigQuery SQL query. Either both of \code{datasetId} and \code{tableId}
#' or \code{sqlQuery} must be specified. The query must be specified in standard SQL
#' (SQL-2011). Legacy SQL is not supported. Tables are specified as
#' `<project_id>.<dataset_id>.<table_id>`.
#' @param gcsBucket Google Cloud Storage bucket used for temporary BigQuery files.
#' This should be the name of an existing storage bucket. Defaults to
#' \code{default_gcs_bucket()}.
#' @param datasetLocation Google BigQuery dataset location ("EU" or "US") used for
#' temporary staging tables. Defaults to \code{default_dataset_location()}.
#' @param additionalParameters Additional Hadoop parameters
#' @param memory \code{logical} specifying whether data should be loaded eagerly into
#' memory, i.e. whether the table should be cached. Note that eagerly caching prevents
#' predicate pushdown (e.g. in conjunction with \code{\link[dplyr]{filter}}) and therefore
#' the default is \code{FALSE}. See also \code{\link[sparklyr]{spark_read_source}}.
#' @param ... Additional arguments passed to \code{\link[sparklyr]{spark_read_source}}.
#' @return A \code{tbl_spark} which provides a \code{dplyr}-compatible reference to a
#' Spark DataFrame. 
#' @references
#' \url{https://github.com/miraisolutions/spark-bigquery}
#' \url{https://cloud.google.com/bigquery/docs/datasets}
#' \url{https://cloud.google.com/bigquery/docs/tables}
#' \url{https://cloud.google.com/bigquery/docs/reference/standard-sql/}
#' \url{https://cloud.google.com/bigquery/docs/reference/legacy-sql}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-avro}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-json}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-csv}
#' @family Spark serialization routines
#' @seealso \code{\link[sparklyr]{spark_read_source}}, \code{\link{spark_write_bigquery}},
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
#'   datasetLocation = "US",
#'   type = "direct")
#' 
#' # Reading the public shakespeare data table
#' # https://cloud.google.com/bigquery/public-data/
#' # https://cloud.google.com/bigquery/sample-tables
#' shakespeare <-
#'   spark_read_bigquery(
#'     sc,
#'     name = "shakespeare",
#'     projectId = "bigquery-public-data",
#'     datasetId = "samples",
#'     tableId = "shakespeare",
#'     additionalParameters = list("mapred.bq.dynamic.file.list.record.reader.poll.interval" = "500"))
#' }
#' @importFrom sparklyr spark_read_source
#' @export
spark_read_bigquery <- function(sc, name, billingProjectId = default_billing_project_id(),
                                projectId = billingProjectId, datasetId = NULL,
                                type = default_bigquery_type(), tableId = NULL,
                                sqlQuery = NULL, gcsBucket = default_gcs_bucket(),
                                datasetLocation = default_dataset_location(),
                                additionalParameters = NULL, memory = FALSE, ...) {

  if(!(type %in% c("direct", "avro", "json", "csv")))
    stop(sprintf("The import type '%s' is not supported by spark_read_bigquery", type))

  parameters <- c(list(
    "bq.project" = billingProjectId,
    "bq.staging_dataset.gcs_bucket" = gcsBucket,
    "bq.location" = if(is.null(datasetLocation)) "" else datasetLocation,
    "type" = type
  ), additionalParameters)

  if(!is.null(datasetId) && !is.null(tableId)) {
    parameters[["table"]] <- sprintf("%s.%s.%s", projectId, datasetId, tableId)
  } else if(!is.null(sqlQuery)) {
    sqlPrefix <- "#standardSQL"
    parameters[["sqlQuery"]] <- paste0(sqlPrefix, "\n", sqlQuery)
  } else {
    stop("Either both of 'datasetId' and 'tableId' or 'sqlQuery' must be specified.")
  }

  spark_read_source(
    sc,
    name = name,
    source = "bigquery",
    options = parameters,
    memory = memory,
    ...
  )
}
