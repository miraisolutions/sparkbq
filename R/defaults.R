#' @title Google BigQuery Default Settings
#' @description Sets default values for several Google BigQuery related settings.
#' @param projectId Default Google Cloud Platform (GCP) project ID to use.
#' @param materializationProject Project to use for materializing SQL queries. See also
#' \code{materializationDataset}. Defaults to the billing project (\code{billingProjectId}).
#' @param materializationDataset Dataset (in materialization project) which is used for
#' materializing SQL queries (see argument \code{sqlQuery} in \code{\link{spark_read_bigquery}}).
#' The GCP user (see \code{serviceAccountKeyFile}) needs to have table creation permission in
#' that dataset. Note that according to
#' \url{https://cloud.google.com/bigquery/docs/writing-results#temporary_and_permanent_tables}
#' the queried tables must be in the same location as the materialization dataset.
#' @param serviceAccountKeyFile Google Cloud service account key file to use for authentication
#' with Google Cloud services. The use of service accounts is highly recommended. Specifically,
#' the service account will be used to interact with BigQuery and Google Cloud Storage (GCS).
#' If not specified, Google application default credentials (ADC) will be used, which is the default.
#' @return A \code{list} of set options with previous values.
#' @references
#' \url{https://github.com/GoogleCloudDataproc/spark-bigquery-connector}
#' 
#' \url{https://cloud.google.com/bigquery/pricing}
#' 
#' \url{https://cloud.google.com/bigquery/docs/dataset-locations}
#' 
#' \url{https://cloud.google.com/bigquery/docs/authentication/service-account-file}
#' 
#' \url{https://cloud.google.com/docs/authentication/}
#' 
#' \url{https://cloud.google.com/bigquery/docs/authentication/}
#' @seealso
#' \code{\link{spark_read_bigquery}}
#' 
#' \code{\link{spark_write_bigquery}}
#' 
#' \code{\link{default_project_id}}
#' 
#' \code{\link{default_materialization_project}}
#' 
#' \code{\link{default_materialization_dataset}}
#' 
#' \code{\link{default_service_account_key_file}}
#' @keywords database connection
#' @export
bigquery_defaults <- function(projectId,
                              materializationProject = projectId,
                              materializationDataset = NULL,
                              serviceAccountKeyFile = NULL) {
  if (is.null(serviceAccountKeyFile)) {
    g_app_cred <- Sys.getenv("GOOGLE_APPLICATION_CREDENTIALS")
    if (g_app_cred != "") {
      serviceAccountKeyFile <- g_app_cred
    }
  }
  
  options(
    "sparkbq.default.projectId" = projectId,
    "sparkbq.default.materializationProject" = materializationProject,
    "sparkbq.default.materializationDataset" = materializationDataset,
    "sparkbq.default.serviceAccountKeyFile" = serviceAccountKeyFile
  )
}

#' @title Default Google BigQuery Project ID
#' @description Returns the default Google BigQuery project ID.
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_project_id <- function() {
  getOption("sparkbq.default.projectId")
}

#' @title Default Google BigQuery Materialization Project
#' @description Returns the default Google BigQuery materialization project.
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_materialization_project <- function() {
  getOption("sparkbq.default.materializationProject")
}

#' @title Default Google BigQuery Materialization Dataset
#' @description Returns the default Google BigQuery materialization dataset.
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_materialization_dataset <- function() {
  getOption("sparkbq.default.materializationDataset")
}

#' @title Default Google BigQuery Service Account Key File
#' @description Returns the default service account key file to use.
#' @references
#' \url{https://cloud.google.com/bigquery/docs/authentication/service-account-file}
#' 
#' \url{https://cloud.google.com/docs/authentication/}
#' 
#' \url{https://cloud.google.com/bigquery/docs/authentication/}
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_service_account_key_file <- function() {
  getOption("sparkbq.default.serviceAccountKeyFile")
}
