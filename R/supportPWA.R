#' Adds PWA app support.
#'
#' @param base_url the base URL where the app is hosted
#' @param title The title of your Shiny app
#' @param location subdirectory where the app is hosted. Only required if the app is not on the root domain.
#' @param icon Icon to be used for the app. Should be 512x512 and saved under `www/pwa/offline.html`. A default icon is provided.
#' @param color Color for the app. Used when the app is installed to color the minified browser elements.
#' @param use_offline_template Should the default offine template be used. Your own template can be created under `www/pwa/offline.html`
#' @param offline_message When using the default offline page template, can be used to change the displayed message.
#'
#' @return A UI definition that can be passed to the [shinyUI] function.
#'
#' @note See \url{https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps}
#'   for additional details on pwas
#'
#' @examples
#' supportPWA()
#'
#' @export
supportPWA <- function(base_url,
                       title = "My Shiny PWA",
                       location = "",
                       icon = NULL,
                       color = "#000000",
                       use_offline_template = TRUE,
                       offline_message = "Looks like you are offline :O") {
  package_dir <- system.file("pwa", package = "shiny.pwa")
  project_dir <- getwd()

  # create /wwww folder if does not exist yet.
  if (!dir.exists(paste0(project_dir, "/www"))) {
    dir.create(paste0(project_dir, "/www"))
  }

  # create /wwww/pwa folder if does not exist yet
  if (!dir.exists(paste0(project_dir, "/www/pwa"))) {
    dir.create(paste0(project_dir, "/www/pwa"))
  }

  # if no icon is defined, use the default one.
  if (is.null(icon)) {
    icon <- "512.png"
    file.copy(paste0(package_dir, "/", icon), paste0(project_dir, "/www/pwa"))
  }

  # if no offline HTML page is defined, use the default one.
  if (use_offline_template) {
    offline_page <- read_file(paste0(package_dir, "/", "offline.html"))

    offline_arguments <- list(
      offline_page,
      title = title,
      message = offline_message,
      .open = "<<",
      .close = ">>"
    )
    writeLines(
      do.call(glue::glue, offline_arguments),
      paste0(project_dir, "/www/pwa/offline.html")
    )
  }

    # Creates the manifest file.
  manifest_arguments <- list(
    read_file(paste0(package_dir, "/", "manifest.json")),
    name = title,
    short_name = title,
    start_url = glue::glue("{base_url}{location}"),
    background_color = color,
    theme_color = color,
    description = title,
    icon = icon,
    .open = "<<",
    .close = ">>"
  )
  writeLines(
    do.call(glue::glue, manifest_arguments),
    paste0(project_dir, "/www/pwa/manifest.json")
  )

  # Adds the service worker file.
  file.copy(paste0(package_dir, "/", "service-worker.js"), paste0(project_dir, "/www/"))

  # adds all tags regired to the header.
  tags$head(
    tags$link(rel = "manifest", href = "pwa/manifest.json"),
    tags$link(rel = "apple-touch-icon", href = icon),
    # Because of how scopes work for service workers, the worker needs to be initialized directly from the index file.
    tags$script(HTML(glue::glue(
      "if('serviceWorker' in navigator) {
        navigator.serviceWorker
                 .register('/<<location>>service-worker.js', { scope: '/<<location>>' })
                 .then(function() { console.log('Service Worker Registered'); });
      }", .open = "<<", .close = ">>"))),
    tags$meta(name = "description", content = title),
    tags$meta(name = "theme-color", content = color),
    tags$meta(name = "apple-mobile-web-app-capable", content = "yes"),
    tags$meta(name = "apple-mobile-web-app-status-bar-style", content = color)
  )
}
