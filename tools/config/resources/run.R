if (!interactive()) {

    # extract path to install script
    args <- commandArgs(TRUE)
    type <- args[[1]]

    # report start of execution
    package <- Sys.getenv("R_PACKAGE_NAME", unset = "<unknown>")
    fmt <- "** preparing to %s package '%s' ..."
    message(sprintf(fmt, type, package))

    # execute the requested script
    path <- sprintf("tools/config/%s.R", type)
    if (file.exists(path)) source_file(path)

    # perform automatic configuration
    configure_auto(type = type)

    # report end of execution
    fmt <- "** finished %s for package '%s'"
    message(sprintf(fmt, type, package))

}
