source("R/utils.R")
sources <- c("R/utils.R", "R/use-configure.R", "R/config/scripts/resources/run-configure.R")
concatenate_files(sources, "R/config/configure.R")
concatenate_files(sources, "inst/resources/R/config/configure.R")
