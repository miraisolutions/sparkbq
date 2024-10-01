<img src="man/figures/logo.png" align="right" width="15%" height="15%"/>

# sparkbq: Google BigQuery Support for sparklyr

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/sparkbq)](https://cran.r-project.org/package=sparkbq) [![Rdoc](https://www.rdocumentation.org/packages/sparkbq)](https://www.rdocumentation.org/packages/sparkbq)

**sparkbq** is a [sparklyr](https://spark.posit.co/) [extension](https://spark.posit.co/guides/extensions.html) package providing an integration with [Google BigQuery](https://cloud.google.com/bigquery/). It builds on top of [spark-bigquery](https://github.com/miraisolutions/spark-bigquery), which provides a Google BigQuery data source to [Apache Spark](https://spark.apache.org/).

This package leverages the [Google Spark BigQuery Connector](https://github.com/GoogleCloudDataproc/spark-bigquery-connector).

## Version Information

You can install the released version of **sparkbq** from CRAN via
``` r
install.packages("sparkbq")
```
or the latest development version through
``` r
devtools::install_github("miraisolutions/sparkbq", ref = "develop")
```

For supported versions of Apache Spark (and Dataproc) see the [Connector to Spark Compatibility Matrix](https://github.com/GoogleCloudDataproc/spark-bigquery-connector?tab=readme-ov-file#connector-to-spark-compatibility-matrix).
The relevant connector in the matrix is called `spark-bigquery-with-dependencies_<scala_version>`.

## Example Usage

``` r
library(sparklyr)
library(sparkbq)
library(dplyr)

config <- spark_config()

sc <- spark_connect(master = "local[*]", config = config)

# Set Google BigQuery default settings
bigquery_defaults(
  billingProjectId = "<your_billing_project_id>",
  serviceAccountKeyFile = "<your_service_account_key_file>"
)

# Reading the public shakespeare data table
# https://cloud.google.com/bigquery/public-data/
# https://cloud.google.com/bigquery/sample-tables
hamlet <- 
  spark_read_bigquery(
    sc,
    name = "hamlet",
    projectId = "bigquery-public-data",
    datasetId = "samples",
    tableId = "shakespeare") %>%
  filter(corpus == "hamlet") # NOTE: predicate pushdown to BigQuery!
  
# Retrieve results into a local tibble
hamlet %>% collect()

# Write result into "mysamples" dataset in our BigQuery (billing) project
spark_write_bigquery(
  hamlet,
  datasetId = "mysamples",
  tableId = "hamlet",
  mode = "overwrite")
```

## Authentication

When running outside of Google Cloud it is necessary to specify a service account JSON key file. The service account key file can be passed as parameter `serviceAccountKeyFile` to `bigquery_defaults` or directly to `spark_read_bigquery` and `spark_write_bigquery`.

Alternatively, an environment variable `export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/service_account_keyfile.json` can be set (see https://cloud.google.com/docs/authentication/getting-started for more information). Make sure the variable is set before starting the R session.

When running on Google Cloud, e.g. Google Cloud Dataproc, application default credentials (ADC) may be used in which case it is not necessary to specify a service account key file.

## Further Information

* [Google Spark Bigquery Connector](https://github.com/GoogleCloudDataproc/spark-bigquery-connector)
* [BigQuery pricing](https://cloud.google.com/bigquery/pricing)
* [BigQuery dataset locations](https://cloud.google.com/bigquery/docs/dataset-locations)
* [General authentication](https://cloud.google.com/docs/authentication/)
* [BigQuery authentication](https://cloud.google.com/bigquery/docs/authentication/)
* [BigQuery: authenticating with a service account key file](https://cloud.google.com/bigquery/docs/authentication/service-account-file)
* [Cloud Storage authentication](https://cloud.google.com/storage/docs/authentication/)
