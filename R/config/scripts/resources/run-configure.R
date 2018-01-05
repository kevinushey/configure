# figure out the current package's name
DESCRIPTION <- read.dcf("DESCRIPTION", all = TRUE)
fmt <- "* configuring package '%s' ..."
message(sprintf(fmt, DESCRIPTION$Package))

# overlay user configuration
envir <- new.env(parent = globalenv())
files <- list.files("R/config/scripts", pattern = "[.][rR]$", full.names = TRUE)
for (file in files) {
    fmt <- "** sourcing '%s'"
    message(sprintf(fmt, file))
    source(file, local = envir)
}

# apply configure script (if any)
config <- list()
if (exists("configure", envir = envir, inherits = FALSE)) {
    configure <- get("configure", envir = envir, inherits = FALSE)
    message("** executing user-defined configure script")
    config <- configure()
}

fmt <- "* successfully configured package '%s'"
message(sprintf(fmt, DESCRIPTION$Package))


