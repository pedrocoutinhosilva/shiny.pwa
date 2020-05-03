#' Adds PWA app support.
#'
#' @return A UI definition that can be passed to the [shinyUI] function.
#'
#' @note See \url{https://css-tricks.com/snippets/css/complete-guide-grid/}
#'   for additional details on using css grids
#'
#' @examples
#' supportPWA()
#'
#' @export
supportPWA <- function(title = "My Shiny PWA",
                       location = "/",
                       icon = NULL,
                       color = "#bada55",
                       offline_page = NULL,
                       offline_message = "Looks like you are offline :O") {
  # TODO copy files from inst

  package_dir <- system.file("pwa", package = "shiny.pwa")
  project_dir <- getwd()

  # create /wwww folder if does not exist yet
  if (!dir.exists(paste0(project_dir, "/www"))) {
    dir.create(paste0(project_dir, "/www"))
  }
  if (!dir.exists(paste0(project_dir, "/www/pwa"))) {
    dir.create(paste0(project_dir, "/www/pwa"))
  }

  if (is.null(icon)) {
    icon <- "512.png"
    file.copy(paste0(package_dir, "/", icon), paste0(project_dir, "/www/pwa"))
  }

  if (is.null(offline_page)) {
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

  manifest_arguments <- list(
    read_file(paste0(package_dir, "/", "manifest.json")),
    name = title,
    short_name = title,
    start_url = location,
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

  file.copy(paste0(package_dir, "/", "service-worker.js"), paste0(project_dir, "/www/"))

  tags$head(
    tags$link(rel = "manifest", href = "pwa/manifest.json"),
    tags$link(rel = "apple-touch-icon", href = icon),
    tags$script(HTML(glue::glue(
      "if('serviceWorker' in navigator) {
        navigator.serviceWorker
                 .register('<<location>>/service-worker.js', { scope: '<<location>>/' })
                 .then(function() { console.log('Service Worker Registered'); });
      }", .open = "<<", .close = ">>"))),
    tags$meta(name = "description", content = title),
    tags$meta(name = "theme-color", content = color),
    tags$meta(name = "apple-mobile-web-app-capable", content = "yes"),
    tags$meta(name = "apple-mobile-web-app-status-bar-style", content = color)
  )
}
