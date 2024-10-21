#' @title Reading data from Google BigQuery
#' @description This function reads data stored in a Google BigQuery table.
#' @param sc \code{\link[sparklyr]{spark_connection}} provided by sparklyr.
#' @param name The name to assign to the newly generated table (see also
#' \code{\link[sparklyr]{spark_read_source}}).
#' @param billingProjectId Google Cloud Platform project ID for billing purposes.
#' This is the project on whose behalf to perform BigQuery operations.
#' Defaults to \code{\link{default_billing_project_id}}.
#' @param projectId Google Cloud Platform project ID of BigQuery dataset.
#' Defaults to \code{billingProjectId}.
#' @param datasetId Google BigQuery dataset ID (may contain letters, numbers and underscores).
#' Either both of \code{datasetId} and \code{tableId} or \code{sqlQuery} must be specified.
#' @param tableId Google BigQuery table ID (may contain letters, numbers and underscores).
#' Either both of \code{datasetId} and \code{tableId} or \code{sqlQuery} must be specified.
#' @param sqlQuery Google BigQuery SQL query. Either both of \code{datasetId} and \code{tableId}
#' or \code{sqlQuery} must be specified. The query must be specified in standard SQL
#' (SQL-2011). Legacy SQL is not supported. Tables are specified as
#' \code{<project_id>.<dataset_id>.<table_id>}.
#' @param materializationProject Project to use for materializing SQL queries. See also
#' \code{materializationDataset}. Defaults to billing project
#' \code{\link{default_materialization_project}}.
#' @param materializationDataset Dataset (in materialization project) which is used for
#' materializing SQL queries (see \code{sqlQuery}). The GCP user
#' (see \code{serviceAccountKeyFile}) needs to have table creation permission in
#' that dataset. Note that according to
#' \url{https://cloud.google.com/bigquery/docs/writing-results#temporary_and_permanent_tables}
#' the queried tables must be in the same location as the materialization dataset.
#' Defaults to \code{\link{default_materialization_dataset}}.
#' @param serviceAccountKeyFile Google Cloud service account key file to use for authentication
#' with Google Cloud services. The use of service accounts is highly recommended. Specifically,
#' the service account will be used to interact with BigQuery and Google Cloud Storage (GCS).
#' Defaults to \code{\link{default_service_account_key_file}}.
#' @param additionalParameters
#' \href{https://github.com/GoogleCloudDataproc/spark-bigquery-connector?tab=readme-ov-file#properties}{Additional Spark BigQuery connector options}.
#' @param memory \code{logical} specifying whether data should be loaded eagerly into
#' memory, i.e. whether the table should be cached. Note that eagerly caching prevents
#' predicate pushdown (e.g. in conjunction with \code{\link[dplyr]{filter}}) and therefore
#' the default is \code{FALSE}. See also \code{\link[sparklyr]{spark_read_source}}.
#' @param ... Additional arguments passed to \code{\link[sparklyr]{spark_read_source}}.
#' @return A \code{tbl_spark} which provides a \code{dplyr}-compatible reference to a
#' Spark DataFrame.
#' @references
#' \url{https://github.com/GoogleCloudDataproc/spark-bigquery-connector}
#' 
#' \url{https://cloud.google.com/bigquery/docs/datasets}
#' 
#' \url{https://cloud.google.com/bigquery/docs/tables}
#' 
#' \url{https://cloud.google.com/bigquery/docs/reference/standard-sql/}
#' 
#' \url{https://cloud.google.com/bigquery/pricing}
#' 
#' \url{https://cloud.google.com/bigquery/docs/dataset-locations}
#' 
#' \url{https://cloud.google.com/docs/authentication/}
#' 
#' \url{https://cloud.google.com/bigquery/docs/authentication/}
#' @family Spark serialization routines
#' @seealso \code{\link[sparklyr]{spark_read_source}}, \code{\link{spark_write_bigquery}},
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
#'   serviceAccountKeyFile = "<your_service_account_key_file>")
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
spark_read_bigquery <- function(sc,
                                name,
                                billingProjectId = default_billing_project_id(),
                                projectId = billingProjectId,
                                datasetId = NULL,
                                tableId = NULL,
                                sqlQuery = NULL,
                                materializationProject = default_materialization_project(),
                                materializationDataset = default_materialization_dataset(),
                                serviceAccountKeyFile = default_service_account_key_file(),
                                additionalParameters = NULL,
                                memory = FALSE,
                                ...) {
  parameters <- c(list(), additionalParameters)
  if (!is.null(serviceAccountKeyFile)) {
    parameters[["credentialsFile"]] = gsub("\\\\", "/", serviceAccountKeyFile)
  }
  
  if (!is.null(datasetId) && !is.null(tableId)) {
    path <- sprintf("%s.%s.%s", projectId, datasetId, tableId)
  } else if (!is.null(sqlQuery)) {
    path <- sqlQuery
    parameters[["viewsEnabled"]] <- "true"
    if (is.null(materializationDataset)) {
      stop(
        "A materialization dataset with table creation permission ",
        "must be specified in order to execute SQL queries."
      )
    }
    parameters[["materializationProject"]] <- materializationProject
    parameters[["materializationDataset"]] <- materializationDataset
  } else {
    stop("Either both of 'datasetId' and 'tableId' or 'sqlQuery' must be specified.")
  }
  
  spark_read_source(
    sc,
    name = name,
    path = path,
    source = "bigquery",
    options = parameters,
    memory = memory,
    ...
  )
}
