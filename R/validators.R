#' Clears and validates the provided domain
#'
#' @param domain a string representing the domain of the application
#'
#' @return A validated version of the domain
#'
#' @export
validateDomain <- function(domain) {
  if (startsWith(domain, "http://")) {
    stop("PWA is only supported with https protocols")
  }
  if (!startsWith(domain, "https://")) {
    domain <- paste0("https://", domain)
    warning("Assuming domain is running in https. To prevent this warning remember to prefix your domain with 'https://'")
  }
  if (endsWith(domain, "/")) {
    domain <- substr(domain, 1, nchar(domain) - 1)
    warning("Removing domain forward slash (/). To prevent this warning remember to not suffix your domain with '/'")
  }

  domain
}

#' Clears and validates the provided location
#'
#' @param location a string representing the domain subfolder where the appication is deployed
#'
#' @return A validated version of the location
#'
#' @export
validateLocation <- function(location) {
  if (startsWith(location, "/")) {
    location <- substr(location, 2, nchar(location))
    warning("Removing location forward slash (/). To prevent this warning remember to not prefix your location with '/'")
  }
  if (endsWith(location, "/")) {
    location <- substr(location, 1, nchar(location) - 1)
    warning("Removing location forward slash (/). To prevent this warning remember to not suffix your location with '/'")
  }

  location
}

#' Validates the provided icon. If the icon doesnt exist returns a default one
#'
#' @param icon Path location for an icon relative to the project root
#'
#' @return A valid icon path
#'
#' @export
validateIcon<- function(icon) {
  if (is.null(icon) || icon == "") {
    warning("Icon not set. Using default package icon.")
    icon <- paste0(system.file("pwa", package = "shiny.pwa"), "/", "icon.png")
  } else {
    if (!endsWith(domain, "png")) {
      stop("Only png icons are supported")
    }
    if (!startsWith(icon, "/")) {
      icon <- paste0("/", icon)
    }
    icon <- paste0(getwd(), icon)
    if (is.null(icon) || !file.exists(icon)) {
      warning("Icon doesnt exist. Using default package icon. Make sure your icon path is relative to the project root")
      icon <- paste0(system.file("pwa", package = "shiny.pwa"), "/", "icon.png")
    }
  }
  icon
}
