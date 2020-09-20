#' Returns a set of tags required for registering the pwa.
#'
#' @param title Title of the app
#' @param icon Name of the icon file to be user
#' @param color color used for the UI on the installed pwa
#' @param location subdirectory where the app is hosted. Only required if the app is not on the root domain.
#'
#' @importFrom htmltools tags
#' @return A UI definition that can be passed to the [shinyUI] function.
#'
#' @family dependencies
#' @seealso [generateFiles()]
loadDependencies <- function(title, icon, color, location) {
  register_worker <- tags$script(
    applyTemplate(
      read_file(getTemplate("register-worker.js")),
      list(location = location)
    )
  )

  tags$head(
    # Because of how scopes work for service workers
    # the worker needs to be initialized directly from the index file.
    register_worker,

    tags$link(rel = "manifest", href = "pwa/manifest.json"),
    tags$link(rel = "apple-touch-icon", href = icon),
    tags$meta(name = "description", content = title),
    tags$meta(name = "theme-color", content = color),
    tags$meta(name = "apple-mobile-web-app-status-bar-style", content = color),
    tags$meta(name = "apple-mobile-web-app-capable", content = "yes")
  )
}

#' Generates the required files for enabling the pwa.
#'
#' @param title The title of your Shiny app
#' @param domain the base URL where the app is hosted
#' @param location subdirectory where the app is hosted. Only required if the app is not on the root domain.
#' @param output Relative folder where to create the service worker file.
#'    Usually corresponds to the folder used by shiny to serve static files,
#'    this folder must exist and is usually the www folder of your shiny project.
#' @param offline_template Path to the offline template you want to use. If left NULL the default template is used.
#' @param offline_message When using the default offline page template, message to be displayed.
#' @param icon Icon Path to be used for the app. Size should be 512x512px. If left NULL a default icon is provided.
#' @param color Color of the app. Used to color the browser elements when the pwa is installed.
#'
#' @return A UI definition that can be passed to the [shinyUI] function.
generateFiles <- function(title, domain, location, output, offline_template, offline_message, icon, color) {
  createDirectories()
  createIcon(icon)
  createOfflinePage(title, offline_template, offline_message)
  createManifest(title, paste0(domain, location), color)

  if (!is.null(output)) {
    createServiceWorker(output)
  }
}
