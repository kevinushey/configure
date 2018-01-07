source("R/configure-database.R")
source("R/utils.R")

local({

    # don't run during R CMD INSTALL (this ensures this script is
    # executed only as part of 'devtools::document()')
    if (!is.na(Sys.getenv("R_PACKAGE_NAME", unset = NA)))
        return(invisible(NULL))

    # write shared components
    shared <- c(
        "R/configure-database.R",
        "R/utils.R",
        "tools/config/resources/run.R"
    )

    concatenate_files(shared, "tools/config/shared.R")

    # copy to inst
    paths <- c(
        "tools/config/shared.R",
        "configure",
        "configure.win",
        "cleanup",
        "cleanup.win"
    )

    lapply(paths, function(path) {
        configure_file(path, file.path("inst/resources", path))
    })

})
