#' Retrieve the Global Configuration Database
#'
#' Retrieve the global configuration database (as an \R environment).
#'
#' @family configure-db
#'
#' @export
configure_database <- local({
    database <- new.env(parent = emptyenv())
    function() database
})

#' Define Variables for the Configuration Database
#'
#' Define variables to be used as part of the default configuration database.
#' These will be used by [configure_file()] when no configuration database
#' is explicitly supplied.
#'
#' @param ... A set of named arguments, mapping configuration names to values.
#'
#' @family configure-db
#'
#' @export
configure_define <- function(...) {
    envir <- configure_database()
    list2env(list(...), envir = envir)
}
