if (!interactive()) {

    # extract path to install script
    args <- commandArgs(TRUE)
    type <- args[[1]]

    # preserve working directory
    owd <- getwd()
    on.exit(setwd(owd), add = TRUE)

    # switch working directory to the calling scripts's directory as set
    # by the shell, in case the R working directory was set to something else
    basedir <- Sys.getenv("PWD", unset = NA)
    if (!is.na(basedir))
        setwd(basedir)

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
