#' dd_hydro_meta
#' @description Get metadata for available stations, filter by province or territory.
#' #' See \href{https://dd.weather.gc.ca/hydrometric/doc/hydrometric_README.txt}{DataMart documentation} for more info.
#' @param prov_terr Province/territory short code options are \describe{
#'   \item{NB}{New Brunswick}
#'   \item{PE}{Prince Edward Island}
#'   \item{NS}{Nova Scotia}
#'   \item{ON}{Ontario}
#'   \item{QC}{Quebec}
#'   \item{NL}{Newfoundland}
#'   \item{MB}{Manitoba}
#'   \item{AB}{Alberta}
#'   \item{SK}{Saskatchewan}
#'   \item{NU}{Nunavut}
#'   \item{NT}{Northwest Territories}
#'   \item{BC}{British Columbia}
#'   \item{YT}{Yukon}
#' }
#' @return Tibble with following columns \describe{
#'   \item{STATION_ID}{WSC station identifier. See \code{?dd_hydro_meta}}
#'   \item{STATION_NAME}{Official WSC station name}
#'   \item{STATION_LAT}{Station latitude}
#'   \item{STATION_LON}{Station longitude}
#'   \item{PROV_TERR}{Province/territory short code}
#' }
#' @export
#' @examples
#' dd_hydro_meta(prov_terr = "ON")
#'

dd_hydro_meta <- function(prov_terr){

  # Clean column names for table
  cols <- c(
    "STATION_ID", "STATION_NAME", "STATION_LAT",
    "STATION_LON", "PROV_TERR", "TIMEZONE"
  )

  # Url for metadata csv file
  meta_url <- "https://dd.weather.gc.ca/hydrometric/doc/hydrometric_StationList.csv"

  # Perform request
  meta_res <- tryCatch({
    httr::GET(meta_url)
  }, error = function(e){
    return(e)
  })

  # Check for error in response
  if(sum(grepl("error", class(meta_res)))){
    stop("Query returned error: ", meta_res$message)
  }

  # Get text from response
  meta_cont <- httr::content(meta_res, "text")

  # Parse text
  meta_tab <- readr::read_csv(
    meta_cont,
    col_names = cols,
    # First row is messy headers
    skip = 1
    )

  # Check for region filter
  if(!missing(prov_terr)){

    # Check that code is valid
    if(!valid_prov_terr(prov_terr)){
      stop("Invalid region code. See ?dd_hydro_meta")
    }

    meta_tab <- dplyr::filter(
      .data = meta_tab,
      PROV_TERR == prov_terr
      )
  }

  meta_tab <- dplyr::select(
    meta_tab,
    -c("TIMEZONE")
  )

  # Return tibble portion of object
  return(meta_tab[])

}
