% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/spark_write_bigquery.R
\name{spark_write_bigquery}
\alias{spark_write_bigquery}
\title{Writing data to Google BigQuery}
\usage{
spark_write_bigquery(data,
  billingProjectId = default_billing_project_id(),
  projectId = billingProjectId, datasetId, tableId,
  type = default_bigquery_type(), gcsBucket = default_gcs_bucket(),
  datasetLocation = default_dataset_location(),
  serviceAccountKeyFile = default_service_account_key_file(),
  additionalParameters = NULL, mode = "error", ...)
}
\arguments{
\item{data}{Spark DataFrame to write to Google BigQuery.}

\item{billingProjectId}{Google Cloud Platform project ID for billing purposes.
This is the project on whose behalf to perform BigQuery operations.
Defaults to \code{default_billing_project_id()}.}

\item{projectId}{Google Cloud Platform project ID of BigQuery dataset.
Defaults to \code{billingProjectId}.}

\item{datasetId}{Google BigQuery dataset ID (may contain letters, numbers and underscores).}

\item{tableId}{Google BigQuery table ID (may contain letters, numbers and underscores).}

\item{type}{BigQuery export type to use. Options include "direct", "parquet",
"avro", "orc". Defaults to \code{default_bigquery_type()}.
See \link{bigquery_defaults} for more details about the supported types.}

\item{gcsBucket}{Google Cloud Storage (GCS) bucket to use for storing temporary files.
Temporary files are used when importing through BigQuery load jobs and exporting through
BigQuery extraction jobs (i.e. when using data extracts such as Parquet, Avro, ORC, ...).
The service account specified in \code{serviceAccountKeyFile} needs to be given appropriate
rights. This should be the name of an existing storage bucket.}

\item{datasetLocation}{Geographic location where newly created datasets should reside.
"EU" or "US". Defaults to "US". Only needs to be specified if the dataset does not yet exist.
It is ignored if it is specified and the dataset already exists.}

\item{serviceAccountKeyFile}{Google Cloud service account key file to use for authentication
with Google Cloud services. The use of service accounts is highly recommended. Specifically,
the service account will be used to interact with BigQuery and Google Cloud Storage (GCS).}

\item{additionalParameters}{Additional spark-bigquery options. See
\url{https://github.com/miraisolutions/spark-bigquery} for more information.}

\item{mode}{Specifies the behavior when data or table already exist. One of "overwrite",
"append", "ignore" or "error" (default).}

\item{...}{Additional arguments passed to \code{\link[sparklyr]{spark_write_source}}.}
}
\value{
\code{NULL}. This is a side-effecting function.
}
\description{
This function writes data to a Google BigQuery table.
}
\examples{
\dontrun{
config <- spark_config()

sc <- spark_connect(master = "local", config = config)

bigquery_defaults(
  billingProjectId = "<your_billing_project_id>",
  gcsBucket = "<your_gcs_bucket>",
  datasetLocation = "US",
  serviceAccountKeyFile = "<your_service_account_key_file>",
  type = "direct")

# Copy mtcars to Spark
spark_mtcars <- dplyr::copy_to(sc, mtcars, "spark_mtcars", overwrite = TRUE)

spark_write_bigquery(
  data = spark_mtcars,
  datasetId = "<your_dataset_id>",
  tableId = "mtcars",
  mode = "overwrite")
}
}
\references{
\url{https://github.com/miraisolutions/spark-bigquery}
\url{https://cloud.google.com/bigquery/docs/datasets}
\url{https://cloud.google.com/bigquery/docs/tables}
\url{https://cloud.google.com/bigquery/docs/reference/standard-sql/}
\url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-parquet}
\url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-avro}
\url{https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-orc}
\url{https://cloud.google.com/bigquery/pricing}
\url{https://cloud.google.com/bigquery/docs/dataset-locations}
\url{https://cloud.google.com/docs/authentication/}
\url{https://cloud.google.com/bigquery/docs/authentication/}
}
\seealso{
\code{\link[sparklyr]{spark_write_source}}, \code{\link{spark_read_bigquery}},
\code{\link{bigquery_defaults}}

Other Spark serialization routines: \code{\link{spark_read_bigquery}}
}
\concept{Spark serialization routines}
\keyword{connection}
\keyword{database}
