spark_dependencies <- function(spark_version, scala_version, ...) {
  sparkBigQueryVersion = "0.1.0-SNAPSHOT"
  if(spark_version != "2.2" || scala_version != "2.11") {
    stop("This version of sparkbq currently only supports Spark 2.2 with Scala 2.11")
  }
  
  sparklyr::spark_dependency(
    jars = c(
      system.file(
        sprintf("java/spark-bigquery_%s-%s.jar", scala_version, sparkBigQueryVersion),
        package = "sparkbq"
      )
    )
  )
}

.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
