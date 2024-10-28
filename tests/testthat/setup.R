# Setting some BigQuery defaults for use in tests
bigquery_defaults(
  projectId = Sys.getenv("BIGQUERY_PROJECT_ID"),
  materializationDataset = Sys.getenv("BIGQUERY_MATERIALIZATION_DATASET"),
  serviceAccountKeyFile = Sys.getenv("BIGQUERY_APPLICATION_CREDENTIALS")
)

options(spark.version = Sys.getenv("SPARK_VERSION", "3.5"))

config <- sparklyr::spark_config()
config$sparklyr.log.invoke <- "TRUE"

sc <- sparklyr::spark_connect(
  master = "local",
  version = getOption("spark.version"),
  config = config
)
