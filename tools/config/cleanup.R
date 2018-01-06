# source shared tools
path <- "tools/config/shared.R"
shared <- readChar(path, file.info(path)$size, TRUE)
eval(parse(text = shared))

# figure out the current package's name
DESCRIPTION <- read.dcf("DESCRIPTION", all = TRUE)
fmt <- "* cleaning package '%s' ..."
message(sprintf(fmt, DESCRIPTION$Package))

# overlay user configuration
envir <- new.env(parent = globalenv())
files <- list.files("tools/config/cleanup", pattern = "[.][rR]$", full.names = TRUE)
for (file in files) {
    fmt <- "** sourcing '%s'"
    message(sprintf(fmt, file))
    source_file(file, envir = envir)
}

# apply cleanup script (if any)
if (exists("cleanup", envir = envir, inherits = FALSE)) {
    cleanup <- get("cleanup", envir = envir, inherits = FALSE)
    message("** executing user-defined cleanup script")
    cleanup()
}

fmt <- "* successfully cleaned package '%s'"
message(sprintf(fmt, DESCRIPTION$Package))
