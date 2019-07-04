
# rtdd

Bring near real-time hydrometric data from [the Government of Canada’s
DataMart service](https://dd.weather.gc.ca/hydrometric/) into R.

## Station Metadata

### All Stations

By default, `dd_hydro_meta` will return metadata for all avaiable
stations, across Canada

``` r
stn_meta <- dd_hydro_meta()
#> No encoding supplied: defaulting to UTF-8.
str(stn_meta)
#> Classes 'spec_tbl_df', 'tbl_df', 'tbl' and 'data.frame': 2127 obs. of  6 variables:
#>  $ STATION_ID  : chr  "01AD003" "01AD004" "01AF002" "01AF007" ...
#>  $ STATION_NAME: chr  "ST. FRANCIS RIVER AT OUTLET OF GLASIER LAKE" "SAINT JOHN RIVER AT EDMUNDSTON" "SAINT JOHN RIVER AT GRAND FALLS" "GRANDE RIVIERE AT VIOLETTE BRIDGE" ...
#>  $ STATION_LAT : num  47.2 47.4 47 47.2 47.5 ...
#>  $ STATION_LON : num  -69 -68.3 -67.7 -67.9 -68.4 ...
#>  $ PROV_TERR   : chr  "NB" "NB" "NB" "NB" ...
#>  $ TIMEZONE    : chr  "UTC-04:00" "UTC-04:00" "UTC-04:00" "UTC-04:00" ...
#>  - attr(*, "spec")=
#>   .. cols(
#>   ..   STATION_ID = col_character(),
#>   ..   STATION_NAME = col_character(),
#>   ..   STATION_LAT = col_double(),
#>   ..   STATION_LON = col_double(),
#>   ..   PROV_TERR = col_character(),
#>   ..   TIMEZONE = col_character()
#>   .. )
```

### By Province/Territory

You can also filter by a province or territory short code. See
`?dd_hydro_meta` for valid options

``` r
ont_stn_meta <- dd_hydro_meta(prov_terr = "ON")
#> No encoding supplied: defaulting to UTF-8.
```

## Station Data

You can retrieve either an individual station’s data or all the data
available for given a province or territory. There are also multiple
update intervals available:

  - hourly - (Default) Last 2 complete days of data plus the current
    incomplete day \# daily - Last 30 complete days of data plus the
    current incomplete day

### Single Station

``` r
stn_data <- dd_hydro_data(station_id = "05QB002", prov_terr = "ON")
#> No encoding supplied: defaulting to UTF-8.
str(stn_data)
#> Classes 'spec_tbl_df', 'tbl_df', 'tbl' and 'data.frame': 540 obs. of  6 variables:
#>  $ STATION_ID : chr  "05QB002" "05QB002" "05QB002" "05QB002" ...
#>  $ TIMESTAMP  : POSIXct, format: "2019-07-02 05:40:00" "2019-07-02 05:45:00" ...
#>  $ WATER_LEVEL: num  356 356 356 356 356 ...
#>  $ QA_QC_WL   : num  1 1 1 1 1 1 1 1 1 1 ...
#>  $ DISCHARGE  : logi  NA NA NA NA NA NA ...
#>  $ QA_QC_DIS  : logi  NA NA NA NA NA NA ...
#>  - attr(*, "spec")=
#>   .. cols(
#>   ..   STATION_ID = col_character(),
#>   ..   TIMESTAMP = col_datetime(format = ""),
#>   ..   WATER_LEVEL = col_double(),
#>   ..   GRADE_WL = col_logical(),
#>   ..   SYMBOL_WL = col_logical(),
#>   ..   QA_QC_WL = col_double(),
#>   ..   DISCHARGE = col_logical(),
#>   ..   GRADE_DIS = col_logical(),
#>   ..   SYMBOL_DIS = col_logical(),
#>   ..   QA_QC_DIS = col_logical()
#>   .. )
```

### All Stations in Province/Territory

You can grab all the data for a given province/territory by setting
`all_stns=TRUE`.

``` r
all_stn_data <- dd_hydro_data(prov_terr = "YT", all_stns = TRUE)
#> No encoding supplied: defaulting to UTF-8.
str(all_stn_data)
#> Classes 'spec_tbl_df', 'tbl_df', 'tbl' and 'data.frame': 35414 obs. of  6 variables:
#>  $ STATION_ID : chr  "10MD001" "10MD001" "10MD001" "10MD001" ...
#>  $ TIMESTAMP  : POSIXct, format: "2019-07-02 07:00:00" "2019-07-02 07:05:00" ...
#>  $ WATER_LEVEL: num  3.55 3.54 3.55 3.54 3.55 ...
#>  $ QA_QC_WL   : num  1 1 1 1 1 1 1 1 1 1 ...
#>  $ DISCHARGE  : num  36.6 35.6 36.6 35.8 36.6 36 36.4 36.1 36.6 36.2 ...
#>  $ QA_QC_DIS  : num  1 1 1 1 1 1 1 1 1 1 ...
#>  - attr(*, "spec")=
#>   .. cols(
#>   ..   STATION_ID = col_character(),
#>   ..   TIMESTAMP = col_datetime(format = ""),
#>   ..   WATER_LEVEL = col_double(),
#>   ..   GRADE_WL = col_logical(),
#>   ..   SYMBOL_WL = col_logical(),
#>   ..   QA_QC_WL = col_double(),
#>   ..   DISCHARGE = col_double(),
#>   ..   GRADE_DIS = col_logical(),
#>   ..   SYMBOL_DIS = col_logical(),
#>   ..   QA_QC_DIS = col_double()
#>   .. )
```
