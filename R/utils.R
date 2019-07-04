#' valid_prov_terr
#' @description Checks user-provided province/territory short code to
#' ensure it's one of the options.
#' @noRd
#' @keywords internal
#'
valid_prov_terr <- function(prov_terr){
  prov_terr %in% c(
    "NB","PE","NS",
    "ON","QC","NL",
    "MB","AB","SK",
    "NU","NT","BC",
    "YT"
  )
}

#' has_internet
#' @noRd
#' @description Checks if connection to internet can be made. Useful to check before running API-related tests
#' @author Sam Albers
#' @keywords internal
has_internet <- function(){
  z <- try(suppressWarnings(
    readLines('https://www.google.ca', n = 1)
  ), silent = TRUE)
  !inherits(z, "try-error")
}
