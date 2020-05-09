#' Adds PWA support. Takes care of all the support required for browser to
#' recognise the application as a Progressive Web app.
#'
#' @param domain the base URL where the app is hosted
#' @param title The title of your Shiny app
#' @param location subdirectory where the app is hosted.
#'    Only required if the app is not on the root domain.
#' @param icon Icon Path to be used for the app. Size should be 512x512px.
#'    If left NULL a default icon is provided.
#' @param color Color of the app. Used to color the browser
#'    elements when the pwa is installed.
#' @param offline_template Path to the offline template you want to use.
#'    If left NULL the default template is used.
#' @param offline_message When using the default offline page template
#'    defines the message to be displayed.
#'
#' @return A UI definition that can be passed to the [shinyUI] function.
#'
#' @note For additional details on progressive web apps, visit
#'    \url{https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps}
#'
#' @examples
#' supportPWA("https://myapp.com")
#'
#' @export
supportPWA <- function(domain,
                       title = "My Shiny PWA",
                       location = "",
                       icon = NULL,
                       color = "#000000",
                       offline_template = NULL,
                       offline_message = "Looks like you are offline :/") {
  domain   <- validateDomain(domain)
  location <- validateLocation(location)
  icon     <- validateIcon(icon)

  generateFiles(title, domain, location, offline_template, offline_message, icon, color)
  loadDependencies(icon, title, color, location)
}
