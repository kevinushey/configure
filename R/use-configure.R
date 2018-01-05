#' Add Configure Infrastructure to an R Package
#'
#' Add the infrastructure needed to configure an R package.
#'
#' @param package The path to the top-level directory of an \R package.
#' @export
use_configure <- function(package = ".") {

    # find resources
    package <- normalizePath(package, winslash = "/")
    resources <- system.file("resources", package = "configure")

    # copy into temporary directory
    dir <- tempfile("configure-")
    on.exit(unlink(dir, recursive = TRUE), add = TRUE)

    dir.create(dir)
    file.copy(resources, dir, recursive = TRUE)

    # rename resources directory
    owd <- setwd(dir)
    on.exit(setwd(owd), add = TRUE)
    file.rename(basename(resources), basename(package))

    # now, copy these files back into the target directory
    file.copy(basename(package), dirname(package), recursive = TRUE)
}
