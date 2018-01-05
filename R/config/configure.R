# utils.R ----

#' Configure a File
#'
#' Configure a file, replacing any instances of `@`-delimited variables, e.g.
#' `@VAR@`, with the value of the variable called `VAR` in the associated
#' `config` environment.
#'
#' @param source The file to be configured.
#' @param target The file to be generated.
#' @param config The configuration environment.
#' @param verbose Boolean; report files as they are configured?
#'
#' @export
configure_file <- function(
    source,
    target = sub("[.]in$", "", source),
    config = read_config(),
    verbose = getOption("configure.verbose", TRUE))
{
    contents <- readLines(source, warn = FALSE)
    enumerate(config, function(key, val) {
        needle <- paste("@", key, "@", sep = "")
        replacement <- val
        contents <<- gsub(needle, replacement, contents)
    })

    ensure_directory(dirname(target))
    writeLines(contents, con = target)

    if (isTRUE(verbose)) {
        fmt <- "** configured file: '%s' => '%s'"
        message(sprintf(fmt, source, target))
    }
}

#' Read R Configuration for a Package
#'
#' Read the \R configuration, as through `R CMD config --all`.
#'
#' @param package The path to an \R package's sources.
#'
#' @export
read_config <- function(package = ".") {

    # move to requested directory
    owd <- setwd(package)
    on.exit(setwd(owd), add = TRUE)

    # read R configuration
    R <- file.path(R.home("bin"), "R")
    config <- system2(R, c("CMD", "config", "--all"), stdout = TRUE)

    # parse configuration
    equalsIndex <- regexpr("=", config, fixed = TRUE)
    keys <- trim_whitespace(substring(config, 1, equalsIndex - 1))
    vals <- trim_whitespace(substring(config, equalsIndex + 1))
    names(vals) <- keys

    list2env(as.list(vals), parent = globalenv())
}

#' Concatenate the Contents of a Set of Files
#'
#' Given a set of files, concatenate their contents into
#' a single file.
#'
#' @param sources An \R list of files
#' @param target The file to use for generation.
#' @param headers Headers to be used for each file copied.
#'
#' @export
concatenate_files <- function(
    sources,
    target,
    headers = sprintf("# %s ----", basename(sources)))
{
    pieces <- vapply(seq_along(sources), function(i) {
        source <- sources[[i]]
        header <- headers[[i]]
        contents <- trim_whitespace(read_file(source))
        paste(header, contents, "", sep = "\n\n")
    }, character(1))

    ensure_directory(dirname(target))
    writeLines(pieces, con = target)
}

ensure_directory <- function(dir) {
    info <- file.info(dir)

    # no file exists at this location; try to make it
    if (is.na(info$isdir)) {
        dir.create(info$isdir, recursive = TRUE, showWarnings = FALSE)
        if (!file.exists(dir))
            stop("failed to create directory '", dir, "'")
        return(TRUE)
    }

    # a directory already exists
    if (isTRUE(info$isdir))
        return(TRUE)

    # a file exists, but it's not a directory
    stop("file already exists at path '", dir, "'")
}

enumerate <- function(x, f, ...) {
    nms <- if (is.environment(x)) ls(envir = x) else names(x)
    lapply(nms, function(nm) {
        f(nm, x[[nm]], ...)
    })
}

read_file <- function(path) {
    readChar(path, file.info(path)$size, TRUE)
}
trim_whitespace <- function(x) {
    gsub("^[[:space:]]*|[[:space:]]*$", "", x)
}


# use-configure.R ----

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


# run-configure.R ----

# figure out the current package's name
DESCRIPTION <- read.dcf("DESCRIPTION", all = TRUE)
fmt <- "* configuring package '%s' ..."
message(sprintf(fmt, DESCRIPTION$Package))

# read R configuration
message("** executing R CMD config --all")
config <- read_config()

# overlay user configuration
envir <- new.env(parent = globalenv())
files <- list.files("R/config/scripts", pattern = "[.][rR]$", full.names = TRUE)
for (file in files) {
    fmt <- "** sourcing '%s'"
    message(sprintf(fmt, file))
    source(file, local = envir)
}

# apply configure script (if any)
if (exists("configure", envir = envir, inherits = FALSE)) {
    configure <- get("configure", envir = envir, inherits = FALSE)
    message("** executing user-defined configure script")
    configure(config)
}

# configure .in files
inputs <- list.files(pattern = "[.]in$", recursive = TRUE)
for (input in inputs)
    configure_file(input, config = config, verbose = TRUE)

fmt <- "* successfully configured package '%s'"
message(sprintf(fmt, DESCRIPTION$Package))


