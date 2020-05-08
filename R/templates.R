#' Applies a provided template string to a list of arguments.
#' Any argumements gives will be replaced in the template via placeholders wrapped in <<argument>>
#'
#' @param template A string with placeholders that can be replaced with the given arguments.
#' @param arguments Named list with values used for the template placeholders.
#'
#' @return A string based on the template with the diferent argumetns applied.
#'
#' @export
applyTemplate <- function(template, arguments = list()) {
  do.call(
    glue::glue,
    modifyList(
      list(
          template,
          .open = "<<",
          .close = ">>"
      ),
      arguments
    )
  )
}

#' Generates the folder structure required for the pwa files.
#'
#' @export
createDirectories <- function() {
  dir.create("www/pwa", recursive = TRUE, showWarnings = FALSE)
}


#' Creates the service worker file based of the package template file.
#'
#' @export
createServiceWorker <- function() {
  file.copy(paste0(system.file("pwa", package = "shiny.pwa"), "/", "service-worker.js"), paste0(getwd(), "/www/"))
}

#' Creates the pwa icon file based on the given path.
#'
#' @param icon Path to the icon used for PWA installations.
#'
#' @export
createIcon <- function(icon) {
  file.copy(icon, paste0(getwd(), "/www/pwa/icon.png"), overwrite = TRUE)
}


#' Creates the offline landing page.
#'
#' @param title title of the page when the pwa is running in offline mode.
#' @param template HTML template to be used. If null a default template is used.
#' @param offline_message An argument that can be used in the offline template to show a custom message.
#'
#' @export
createOfflinePage <- function(title, template, offline_message) {
  if(is.null(template)) {
    offline_arguments <- list(
      title = title,
      message = offline_message
    )

    writeLines(
      applyTemplate(
        read_file(paste0(system.file("pwa", package = "shiny.pwa"), "/", "offline.html")),
        offline_arguments
      ),
      paste0(getwd(), "/www/pwa/offline.html")
    )
  } else {
    file.copy(template, paste0(getwd(), "/www/pwa/offline.html"), overwrite = TRUE)
  }
}

#' Creates the manifest file.
#'
#' @param title title of the page when the pwa is running in offline mode.
#' @param start_url The ull url where the app is hosted.
#' @param color An argument that can be used in the offline template to show a custom message.
#'
#' @export
createManifest <- function(title, start_url, color) {
  manifest_arguments <- list(
    name = title,
    short_name = title,
    start_url = start_url,
    background_color = color,
    theme_color = color,
    description = title,
    icon = "icon.png"
  )
  writeLines(
    applyTemplate(
      read_file(paste0(system.file("pwa", package = "shiny.pwa"), "/", "manifest.json")),
      manifest_arguments
    ),
    paste0(getwd(), "/www/pwa/manifest.json")
  )
}
