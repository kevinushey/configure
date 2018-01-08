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

    LICENSE <- read_file("tools/config/resources/LICENSE")
    concatenate_files(shared, "tools/config.R", preamble = LICENSE)

    # copy to inst
    paths <- c(
        "tools/config.R",
        "configure",
        "configure.win",
        "cleanup",
        "cleanup.win"
    )

    lapply(paths, function(path) {
        configure_file(path, file.path("inst/resources", path))
    })

})
