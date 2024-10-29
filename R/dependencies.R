spark_dependencies <- function(spark_version, scala_version, ...) {
  check_supported_spark_version <- function(supported_spark_versions) {
    if (!(spark_version %in% supported_spark_versions)) {
      stop("Spark version ",
           spark_version,
           " is not supported with Scala ",
           scala_version)
    }
  }
  
  switch(
    as.character(scala_version),
    "2.11" = {
      check_supported_spark_version(c("2.3", "2.4"))
      sparklyr::spark_dependency(packages = "com.google.cloud.spark:spark-bigquery-with-dependencies_2.11:0.29.0")
    },
    "2.12" = {
      check_supported_spark_version(c("2.4", "3.0", "3.1", "3.2", "3.3", "3.4", "3.5"))
      sparklyr::spark_dependency(packages = "com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.41.0")
    },
    "2.13" = {
      check_supported_spark_version(c("3.2", "3.3", "3.4", "3.5"))
      sparklyr::spark_dependency(packages = "com.google.cloud.spark:spark-bigquery-with-dependencies_2.13:0.41.0")
    },
    stop("Unsupported Scala version. Should be one of {2.11, 2.12, 2.13}.")
  )
}

.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
