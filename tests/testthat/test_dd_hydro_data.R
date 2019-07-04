context("Testing data retrieval.")


test_that("dd_hydro_data throws error if region code is invalid or missing", {
  expect_error(dd_hydro_data(prov_terr = "XXXXX", all_stns = TRUE))
  expect_error(dd_hydro_data())
})

test_that("dd_hydro_data throws error is interval not 'daily' or 'hourly'", {
  skip_if_net_down()
  expect_error(dd_hydro_data(prov_terr = "ON", update_interval = "nosnskj", all_stns = TRUE))
})

test_that("dd_hydro_data throws error if invalid station_id is passed", {
  skip_if_net_down()
  expect_error(dd_hydro_data(station_id = "CXXXCALL", prov_terr = "ON"))
})
