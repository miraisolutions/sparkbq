spark_dependencies <- function(spark_version, scala_version, ...) {
  sparkBigQueryVersion = "0.1.1"
  if(spark_version < "2.2" || scala_version != "2.11") {
    stop("This version of sparkbq currently only supports Spark 2.2 or newer with Scala 2.11")
  }
  
  sparklyr::spark_dependency(
    packages = c(
      sprintf("miraisolutions:spark-bigquery:%s-s_%s", sparkBigQueryVersion, scala_version)
    )
  )
}

.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
