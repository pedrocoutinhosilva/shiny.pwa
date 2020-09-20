#' Clears and validates the provided domain.
#'
#' @param domain A string representing the domain of the application
#' @return A validated version of the domain
#'
#' @family validators
#' @seealso [validateLocation()], [validateIcon()]
validateDomain <- function(domain) {
  if (startsWith(domain, "http://")) {
    stop("PWA is only supported with https protocols")
  }
  if (!startsWith(domain, "https://")) {
    domain <- paste0("https://", domain)
    message("Assuming domain is running in https.")
  }
  if (endsWith(domain, "/")) {
    domain <- substr(domain, 1, nchar(domain) - 1)
    message("Removing domain forward slash (/).")
  }
  domain
}

#' Clears and validates the provided location
#'
#' @param location a string representing the domain subfolder
#'    where the appication is deployed.
#' @return A validated version of the location
#'
#' @family validators
#' @seealso [validateDomain()], [validateIcon()]
validateLocation <- function(location) {
  if (!startsWith(location, "/")) {
    location <- paste0("/", location)
  }
  if (!endsWith(location, "/")) {
    location <- paste0(location, "/")
  }
  location
}

#' Validates the provided icon. If the icon doesnt exist returns a default one.
#'
#' @param icon Path location for an icon relative to the project root
#' @return A valid icon path
#'
#' @family validators
#' @seealso [validateDomain()], [validateLocation()]
validateIcon <- function(icon) {
  if (is.null(icon) || icon == "") {
    message("Icon not set. Using default package icon.")
    icon <- getTemplate("icon.png")
  } else {
    if (!endsWith(icon, "png")) {
      stop("Only png icons are supported")
    }
    if (!startsWith(icon, "/")) {
      icon <- paste0("/", icon)
    }
    icon <- paste0(getwd(), icon)
    if (is.null(icon) || !file.exists(icon)) {
      message("Icon doesnt exist. Using default package icon.")
      icon <- getTemplate("icon.png")
    }
  }
  icon
}
