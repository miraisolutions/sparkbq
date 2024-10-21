#' @title Writing data to Google BigQuery
#' @description This function writes data to a Google BigQuery table.
#' @details
#' Data is written directly to BigQuery using the
#' \href{https://cloud.google.com/bigquery/docs/write-api}{BigQuery Storage Write API}.
#' @param data Spark DataFrame to write to Google BigQuery.
#' @param billingProjectId Google Cloud Platform project ID for billing purposes.
#' This is the project on whose behalf to perform BigQuery operations.
#' Defaults to \code{default_billing_project_id()}.
#' @param projectId Google Cloud Platform project ID of BigQuery dataset.
#' Defaults to \code{billingProjectId}.
#' @param datasetId Google BigQuery dataset ID (may contain letters, numbers and underscores).
#' @param tableId Google BigQuery table ID (may contain letters, numbers and underscores).
#' @param serviceAccountKeyFile Google Cloud service account key file to use for authentication
#' with Google Cloud services. The use of service accounts is highly recommended. Specifically,
#' the service account will be used to interact with BigQuery and Google Cloud Storage (GCS).
#' @param additionalParameters
#' \href{https://github.com/GoogleCloudDataproc/spark-bigquery-connector?tab=readme-ov-file#properties}{Additional Spark BigQuery connector options}.
#' @param mode Specifies the behavior when data or table already exist. One of "overwrite",
#' "append", "ignore" or "error" (default).
#' @param ... Additional arguments passed to \code{\link[sparklyr]{spark_write_source}}.
#' @return \code{NULL}. This is a side-effecting function.
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
#' 
#' \url{https://cloud.google.com/bigquery/docs/write-api}
#'
#' @family Spark serialization routines
#' @seealso \code{\link[sparklyr]{spark_write_source}}, \code{\link{spark_read_bigquery}},
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
#' # Copy mtcars to Spark
#' spark_mtcars <- dplyr::copy_to(sc, mtcars, "spark_mtcars", overwrite = TRUE)
#'
#' spark_write_bigquery(
#'   data = spark_mtcars,
#'   datasetId = "<your_dataset_id>",
#'   tableId = "mtcars",
#'   mode = "overwrite")
#' }
#' @importFrom sparklyr spark_write_source
#' @export
spark_write_bigquery <- function(data,
                                 billingProjectId = default_billing_project_id(),
                                 projectId = billingProjectId,
                                 datasetId,
                                 tableId,
                                 serviceAccountKeyFile = default_service_account_key_file(),
                                 additionalParameters = NULL,
                                 mode = "error",
                                 ...) {
  parameters <- c(list(
    table = sprintf("%s.%s.%s", projectId, datasetId, tableId),
    writeMethod = "direct"
  ),
  additionalParameters)
  
  if (!is.null(serviceAccountKeyFile)) {
    parameters[["credentialsFile"]] = gsub("\\\\", "/", serviceAccountKeyFile)
  }
  
  spark_write_source(data,
                     source = "bigquery",
                     mode = mode,
                     options = parameters,
                     ...)
  
  invisible()
}
