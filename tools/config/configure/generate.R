source("R/utils.R")

# generate configure.R
concatenate_files(
    c("R/utils.R", "tools/config/configure/resources/run-configure.R"),
    "tools/config/configure.R"
)

# generate cleanup.R
concatenate_files(
    c("R/utils.R", "tools/config/configure/resources/run-cleanup.R"),
    "tools/config/cleanup.R"
)

# copy to 'inst'
configure_file("tools/config/configure.R", "inst/resources/tools/config/configure.R")
configure_file("tools/config/cleanup.R",   "inst/resources/tools/config/cleanup.R")
