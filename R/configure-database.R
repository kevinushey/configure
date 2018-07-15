#' Retrieve the Global Configuration Database
#'
#' Retrieve the global configuration database.
#' `db` is a helper alias for the database
#' returned by `configure_database()`.
#'
#' @export
configure_database <- local({
    database <- new.env(parent = emptyenv())
    class(database) <- "configure_database"
    function() database
})

#' @export
print.configure_database <- function(x, ...) {
    str.configure_database(x, ...)
}

#' @export
str.configure_database <- function(object, ...) {
    writeLines("<configure database>")
    objects <- mget(ls(envir = object, all.names = TRUE), object)
    output <- utils::capture.output(utils::str(objects, ...))
    writeLines(output[-1])
    invisible(output)
}

#' Define Variables for the Configuration Database
#'
#' Define variables to be used as part of the default configuration database.
#' These will be used by [configure_file()] when no configuration database
#' is explicitly supplied. [define()] is provided as a shorter alias for the
#' same function.
#'
#' @param ... A set of named arguments, mapping configuration names to values.
#'
#' @export
configure_define <- function(...) {
    envir <- configure_database()
    list2env(list(...), envir = envir)
}

#' @rdname configure_define
#' @export
define <- configure_define

#' @rdname configure_database
#' @export
db <- configure_database()
