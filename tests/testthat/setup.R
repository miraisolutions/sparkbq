# Setting some BigQuery defaults for use in tests
bigquery_defaults(
  billingProjectId = Sys.getenv("BILLING_PROJECT_ID"),
  materializationDataset = Sys.getenv("MATERIALIZATION_DATASET"),
  serviceAccountKeyFile = normalizePath(Sys.getenv("GOOGLE_APPLICATION_CREDENTIALS"), winslash = "/")
)

options(spark.version = Sys.getenv("SPARK_VERSION", "3.5"))
