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
#' @param tableId Google BigQuery table ID (may contain letters, numbers and underscores).
#' Either both of \code{datasetId} and \code{tableId} or \code{sqlQuery} must be specified.
#' @param sqlQuery Google BigQuery SQL query. Either both of \code{datasetId} and \code{tableId}
#' or \code{sqlQuery} must be specified. The query must be specified in standard SQL
#' (SQL-2011). Legacy SQL is not supported. Tables are specified as
#' `<project_id>.<dataset_id>.<table_id>`.
#' @param type BigQuery import type to use. Options include "direct", "avro",
#' "json" and "csv". Defaults to \code{default_bigquery_type()}.
#' See \link{bigquery_defaults} for more details about the supported types.
#' @param gcsBucket Google Cloud Storage (GCS) bucket to use for storing temporary files.
#' Temporary files are used when importing through BigQuery load jobs and exporting through
#' BigQuery extraction jobs (i.e. when using data extracts such as Parquet, Avro, ORC, ...).
#' The service account specified in \code{serviceAccountKeyFile} needs to be given appropriate
#' rights. This should be the name of an existing storage bucket.
#' @param serviceAccountKeyFile Google Cloud service account key file to use for authentication
#' with Google Cloud services. The use of service accounts is highly recommended. Specifically,
#' the service account will be used to interact with BigQuery and Google Cloud Storage (GCS).
#' @param additionalParameters Additional spark-bigquery options. See
#' \url{https://github.com/miraisolutions/spark-bigquery} for more information.
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
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-avro}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-json}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-csv}
#' \url{https://cloud.google.com/bigquery/pricing}
#' \url{https://cloud.google.com/bigquery/docs/dataset-locations}
#' \url{https://cloud.google.com/docs/authentication/}
#' \url{https://cloud.google.com/bigquery/docs/authentication/}
#' @family Spark serialization routines
#' @seealso \code{\link[sparklyr]{spark_read_source}}, \code{\link{spark_write_bigquery}},
#' \code{\link{bigquery_defaults}}
#' @keywords database, connection
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
#' # Reading the public shakespeare data table
#' # https://cloud.google.com/bigquery/public-data/
#' # https://cloud.google.com/bigquery/sample-tables
#' shakespeare <-
#'   spark_read_bigquery(
#'     sc,
#'     name = "shakespeare",
#'     projectId = "bigquery-public-data",
#'     datasetId = "samples",
#'     tableId = "shakespeare")
#' }
#' @importFrom sparklyr spark_read_source
#' @export
spark_read_bigquery <- function(sc, name, billingProjectId = default_billing_project_id(),
                                projectId = billingProjectId, datasetId = NULL,
                                tableId = NULL, sqlQuery = NULL, type = default_bigquery_type(),
                                gcsBucket = default_gcs_bucket(),
                                serviceAccountKeyFile = default_service_account_key_file(),
                                additionalParameters = NULL, memory = FALSE, ...) {

  if(!(type %in% c("direct", "avro", "json", "csv")))
    stop(sprintf("The import type '%s' is not supported by spark_read_bigquery", type))

  parameters <- c(list(
    "bq.project" = billingProjectId,
    "bq.staging_dataset.gcs_bucket" = gcsBucket,
    "bq.location" = default_dataset_location(),
    "type" = type
  ), additionalParameters)

  if(!is.null(datasetId) && !is.null(tableId)) {
    parameters[["table"]] <- sprintf("%s.%s.%s", projectId, datasetId, tableId)
  } else if(!is.null(sqlQuery)) {
    parameters[["sqlQuery"]] <- sqlQuery
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
