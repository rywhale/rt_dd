#' dd_hydro_data
#' @description Get near real-time data for Water Survey of Canada gauges via DataMart.
#' #' See \href{https://dd.weather.gc.ca/hydrometric/doc/hydrometric_README.txt}{DataMart documentation} for more info.
#' @param station_id The official Water Survey of Canada gauge ID. See \code{?dd_hydro_meta}
#' @param prov_terr Province/territory short code. \describe{
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
#' @param update_interval \describe{
#'   \item{hourly}{(Default) Last 2 complete days of data plus the current incomplete day}
#'   \item{daily}{Last 30 complete days of data plus the current incomplete day}
#' }
#' @param all_stns \describe{
#'   \item{FALSE}{(Default) Only return data for stations specified with station_id}
#'   \item{TRUE}{Return data for all stations in region specified with prov_terr}
#' }
#' @return Tibble with following columns \describe{
#'   \item{STATION_ID}{WSC station identifier. See \code{?dd_hydro_meta}}
#'   \item{TIMESTAMP}{Timestamp for measurement in UTC}
#'   \item{WATER_LEVEL}{Water level measurement (m). See WSC website for datumn info.}
#'   \item{QA_QC_WL}{Quality assurance/quality control flag for the water level (1 = preliminary, 2 = reviewed, 3 = checked, 4 = approved)}
#'   \item{DISCHARGE}{Discharge measurement (cms)}
#'   \item{QA_QC_DIS}{Quality assurance/quality control flag for the discharge (1 = preliminary, 2 = reviewed, 3 = checked, 4 = approved)}
#' }
#' @examples
#' dd_hydro_data(station_id = "02HA006", prov_terr = "ON")
#'

dd_hydro_data <- function(station_id, prov_terr, update_interval = "hourly", all_stns = FALSE) {

  # Base url for queries
  base_url <- "https://dd.weather.gc.ca/hydrometric/csv"

  # Clean column names
  cols <- c(
    "STATION_ID", "TIMESTAMP", "WATER_LEVEL",
    "GRADE_WL", "SYMBOL_WL", "QA_QC_WL",
    "DISCHARGE", "GRADE_DIS", "SYMBOL_DIS", "QA_QC_DIS"
    )

  if(!update_interval %in% c("daily", "hourly")){
    stop("update_interval must be 'daily' or 'hourly'.")
  }

  if(missing(station_id) & !all_stns){
    stop("Must provide station_id unless `all_stns=TRUE`. See ?dd_hydro_data")
  }

  # Check for valid prov_terr code
  if(missing(prov_terr) | !valid_prov_terr(prov_terr)){
    stop("Must provide valid prov_terr code. See ?dd_hydro_meta.")
  }

  if(all_stns){
    f_name <- paste0(prov_terr, "_", update_interval, "_hydrometric.csv")
  }else{
    f_name <- paste0(prov_terr, "_", station_id, "_", update_interval, "_hydrometric.csv")
  }

  data_url <- file.path(base_url, prov_terr, update_interval, f_name)

  data_res <- tryCatch({
    httr::GET(data_url)
  }, error = function(e){
    return(e)
  })

  # Check for error in response
  if(sum(grepl("error", class(data_res)))){
    stop("Query returned error: ", data_res$message)
  }

  # Get text from response
  data_cont <- httr::content(data_res, "text")

  # Parse text
  data_tab <- readr::read_csv(
    data_cont,
    col_names = cols,
    # First row is messy headers
    skip = 1
  )

  # Get rid of columns that currently
  # have no purpose (future use)
  data_tab <- dplyr::select(
    .data = data_tab,
    -c("GRADE_WL", "SYMBOL_WL", "GRADE_DIS", "SYMBOL_DIS")
    )

  # Return tibble portion of object
  return(data_tab[])
}
