spark_dependencies <- function(spark_version, scala_version, ...) {
  # TODO: check how to support multiple spark/scala versions
  sparkBigQueryVersion = "0.1.0-SNAPSHOT"
  sparklyr::spark_dependency(
    jars = c(
      system.file(
        # TODO: check how to support multiple spark/scala versions
        # see for example https://github.com/javierluraschi/sparkhello/tree/master/inst/java
        # and https://github.com/javierluraschi/sparkhello/blob/master/R/dependencies.R
        sprintf("java/spark-bigquery_2.11-%s.jar", sparkBigQueryVersion),
        package = "sparkbq"
      )
    ),
    packages = c(
    )
  )
}

.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
