test_that("reading BigQuery tables works", {
  skip_on_cran()
  
  sc <- sparklyr::spark_connect(master = "local", version = getOption("spark.version"))
  
  shakespeare <- spark_read_bigquery(
    sc,
    name = "shakespeare",
    projectId = "bigquery-public-data",
    datasetId = "samples",
    tableId = "shakespeare"
  )
  
  expect_equal(shakespeare %>% sparklyr::sdf_nrow(), 164656)
})

test_that("executing SQL queries works", {
  skip_on_cran()
  
  sc <- sparklyr::spark_connect(master = "local", version = getOption("spark.version"))
  
  shakespeare <- spark_read_bigquery(
    sc,
    name = "shakespeare",
    sqlQuery = "SELECT * FROM bigquery-public-data.samples.shakespeare"
  )
  
  expect_equal(shakespeare %>% sparklyr::sdf_nrow(), 164656)
})
