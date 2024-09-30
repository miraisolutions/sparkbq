#' @title Google BigQuery Default Settings
#' @description Sets default values for several Google BigQuery related settings.
#' @param billingProjectId Default Google Cloud Platform (GCP) project ID for billing purposes.
#' This is the project on whose behalf to perform BigQuery operations.
#' @param materializationProject Project to use for materializing SQL queries. See also
#' \code{materializationDataset}. Defaults to billing project (\code{billingProjectId}).
#' @param materializationDataset Dataset (in materialization project) which is used for
#' materializing SQL queries (see argument \code{sqlQuery} in \code{\link{spark_read_bigquery}}).
#' The GCP user (see \code{serviceAccountKeyFile}) needs to have table creation permission in
#' that dataset. Note that according to
#' \url{https://cloud.google.com/bigquery/docs/writing-results#temporary_and_permanent_tables}
#' the queried tables must be in the same location as the materialization dataset.
#' @param gcsBucket Google Cloud Storage (GCS) bucket to use for storing temporary files.
#' Temporary files are used when importing through BigQuery load jobs and exporting through
#' BigQuery extraction jobs (i.e. when using data extracts such as Parquet, Avro, ORC, ...).
#' The service account specified in \code{serviceAccountKeyFile} needs to be given appropriate
#' rights. This should be the name of an existing storage bucket.
#' @param serviceAccountKeyFile Google Cloud service account key file to use for authentication
#' with Google Cloud services. The use of service accounts is highly recommended. Specifically,
#' the service account will be used to interact with BigQuery and Google Cloud Storage (GCS).
#' If not specified, Google application default credentials (ADC) will be used, which is the default.
#' @param writeMethod Default BigQuery write method ("direct" or "gcs").
#'
#' @return A \code{list} of set options with previous values.
#' @references
#' \url{https://github.com/GoogleCloudDataproc/spark-bigquery-connector}
#' \url{https://cloud.google.com/bigquery/pricing}
#' \url{https://cloud.google.com/bigquery/docs/dataset-locations}
#' \url{https://cloud.google.com/bigquery/docs/authentication/service-account-file}
#' \url{https://cloud.google.com/docs/authentication/}
#' \url{https://cloud.google.com/bigquery/docs/authentication/}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-parquet}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-avro}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-orc}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-json}
#' \url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-csv}
#' @seealso \code{\link{spark_read_bigquery}}, \code{\link{spark_write_bigquery}},
#' \code{\link{default_billing_project_id}}, \code{\link{default_materialization_project}},
#' \code{\link{default_materialization_dataset}}, \code{\link{default_gcs_bucket}},
#' \code{\link{default_service_account_key_file}}, \code{\link{default_write_method}}
#' @keywords database connection
#' @export
bigquery_defaults <- function(billingProjectId,
                              materializationProject = billingProjectId,
                              materializationDataset = NULL,
                              gcsBucket = NULL,
                              serviceAccountKeyFile = NULL,
                              writeMethod = "direct") {
  if (is.null(serviceAccountKeyFile)) {
    g_app_cred <- Sys.getenv("GOOGLE_APPLICATION_CREDENTIALS")
    if (g_app_cred != "") {
      serviceAccountKeyFile <- g_app_cred
    }
  }
  
  options(
    "sparkbq.default.billingProjectId" = billingProjectId,
    "sparkbq.default.materializationProject" = materializationProject,
    "sparkbq.default.materializationDataset" = materializationDataset,
    "sparkbq.default.gcsBucket" = gcsBucket,
    "sparkbq.default.serviceAccountKeyFile" = serviceAccountKeyFile,
    "sparkbq.default.writeMethod" = writeMethod
  )
}

#' @title Default Google BigQuery Billing Project ID
#' @description Returns the default Google BigQuery billing project ID.
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_billing_project_id <- function() {
  getOption("sparkbq.default.billingProjectId")
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

#' @title Default Google BigQuery GCS Bucket
#' @description Returns the default Google BigQuery GCS bucket.
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_gcs_bucket <- function() {
  getOption("sparkbq.default.gcsBucket")
}

#' @title Default Google BigQuery Service Account Key File
#' @description Returns the default service account key file to use.
#' @references
#' \url{https://cloud.google.com/bigquery/docs/authentication/service-account-file}
#' \url{https://cloud.google.com/docs/authentication/}
#' \url{https://cloud.google.com/bigquery/docs/authentication/}
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_service_account_key_file <- function() {
  getOption("sparkbq.default.serviceAccountKeyFile")
}

#' @title Default BigQuery Write Method
#' @description Returns the default BigQuery write method.
#' @seealso \code{\link{bigquery_defaults}}
#' @export
default_write_method <- function() {
  getOption("sparkbq.default.writeMethod")
}
