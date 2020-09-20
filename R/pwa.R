#' Adds PWA support. Takes care of all the support required for browsers to
#' recognise the application as a Progressive Web app.
#'
#' @param domain The base URL where the app is hosted
#' @param title The title of your Shiny app
#' @param output Relative folder where to create the service worker file.
#'    Usually corresponds to the folder used by shiny to serve static files,
#'    this folder must exist and is usually the www folder of your shiny project.
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
#' if (interactive()){
#' library(shiny.pwa)
#' ui <- fluidPage(
#'   pwa("https://myapp.com", output = "www")
#' )
#' server <- function(input, output, session) {
#' }
#' shinyApp(ui, server)
#' }
#'
#' @importFrom urltools domain
#' @importFrom urltools path
#'
#' @export
pwa <- function(domain,
                title = "My Shiny PWA",
                output = NULL,
                icon = NULL,
                color = "#000000",
                offline_template = NULL,
                offline_message = "Looks like you are offline :/") {

  if (is.null(output)) {
    message(
      "No output folder provided, dependencies will be attached but no service worker file will be created.",
      "If you need a service worker file, provide the path used my your application to serve static files ",
      "(usually www) using the output argument or use shiny.pwa::createServiceWorker(output_folder) ",
      "to create one based on the package default template."
    )
  } else {
    if (!dir.exists(file.path(getwd(), output))) {
      stop("Provided output folder does not exist, please create it.")
    }
  }

  location <- validateLocation(ifelse(!is.na(path(domain)), path(domain), ""))
  domain   <- validateDomain(domain(domain))
  icon     <- validateIcon(icon)

  generateFiles(title, domain, location, output, offline_template, offline_message, icon, color)

  shiny::addResourcePath("pwa", paste0(tempdir(), "/www/pwa"))

  loadDependencies(icon, title, color, location)
}
