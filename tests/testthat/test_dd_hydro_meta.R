context("Testing station metadata retrieval.")

test_that("dd_hydro_meta throws error if region code is invalid", {
  expect_error(dd_hydro_meta(prov_terr = "XXXXX"))
})

test_that("dd_hydro_meta allows for filtering using prov_terr", {
  skip_if_net_down()
  stn_meta <- dd_hydro_meta(prov_terr = "ON")
  expect_s3_class(stn_meta, "data.frame")

})

test_that("dd_hydro_meta allows for query with no filter", {
  skip_if_net_down()
  stn_meta <- dd_hydro_meta()
  expect_s3_class(stn_meta, "data.frame")
})

test_that("dd_hydro_meta returns six columns", {
  skip_if_net_down()
  stn_meta <- dd_hydro_meta()
  expect(ncol(stn_meta), 6)
})
