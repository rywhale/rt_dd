#' dd_to_zrxp
#' @description Convert data file to zrxp for WISKI ingestion.
#' @param stn_data The time series data being converted. Should be two columns \describe{
#'  \item{First column}{Timestamp}
#'  \item{Second column}{Value}
#' }
#' @param stn_import_num The WISKI import number for time series data being converted.
#' @param min_timestamp POSIXct format timestamp. The minimum timestamp to filter for before exporting.
#' @return Vector of lines to write to .zrxp file
#' @export
#'

dd_to_zrxp <- function(stn_data, stn_import_num, min_timestamp) {

  import_num <- paste0(
    "#REXCHANGE", stn_import_num,
    "|*|LAYOUT(timestamp,value)|*|"
  )

  if(ncol(stn_data) > 2){
    stop("Station data should have two columns: timestamp and value")
  }

  names(stn_data) <- c("Timestamp", "Value")


  if(!nrow(stn_data)){
    stop("Station data should have rows of data")
  }

  stn_data <- dplyr::mutate(
    stn_data,
    Timestamp = gsub("-|:| ", "", Timestamp)
  )

  if(!missing(min_timestamp)){

    if("POSIXct" %in% class(min_timestamp)){
      stn_data <- dplyr::filter(
        stn_data >= min_timestamp
      )

    }

  }

  out_dat <- purrr::map(
    stn_data$Timestamp,
    function(step){
      step_val <- stn_data$Value[stn_data$Timestamp == step]

      return(
        paste(step, step_val)
      )
    }
  )


  # Stick import number in first spot
  out_dat <- append(unlist(out_dat), import_num, after = 0)

  return(out_dat)
}

