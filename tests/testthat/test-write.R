test_that("writing BigQuery tables using direct method works", {
  skip_on_cran()
  
  sc <- sparklyr::spark_connect(master = "local", version = getOption("spark.version"))
  
  # Copy mtcars to Spark
  spark_mtcars <- dplyr::copy_to(sc, mtcars, "spark_mtcars", overwrite = TRUE)
  
  spark_write_bigquery(
    spark_mtcars,
    datasetId = "test",
    tableId = "mtcars",
    mode = "overwrite"
  )
  
  mtcars2 <- spark_read_bigquery(
    sc,
    name = "shakespeare",
    datasetId = "test",
    tableId = "mtcars"
  ) %>% sparklyr::collect()
  
  expect_equal(
    mtcars %>% dplyr::arrange_at(names(mtcars)), 
    as.data.frame(mtcars2) %>% dplyr::arrange_at(names(mtcars)),
    ignore_attr = "row.names")
})
