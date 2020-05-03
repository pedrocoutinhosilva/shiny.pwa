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
supportPWA <- function() {
  tags$head(
    tags$link(rel="manifest", href="pwa/manifest.json"),
    tags$link(rel="apple-touch-icon", href="sick.png"),
    tags$script(HTML(glue::glue(
      "if('serviceWorker' in navigator) {
        navigator.serviceWorker
                 .register('/pwa/service-worker.js', { scope: '/pwa/' })
                 .then(function() { console.log('Service Worker Registered'); });
      }", .open = "<<", .close = ">>"))),
    tags$meta(name="description", content="PWA"),
    tags$meta(name="theme-color", content="#2F3BA2"),
    tags$meta(name="apple-mobile-web-app-capable", content="yes"),
    tags$meta(name="apple-mobile-web-app-status-bar-style", content="black")
  )
}
